class Event:
    def __init__(self, content):
        self.Host = content["Host"]
        self.PrettyHost = content["PrettyHost"]
        self.Port = content["Port"]
        self.Method = content["Method"]
        self.Scheme = content["Scheme"]
        self.Authority = content["Authority"]
        self.Path = content["Path"]
        self.HttpVersion = content["HttpVersion"]
        self.Headers = content["Headers"]
        self.Content = content["Content"]
        self.Trailers = content["Trailers"]
        self.Timestamp = content["Timestamp"]
        self.Meta = content["Meta"]

    def findHeader(self, header):
        for item in self.Headers:
            if item["Key"].casefold() == header.casefold():
                return item["Value"]
        return None

    def setHeader(self, key, value):
        for item in self.Headers:
            if item["Key"].casefold() == key.casefold():
                item["Value"] = value
                return
        self.Headers.append({"Key": key, "Value": value})

    def getUrl(self):
        return f"{self.Scheme}://{self.PrettyHost}:{self.Port}{self.Path}"

    def getHeadersAsDict(self):
        res = {}
        for item in self.Headers:
            res[item["Key"]] = item["Value"]
        return res

    def toDict(self):
        return {
            "Host": self.Host,
            "PrettyHost": self.PrettyHost,
            "Port": self.Port,
            "Method": self.Method,
            "Scheme": self.Scheme,
            "Authority": self.Authority,
            "Path": self.Path,
            "HttpVersion": self.HttpVersion,
            "Headers": self.Headers,
            "Content": self.Content,
            "Trailers": self.Trailers,
            "Timestamp": self.Timestamp,
            "Meta": self.Meta
        }

    def copy(self):
        res = Event(self.toDict())
        res.Headers = []
        for item in self.Headers:
            res.Headers.append({"Key": item["Key"], "Value": item["Value"]})
        res.Trailers = []
        for item in self.Trailers:
            res.Trailers.append({"Key": item["Key"], "Value": item["Value"]})
        res.Meta = {}
        for key, value in self.Meta.items():
            res.Meta[key] = value
        return res
