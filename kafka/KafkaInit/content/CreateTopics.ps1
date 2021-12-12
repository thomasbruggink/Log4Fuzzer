param
(
    [string]$kafkaIp=$null
)

if($env:KafkaIp -ne $null)
{
    $kafkaIp = $env:KafkaIp
}
if($null -eq $kafkaIp)
{
    Write-Error "KafkaIp must be set"
    return;
}

$replicationFactor = 2
if($env:ReplicationFactor -ne $null)
{
    $replicationFactor = $env:ReplicationFactor
}

$partitions = 30
if($env:Partitions -ne $null)
{
    $partitions = $env:Partitions
}

$topics = @()
if($null -ne $env:Topics)
{
    $topics = $env:Topics.Split(',');
}

Write-Verbose "Using KafkaIp: '$kafkaIp'" -Verbose
Write-Verbose "Using ReplicationFactor: '$replicationFactor'" -Verbose
Write-Verbose "Using Partitions: '$partitions'" -Verbose
if($topics.Length -gt 0)
{
    Write-Verbose "Creating the following extra topics:" -Verbose
    foreach($topic in $topics)
    {
        Write-Verbose "`t- $topic" -Verbose
    }
}

function RunCommand($command)
{
    $executable = $command.Split(' ')[0]
    $arguments = $command.Substring($executable.Length)
    Start-Process $executable -ArgumentList $arguments -Wait -RedirectStandardOutput /tmp/output
    return Get-Content /tmp/output
}

function CreateTopic($topic, $kafkaIp, $replicationFactor, $partitions)
{
    $max = 50;
    $current = 0
    while($true)
    {
        $output = RunCommand "./kafka-topics.sh --create --topic $topic --partitions $partitions --replication-factor $replicationFactor --bootstrap-server $kafkaIp --config retention.ms=14400000"
        if($output -like "*Topic '$topic' already*")
        {
            Write-Verbose "Topic $topic already exists skipping";
            break;
        }
        if($output -like "*ERROR*")
        {
            $current++
            Write-Verbose "$current / $max : $output" -Verbose
            Start-Sleep -Seconds 5
            if($current -gt $max)
            {
                Write-Error "Max reached"
                exit;
            }
            continue;
        }
        break;
    }
}

foreach($topic in $topics)
{
    CreateTopic -topic $topic -kafkaIp $kafkaIp -partitions $partitions -replicationFactor $replicationFactor
}
Write-Verbose "Done" -Verbose

while($true) {
    Start-Sleep -Seconds 3600
}
