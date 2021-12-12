from mitmproxy import ctx
import json
import base64
from kafka import KafkaProducer

producer = KafkaProducer(bootstrap_servers='localhost:9092', value_serializer=str.encode)

class Writer:
    def __init__(self):
        self.num = 0

    def request(self, flow):
        host = flow.request.host
        prettyHost = flow.request.pretty_host
        if host == "127.0.0.1" or host.casefold() == "localhost".casefold() or prettyHost.casefold() == "localhost".casefold():
            return
        headers = []
        if flow.request.headers:
            for k, v in flow.request.headers.items(True):
                headers.append({"Key": k, "Value": v})
        trailers = []
        if flow.request.trailers:
            for k, v in flow.request.trailers.items(True):
                trailers.append({"Key": k, "Value": v})
        data = {
            "Host": flow.request.host,
            "PrettyHost": flow.request.pretty_host,
            "Port": flow.request.port,
            "Method": flow.request.method,
            "Scheme": flow.request.scheme,
            "Authority": flow.request.authority,
            "Path": flow.request.path,
            "HttpVersion": flow.request.http_version,
            "Headers": headers,
            "Content": base64.b64encode(flow.request.content).decode('ascii'),
            "Trailers": trailers,
            "Timestamp": flow.request.timestamp_start,
            "Meta": {}
        }
        strData = json.dumps(data)
        producer.send('requests', value=strData)

addons = [
    Writer()
]
