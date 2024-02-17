#!/bin/bash
#-------------------------------------------
# Fetch stock data for all company in the US
# Source: Yahoo Finance
#-------------------------------------------

FILE_SYM='symbols.txt'
FILE_OUT_EXT='json'

# Get the total number of company symbols available
TOTAL_SYMBOLS=$(wc -l $FILE_SYM | awk '{print $1}')
#TOTAL_SYMBOLS=2

# Initialise the index for iteration
IDX_SYM=1

#echo $TOTAL_SYMBOLS
# valuation query
QUERY_STATS_VAL='https://query2.finance.yahoo.com/ws/fundamentals-timeseries/v1/finance/timeseries/COIN?lang=en-US&region=US&symbol=COIN&padTimeSeries=true&type=quarterlyMarketCap%2CtrailingMarketCap%2CquarterlyEnterpriseValue%2CtrailingEnterpriseValue%2CquarterlyPeRatio%2CtrailingPeRatio%2CquarterlyForwardPeRatio%2CtrailingForwardPeRatio%2CquarterlyPegRatio%2CtrailingPegRatio%2CquarterlyPsRatio%2CtrailingPsRatio%2CquarterlyPbRatio%2CtrailingPbRatio%2CquarterlyEnterprisesValueRevenueRatio%2CtrailingEnterprisesValueRevenueRatio%2CquarterlyEnterprisesValueEBITDARatio%2CtrailingEnterprisesValueEBITDARatio&merge=false&period1=493590046&period2=1708021898&corsDomain=finance.yahoo.com'

# query market price
QUERY_STOCK_PRICE='https://query1.finance.yahoo.com/v8/finance/chart/COIN?region=US&lang=en-US&includePrePost=false&interval=2m&useYfid=true&range=1d&corsDomain=finance.yahoo.com&.tsrc=finance'

# query_shares
QUERY_SHARES_INFO='https://query1.finance.yahoo.com/v7/finance/quote?formatted=true&crumb=yPf5nXC9zqM&lang=en-US&region=US&symbols=COIN&fields=messageBoardId%2ClongName%2CshortName%2CmarketCap%2CunderlyingSymbol%2CunderlyingExchangeSymbol%2CheadSymbolAsString%2CregularMarketPrice%2CregularMarketChange%2CregularMarketChangePercent%2CregularMarketVolume%2Cuuid%2CregularMarketOpen%2CfiftyTwoWeekLow%2CfiftyTwoWeekHigh%2CtoCurrency%2CfromCurrency%2CtoExchange%2CfromExchange%2CcorporateActions&corsDomain=finance.yahoo.com'
COOKIE='Cookie: A1=d=AQABBMWjoWUCEH1oCtZ1BHF1BjKL4lzMDvoFEgABCAGbz2X3ZeA9b2UBAiAAAAcIxaOhZXgkYqIIDzpZQMM1hxz2g9LsZvZ5ugkBBwoBnw&S=AQAAApQ94Nm6Ddvi1ZBhkcKL_DQ; OTH=v=2&s=2&d=eyJraWQiOiIwMTY0MGY5MDNhMjRlMWMxZjA5N2ViZGEyZDA5YjE5NmM5ZGUzZWQ5IiwiYWxnIjoiUlMyNTYifQ.eyJjdSI6eyJndWlkIjoiRDdWM0JGWkVOSldQTEtYTEcyV0xaNDJGM1UiLCJwZXJzaXN0ZW50Ijp0cnVlLCJzaWQiOiJrWnNOb04xN1ZpdEYifX0.fjNeTwBvex5fZjIBnFPIXchrVAXKeWvtgt8aFA_JizSDMt6esG7qNaC8xCHpizpK4wLQgVJV367XABw8MXWstb6Wj5EgyFSLmwVnxjzaqKoEKdq_9xM178pL4ykG6Hq36mxfgaIP1qR0vdn0SSrihcq1dGxtJsHrdXQJ9UDgN9s; A3=d=AQABBMWjoWUCEH1oCtZ1BHF1BjKL4lzMDvoFEgABCAGbz2X3ZeA9b2UBAiAAAAcIxaOhZXgkYqIIDzpZQMM1hxz2g9LsZvZ5ugkBBwoBnw&S=AQAAApQ94Nm6Ddvi1ZBhkcKL_DQ; T=af=JnRzPTE3MDUwOTIwMzcmcHM9ZDEyTGcuME01YnNMSGJ0ZlJhMm13dy0t&d=bnMBeWFob28BZwFEN1YzQkZaRU5KV1BMS1hMRzJXTFo0MkYzVQFhYwFBRmVDNk1yNwFhbAFjaGltZXgxOTg4AXNjAW1icl9sb2dpbgFmcwFISjlYcGdSbG9hUEYBenoBRlBhb2xCQTdFAWEBUUFFAWxhdAFGUGFvbEIBbnUBMA--&kt=EAA7KEktyVb_FbHuODuSOJMgw--~I&ku=FAAJ_sz6vdma8c7TLnYZsG8CoK3PbXbEYejMwyC2zWqAWt_U4vr2..CsRgK_ZspYDVdpt2acrJU.h_GS8hQV6b_ippwBvrCa9eiB89lqUYGN7V9aF42HI5UUUuyRaT8QQ8I3r6mZDXe8dmX4jjjBYwl715Ev6Gmhrvp4948kqQZT4A-~E; F=d=GrL7ysw9vNihHdrWKSjIFuCpqdzUSC5meFw3OlIH; PH=l=en-GB; Y=v=1&n=36mnscj4r1vd1&l=278c4nrzyy/o&p=m2o016i00000000&r=en&intl=uk; GUC=AQABCAFlz5tl90Id2AQn&s=AQAAALLHAz-H&g=Zc5XVQ; cmp=t=1708147440&j=1&u=1---&v=13; A1S=d=AQABBMWjoWUCEH1oCtZ1BHF1BjKL4lzMDvoFEgABCAGbz2X3ZeA9b2UBAiAAAAcIxaOhZXgkYqIIDzpZQMM1hxz2g9LsZvZ5ugkBBwoBnw&S=AQAAApQ94Nm6Ddvi1ZBhkcKL_DQ; PRF=t%3DINTC%252BGC%253DF%252BCL%253DF%252BCOIN%252BADBE%252BAMAT%252BTSLA%252BA%252BTWLO%252BINUV%252BARM%252BEVTL%252BQBTS%252BATEYY%252BAMZN%26newChartbetateaser%3D1; EuConsent=CP4RQoAP4RQoAAOACKENAnEgAAAAAAAAACiQAAAAAAAA'

