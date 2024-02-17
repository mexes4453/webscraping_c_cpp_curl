#!/bin/bash

#: << "#FETCH_SYMBOL"
#LAST_PAGE_NBR=712
LAST_PAGE_NBR=712
PAGE_IDX=1

# Output file to store the raw data for further post processing
FILE_SYM="data_stock_symbols.txt"
FILE_FILTER_SYM="symbols.txt"

# Url - from which data is fetched from
URL='https://www.nyse.com/api/quotes/filter'

# populate Json data for query
# page number is dynamic and would be added in the while loop using the loop idx as page number
DATA_1='{"instrumentType":"EQUITY"'
DATA_1+=',"pageNumber":'
DATA_2+=',"sortColumn":"NORMALIZED_TICKER","sortOrder":"ASC","maxResultsPerPage":10,"filterToken":""}'


# create output file if it does not exist
if [ -f $FILE_SYM ] 
then 
    echo "file exist"
else 
    echo "file does not exist. Creating file ..."
    touch $FILE_SYM
fi



# fetch all symbols recursively.
while [ $PAGE_IDX -le $LAST_PAGE_NBR ]
do
    #echo $HEADER
    MSG=$(printf 'Processing Page: %s\r' "$PAGE_IDX")
    echo $MSG
    DATA="${DATA_1}${PAGE_IDX}${DATA_2}"
    #echo $DATA
    curl -s $URL --compressed -X POST -H 'Content-Type: application/json' --data-raw $DATA | jq >> $FILE_SYM
    sleep 1
    (( ++PAGE_IDX ))
    
done


awk '/symbolTicker/ {print $2}' $FILE_SYM | sed 's/\"//g' | sed 's/,//g' > $FILE_FILTER_SYM
#FETCH_SYMBOL
