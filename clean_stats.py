import json
from pprint import pprint as pp
import sys


total_nbr = 10
symbol = sys.argv[1]
id = sys.argv[2]
file_name_hist   = symbol + "_HIST.json"
file_name_val    = symbol + "_VAL.json"
file_name_stock  = symbol + "_STOCK_PRICE.json"
file_name_shares = symbol + "_SHARES_INFO.json"

output_file = "ttm.txt"



def jsonFileToDictObj(file_name):
    with open(file_name, 'r') as f:
        data = json.load(f)
        f.close()
    return data




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



def getHistTrailingItemFromDict(db, dbKey):
    data = "nil"
    try:
        for entry in db:
            if (dbKey in entry.keys()):
                data = entry[dbKey][0]['reportedValue']['raw']
                break 
    except:
        print(dbKey, ": something went wrong")
        raise
    return (data)




def shwAllHeaderData(header_list):
    for header in header_list:
        shwData(res, header)


def getItemFromDict(dictObj, itemKey):
    result = 'nil'
    data = None
    if dictObj == None:
        result = 'nil'
    elif itemKey in dictObj.keys():
        data = (dictObj[itemKey])
        if type(data) == int or type(data) == str:
            result = data
        else:
            result = data['raw']
    return (result)


if __name__ == "__main__":
    # open json files and get it as dict obj.
    #for idx in range(1, total_nbr):
    data_hist = jsonFileToDictObj(file_name_hist)
    #data_val = jsonFileToDictObj(file_name_val)
    #data_stk = jsonFileToDictObj(file_name_stock)
    data_shares = jsonFileToDictObj(file_name_shares)
    res_shares = None
    sep = ","
    try:
        res_shares = data_shares["quoteResponse"]["result"][0]
        res_hist_inc = data_hist["timeseries"]['result']
    except(IndexError):
        print ("symbol %s: data not found\n" %symbol)
    #pp(data_shares)
        
    outResult = open(output_file, 'a')
    txt = ''
    # id and symbol
    txt += (str(id) + sep + symbol)
    
    # company name
    company_name = getItemFromDict(res_shares, "longName")
    company_name = company_name.replace(",", ' ')
    company_name = company_name.replace(" ", '_')
    company_name = company_name.upper()
    txt += (sep  + company_name)

    # marketcap
    mktcap = getItemFromDict(res_shares, "marketCap")
    txt += (sep + str(mktcap))

    # stk price
    regMktPrice = getItemFromDict(res_shares, "regularMarketPrice")
    txt += (sep  + str(regMktPrice))

    # shares outstanding
    shareOutstanding = getItemFromDict(res_shares, "sharesOutstanding")
    txt += (sep + str(shareOutstanding))


    # gross profit 
    gross_profit = getHistTrailingItemFromDict(res_hist_inc, "trailingGrossProfit")
    txt += (sep + str(gross_profit))

    # operating profit 
    ops_profit = getHistTrailingItemFromDict(res_hist_inc, "trailingOperatingIncome")
    txt += (sep + str(ops_profit))

    # net profit 
    net_profit = getHistTrailingItemFromDict(res_hist_inc, "trailingNetIncome")
    txt += (sep + str(net_profit))
    outResult.write("%s" %(txt))


    #headers = getHeaders(res)
    #pp(headers)
    #shwAllHeaderData(headers)
    outResult.write("\n")
    outResult.close()
    
    # this is it