# query history
QUERY_HISTORY='https://query2.finance.yahoo.com/ws/fundamentals-timeseries/v1/finance/timeseries/COIN?lang=en-US&region=US&symbol=COIN&padTimeSeries=true&type=annualTaxEffectOfUnusualItems%2CtrailingTaxEffectOfUnusualItems%2CannualTaxRateForCalcs%2CtrailingTaxRateForCalcs%2CannualNormalizedEBITDA%2CtrailingNormalizedEBITDA%2CannualNormalizedDilutedEPS%2CtrailingNormalizedDilutedEPS%2CannualNormalizedBasicEPS%2CtrailingNormalizedBasicEPS%2CannualTotalUnusualItems%2CtrailingTotalUnusualItems%2CannualTotalUnusualItemsExcludingGoodwill%2CtrailingTotalUnusualItemsExcludingGoodwill%2CannualNetIncomeFromContinuingOperationNetMinorityInterest%2CtrailingNetIncomeFromContinuingOperationNetMinorityInterest%2CannualReconciledDepreciation%2CtrailingReconciledDepreciation%2CannualReconciledCostOfRevenue%2CtrailingReconciledCostOfRevenue%2CannualEBITDA%2CtrailingEBITDA%2CannualEBIT%2CtrailingEBIT%2CannualNetInterestIncome%2CtrailingNetInterestIncome%2CannualInterestExpense%2CtrailingInterestExpense%2CannualInterestIncome%2CtrailingInterestIncome%2CannualContinuingAndDiscontinuedDilutedEPS%2CtrailingContinuingAndDiscontinuedDilutedEPS%2CannualContinuingAndDiscontinuedBasicEPS%2CtrailingContinuingAndDiscontinuedBasicEPS%2CannualNormalizedIncome%2CtrailingNormalizedIncome%2CannualNetIncomeFromContinuingAndDiscontinuedOperation%2CtrailingNetIncomeFromContinuingAndDiscontinuedOperation%2CannualTotalExpenses%2CtrailingTotalExpenses%2CannualRentExpenseSupplemental%2CtrailingRentExpenseSupplemental%2CannualReportedNormalizedDilutedEPS%2CtrailingReportedNormalizedDilutedEPS%2CannualReportedNormalizedBasicEPS%2CtrailingReportedNormalizedBasicEPS%2CannualTotalOperatingIncomeAsReported%2CtrailingTotalOperatingIncomeAsReported%2CannualDividendPerShare%2CtrailingDividendPerShare%2CannualDilutedAverageShares%2CtrailingDilutedAverageShares%2CannualBasicAverageShares%2CtrailingBasicAverageShares%2CannualDilutedEPS%2CtrailingDilutedEPS%2CannualDilutedEPSOtherGainsLosses%2CtrailingDilutedEPSOtherGainsLosses%2CannualTaxLossCarryforwardDilutedEPS%2CtrailingTaxLossCarryforwardDilutedEPS%2CannualDilutedAccountingChange%2CtrailingDilutedAccountingChange%2CannualDilutedExtraordinary%2CtrailingDilutedExtraordinary%2CannualDilutedDiscontinuousOperations%2CtrailingDilutedDiscontinuousOperations%2CannualDilutedContinuousOperations%2CtrailingDilutedContinuousOperations%2CannualBasicEPS%2CtrailingBasicEPS%2CannualBasicEPSOtherGainsLosses%2CtrailingBasicEPSOtherGainsLosses%2CannualTaxLossCarryforwardBasicEPS%2CtrailingTaxLossCarryforwardBasicEPS%2CannualBasicAccountingChange%2CtrailingBasicAccountingChange%2CannualBasicExtraordinary%2CtrailingBasicExtraordinary%2CannualBasicDiscontinuousOperations%2CtrailingBasicDiscontinuousOperations%2CannualBasicContinuousOperations%2CtrailingBasicContinuousOperations%2CannualDilutedNIAvailtoComStockholders%2CtrailingDilutedNIAvailtoComStockholders%2CannualAverageDilutionEarnings%2CtrailingAverageDilutionEarnings%2CannualNetIncomeCommonStockholders%2CtrailingNetIncomeCommonStockholders%2CannualOtherunderPreferredStockDividend%2CtrailingOtherunderPreferredStockDividend%2CannualPreferredStockDividends%2CtrailingPreferredStockDividends%2CannualNetIncome%2CtrailingNetIncome%2CannualMinorityInterests%2CtrailingMinorityInterests%2CannualNetIncomeIncludingNoncontrollingInterests%2CtrailingNetIncomeIncludingNoncontrollingInterests%2CannualNetIncomeFromTaxLossCarryforward%2CtrailingNetIncomeFromTaxLossCarryforward%2CannualNetIncomeExtraordinary%2CtrailingNetIncomeExtraordinary%2CannualNetIncomeDiscontinuousOperations%2CtrailingNetIncomeDiscontinuousOperations%2CannualNetIncomeContinuousOperations%2CtrailingNetIncomeContinuousOperations%2CannualEarningsFromEquityInterestNetOfTax%2CtrailingEarningsFromEquityInterestNetOfTax%2CannualTaxProvision%2CtrailingTaxProvision%2CannualPretaxIncome%2CtrailingPretaxIncome%2CannualOtherIncomeExpense%2CtrailingOtherIncomeExpense%2CannualOtherNonOperatingIncomeExpenses%2CtrailingOtherNonOperatingIncomeExpenses%2CannualSpecialIncomeCharges%2CtrailingSpecialIncomeCharges%2CannualGainOnSaleOfPPE%2CtrailingGainOnSaleOfPPE%2CannualGainOnSaleOfBusiness%2CtrailingGainOnSaleOfBusiness%2CannualOtherSpecialCharges%2CtrailingOtherSpecialCharges%2CannualWriteOff%2CtrailingWriteOff%2CannualImpairmentOfCapitalAssets%2CtrailingImpairmentOfCapitalAssets%2CannualRestructuringAndMergernAcquisition%2CtrailingRestructuringAndMergernAcquisition%2CannualSecuritiesAmortization%2CtrailingSecuritiesAmortization%2CannualEarningsFromEquityInterest%2CtrailingEarningsFromEquityInterest%2CannualGainOnSaleOfSecurity%2CtrailingGainOnSaleOfSecurity%2CannualNetNonOperatingInterestIncomeExpense%2CtrailingNetNonOperatingInterestIncomeExpense%2CannualTotalOtherFinanceCost%2CtrailingTotalOtherFinanceCost%2CannualInterestExpenseNonOperating%2CtrailingInterestExpenseNonOperating%2CannualInterestIncomeNonOperating%2CtrailingInterestIncomeNonOperating%2CannualOperatingIncome%2CtrailingOperatingIncome%2CannualOperatingExpense%2CtrailingOperatingExpense%2CannualOtherOperatingExpenses%2CtrailingOtherOperatingExpenses%2CannualOtherTaxes%2CtrailingOtherTaxes%2CannualProvisionForDoubtfulAccounts%2CtrailingProvisionForDoubtfulAccounts%2CannualDepreciationAmortizationDepletionIncomeStatement%2CtrailingDepreciationAmortizationDepletionIncomeStatement%2CannualDepletionIncomeStatement%2CtrailingDepletionIncomeStatement%2CannualDepreciationAndAmortizationInIncomeStatement%2CtrailingDepreciationAndAmortizationInIncomeStatement%2CannualAmortization%2CtrailingAmortization%2CannualAmortizationOfIntangiblesIncomeStatement%2CtrailingAmortizationOfIntangiblesIncomeStatement%2CannualDepreciationIncomeStatement%2CtrailingDepreciationIncomeStatement%2CannualResearchAndDevelopment%2CtrailingResearchAndDevelopment%2CannualSellingGeneralAndAdministration%2CtrailingSellingGeneralAndAdministration%2CannualSellingAndMarketingExpense%2CtrailingSellingAndMarketingExpense%2CannualGeneralAndAdministrativeExpense%2CtrailingGeneralAndAdministrativeExpense%2CannualOtherGandA%2CtrailingOtherGandA%2CannualInsuranceAndClaims%2CtrailingInsuranceAndClaims%2CannualRentAndLandingFees%2CtrailingRentAndLandingFees%2CannualSalariesAndWages%2CtrailingSalariesAndWages%2CannualGrossProfit%2CtrailingGrossProfit%2CannualCostOfRevenue%2CtrailingCostOfRevenue%2CannualTotalRevenue%2CtrailingTotalRevenue%2CannualExciseTaxes%2CtrailingExciseTaxes%2CannualOperatingRevenue%2CtrailingOperatingRevenue&merge=false&period1=493590046&period2=1708127230&corsDomain=finance.yahoo.com'

