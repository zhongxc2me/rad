import json
import random
import requests

data = None
url = "http://127.0.0.1:12201/gelf"

def requests_post():
    session = requests.session()
    with open("vben-admin.log", encoding="utf-8") as f:
        lines = f.readlines()
        for line in lines: 
            print(line.encode('utf-8'))
            r = session.post(url, data=line.encode('utf-8'), verify=False)
            print(r)


if __name__ == '__main__':
    requests_post()
