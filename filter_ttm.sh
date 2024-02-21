FILE_SYM='symbols.txt'
# Get the total number of company symbols available
#TOTAL_SYMBOLS=$(wc -l $FILE_SYM | awk '{print $1}')
TOTAL_SYMBOLS=20

# Initialise the index for iteration
IDX_SYM=1
rm ttm.txt
while [ $IDX_SYM -le $TOTAL_SYMBOLS ]
do 
    # Get the symbol name by current idx value
    SYM=$(awk -v sym_id=$IDX_SYM 'NR == sym_id {print}' $FILE_SYM)
    
    #MSG=$(printf 'Filter data for Symbol: %s (%s/%s)\r' "$SYM" "$IDX_SYM" "$TOTAL_SYMBOLS")
    #echo $MSG
    printf 'Filter data for Symbol: %s (%s/%s)\r' "$SYM" "$IDX_SYM" "$TOTAL_SYMBOLS"

    # process
    python3 clean_stats.py ${SYM} ${IDX_SYM}
    
    # delay
    #sleep 1

    # next item (iteration)
    (( ++IDX_SYM ))
done

#sed -n 's/,/\t/gp' ./ttm.txt | column -t -N $(cat db.txt)
sed -n 's/,/\t/gp' ./ttm.txt | sed 's/^.*nil.*$//p' | column -t -N $(cat db.txt)