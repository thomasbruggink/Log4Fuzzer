## Setup

Device -> MitmProxy (writer.py) -> Kafka -> Fuzzer -> Kafka -> Tester -> Website

Proxy
```
./run.sh
```
Fuzzer
```
python3 ./fuzzer.py
```
Tester
```
cd tester
./gradlew run
```