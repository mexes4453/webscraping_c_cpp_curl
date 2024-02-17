from urllib.request import urlopen
from pprint import pprint


def getPage():
    response = urlopen("https://finance.yahoo.com/quote/TSLA/financials?p=TSLA")
    body = response.read()
    pprint(body)


if __name__ == "__main__":
    getPage()

