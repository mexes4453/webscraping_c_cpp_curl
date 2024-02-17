import json
from pprint import pprint as pp
res = None
with open("out.json", 'r') as f:
    data = json.load(f)
    res = data['timeseries']['result']
    #print(res)
    #print(len(res))
    #pp(res[0])



def getHeaders(res):
    headerList = [entry['meta']['type'][0] for entry in res]
    return (headerList)



def shwData(res, header):
    data_len = 0
    data = []
    for entry in res:
        if (header in entry.keys()):
            if "trailing" in header:
                print(header, entry[header][0]['reportedValue']['raw'])
            elif "quarter" in header:
                data = []
                data_len = len(entry[header])
                for idx in range(data_len):
                    data.append(entry[header][idx]['reportedValue']['raw'])
                print(header, data)


    

def shwAllHeaderData(header_list):
    for header in header_list:
        shwData(res, header)



headers = getHeaders(res)
pp(headers)
shwAllHeaderData(headers)

# this is it