rm ./*.json

while [ $IDX_SYM -le $TOTAL_SYMBOLS ]
do
    # Get the symbol name by current idx value
    SYM=$(awk -v sym_id=$IDX_SYM 'NR == sym_id {print}' $FILE_SYM)

    # print msg on screen - progress
    printf 'Fetch data for Symbol: %s: %s\n' "$IDX_SYM" "$SYM"

    # edit query
    CUR_QUERY_STATS_VAL=$(echo ${QUERY_STATS_VAL} | sed -n "s/COIN/${SYM}/gp")
    CUR_QUERY_STOCK_PRICE=$(echo ${QUERY_STOCK_PRICE} | sed -n "s/COIN/${SYM}/gp")
    CUR_QUERY_SHARES_INFO=$(echo ${QUERY_SHARES_INFO} | sed -n "s/COIN/${SYM}/gp")
    CUR_QUERY_HISTORY=$(echo ${QUERY_HISTORY} | sed -n "s/COIN/${SYM}/gp")

    # show url query
    echo ${CUR_QUERY_STATS_VAL}
    echo ${CUR_QUERY_SHARES_INFO}

    # fetch data 
    curl -L ${CUR_QUERY_STATS_VAL} | jq > "${SYM}_VAL.${FILE_OUT_EXT}"
    curl -L ${CUR_QUERY_STOCK_PRICE} | jq > "${SYM}_STOCK_PRICE.${FILE_OUT_EXT}"
    curl -L ${CUR_QUERY_SHARES_INFO} -H "${COOKIE}" | jq > "${SYM}_SHARES_INFO.${FILE_OUT_EXT}"
    curl -L ${CUR_QUERY_HISTORY} | jq > "${SYM}_HIST.${FILE_OUT_EXT}"
    
    # delay
    sleep 1

    # next item (iteration)
    (( ++IDX_SYM ))
    
done

echo
#python3 ./clean_stats.py
#less out.txt