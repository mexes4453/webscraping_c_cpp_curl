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


#curl 'https://query1.finance.yahoo.com/v10/finance/quoteSummary/DFS?formatted=true&crumb=yPf5nXC9zqM&lang=en-US&region=US&modules=incomeStatementHistory%2CcashflowStatementHistory%2CbalanceSheetHistory%2CincomeStatementHistoryQuarterly%2CcashflowStatementHistoryQuarterly%2CbalanceSheetHistoryQuarterly&corsDomain=finance.yahoo.com' --compressed -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:122.0) Gecko/20100101 Firefox/122.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Referer: https://finance.yahoo.com/quote/DFS/financials' -H 'Origin: https://finance.yahoo.com' -H 'Connection: keep-alive' -H 'Cookie: A1=d=AQABBMWjoWUCEH1oCtZ1BHF1BjKL4lzMDvoFEgABCAGbz2X3ZeA9b2UBAiAAAAcIxaOhZXgkYqIIDzpZQMM1hxz2g9LsZvZ5ugkBBwoBnw&S=AQAAApQ94Nm6Ddvi1ZBhkcKL_DQ; OTH=v=2&s=2&d=eyJraWQiOiIwMTY0MGY5MDNhMjRlMWMxZjA5N2ViZGEyZDA5YjE5NmM5ZGUzZWQ5IiwiYWxnIjoiUlMyNTYifQ.eyJjdSI6eyJndWlkIjoiRDdWM0JGWkVOSldQTEtYTEcyV0xaNDJGM1UiLCJwZXJzaXN0ZW50Ijp0cnVlLCJzaWQiOiJrWnNOb04xN1ZpdEYifX0.fjNeTwBvex5fZjIBnFPIXchrVAXKeWvtgt8aFA_JizSDMt6esG7qNaC8xCHpizpK4wLQgVJV367XABw8MXWstb6Wj5EgyFSLmwVnxjzaqKoEKdq_9xM178pL4ykG6Hq36mxfgaIP1qR0vdn0SSrihcq1dGxtJsHrdXQJ9UDgN9s; A3=d=AQABBMWjoWUCEH1oCtZ1BHF1BjKL4lzMDvoFEgABCAGbz2X3ZeA9b2UBAiAAAAcIxaOhZXgkYqIIDzpZQMM1hxz2g9LsZvZ5ugkBBwoBnw&S=AQAAApQ94Nm6Ddvi1ZBhkcKL_DQ; T=af=JnRzPTE3MDUwOTIwMzcmcHM9ZDEyTGcuME01YnNMSGJ0ZlJhMm13dy0t&d=bnMBeWFob28BZwFEN1YzQkZaRU5KV1BMS1hMRzJXTFo0MkYzVQFhYwFBRmVDNk1yNwFhbAFjaGltZXgxOTg4AXNjAW1icl9sb2dpbgFmcwFISjlYcGdSbG9hUEYBenoBRlBhb2xCQTdFAWEBUUFFAWxhdAFGUGFvbEIBbnUBMA--&kt=EAA7KEktyVb_FbHuODuSOJMgw--~I&ku=FAAJ_sz6vdma8c7TLnYZsG8CoK3PbXbEYejMwyC2zWqAWt_U4vr2..CsRgK_ZspYDVdpt2acrJU.h_GS8hQV6b_ippwBvrCa9eiB89lqUYGN7V9aF42HI5UUUuyRaT8QQ8I3r6mZDXe8dmX4jjjBYwl715Ev6Gmhrvp4948kqQZT4A-~E; F=d=GrL7ysw9vNihHdrWKSjIFuCpqdzUSC5meFw3OlIH; PH=l=en-GB; Y=v=1&n=36mnscj4r1vd1&l=278c4nrzyy/o&p=m2o016i00000000&r=en&intl=uk; GUC=AQABCAFlz5tl90Id2AQn&s=AQAAALLHAz-H&g=Zc5XVQ; cmp=t=1708381301&j=1&u=1---&v=14; A1S=d=AQABBMWjoWUCEH1oCtZ1BHF1BjKL4lzMDvoFEgABCAGbz2X3ZeA9b2UBAiAAAAcIxaOhZXgkYqIIDzpZQMM1hxz2g9LsZvZ5ugkBBwoBnw&S=AQAAApQ94Nm6Ddvi1ZBhkcKL_DQ; PRF=t%3DDFS%252BCOF%252BARCC%252BA%252BADN%252BGC%253DF%252BINTC%252BCL%253DF%252BCOIN%252BADBE%252BAMAT%252BTSLA%252BTWLO%252BINUV%252BARM%26newChartbetateaser%3D1; EuConsent=CP4RQoAP4RQoAAOACKENAoEgAAAAAAAAACiQAAAAAAAA' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-site' -H 'TE: trailers'

QUERY_BAL_SHT='https://query1.finance.yahoo.com/ws/fundamentals-timeseries/v1/finance/timeseries/COIN?lang=en-US&region=US&symbol=COIN&padTimeSeries=true&type=annualTreasurySharesNumber%2CtrailingTreasurySharesNumber%2CannualPreferredSharesNumber%2CtrailingPreferredSharesNumber%2CannualOrdinarySharesNumber%2CtrailingOrdinarySharesNumber%2CannualShareIssued%2CtrailingShareIssued%2CannualNetDebt%2CtrailingNetDebt%2CannualTotalDebt%2CtrailingTotalDebt%2CannualTangibleBookValue%2CtrailingTangibleBookValue%2CannualInvestedCapital%2CtrailingInvestedCapital%2CannualWorkingCapital%2CtrailingWorkingCapital%2CannualNetTangibleAssets%2CtrailingNetTangibleAssets%2CannualCapitalLeaseObligations%2CtrailingCapitalLeaseObligations%2CannualCommonStockEquity%2CtrailingCommonStockEquity%2CannualPreferredStockEquity%2CtrailingPreferredStockEquity%2CannualTotalCapitalization%2CtrailingTotalCapitalization%2CannualTotalEquityGrossMinorityInterest%2CtrailingTotalEquityGrossMinorityInterest%2CannualMinorityInterest%2CtrailingMinorityInterest%2CannualStockholdersEquity%2CtrailingStockholdersEquity%2CannualOtherEquityInterest%2CtrailingOtherEquityInterest%2CannualGainsLossesNotAffectingRetainedEarnings%2CtrailingGainsLossesNotAffectingRetainedEarnings%2CannualOtherEquityAdjustments%2CtrailingOtherEquityAdjustments%2CannualFixedAssetsRevaluationReserve%2CtrailingFixedAssetsRevaluationReserve%2CannualForeignCurrencyTranslationAdjustments%2CtrailingForeignCurrencyTranslationAdjustments%2CannualMinimumPensionLiabilities%2CtrailingMinimumPensionLiabilities%2CannualUnrealizedGainLoss%2CtrailingUnrealizedGainLoss%2CannualTreasuryStock%2CtrailingTreasuryStock%2CannualRetainedEarnings%2CtrailingRetainedEarnings%2CannualAdditionalPaidInCapital%2CtrailingAdditionalPaidInCapital%2CannualCapitalStock%2CtrailingCapitalStock%2CannualOtherCapitalStock%2CtrailingOtherCapitalStock%2CannualCommonStock%2CtrailingCommonStock%2CannualPreferredStock%2CtrailingPreferredStock%2CannualTotalPartnershipCapital%2CtrailingTotalPartnershipCapital%2CannualGeneralPartnershipCapital%2CtrailingGeneralPartnershipCapital%2CannualLimitedPartnershipCapital%2CtrailingLimitedPartnershipCapital%2CannualTotalLiabilitiesNetMinorityInterest%2CtrailingTotalLiabilitiesNetMinorityInterest%2CannualTotalNonCurrentLiabilitiesNetMinorityInterest%2CtrailingTotalNonCurrentLiabilitiesNetMinorityInterest%2CannualOtherNonCurrentLiabilities%2CtrailingOtherNonCurrentLiabilities%2CannualLiabilitiesHeldforSaleNonCurrent%2CtrailingLiabilitiesHeldforSaleNonCurrent%2CannualRestrictedCommonStock%2CtrailingRestrictedCommonStock%2CannualPreferredSecuritiesOutsideStockEquity%2CtrailingPreferredSecuritiesOutsideStockEquity%2CannualDerivativeProductLiabilities%2CtrailingDerivativeProductLiabilities%2CannualEmployeeBenefits%2CtrailingEmployeeBenefits%2CannualNonCurrentPensionAndOtherPostretirementBenefitPlans%2CtrailingNonCurrentPensionAndOtherPostretirementBenefitPlans%2CannualNonCurrentAccruedExpenses%2CtrailingNonCurrentAccruedExpenses%2CannualDuetoRelatedPartiesNonCurrent%2CtrailingDuetoRelatedPartiesNonCurrent%2CannualTradeandOtherPayablesNonCurrent%2CtrailingTradeandOtherPayablesNonCurrent%2CannualNonCurrentDeferredLiabilities%2CtrailingNonCurrentDeferredLiabilities%2CannualNonCurrentDeferredRevenue%2CtrailingNonCurrentDeferredRevenue%2CannualNonCurrentDeferredTaxesLiabilities%2CtrailingNonCurrentDeferredTaxesLiabilities%2CannualLongTermDebtAndCapitalLeaseObligation%2CtrailingLongTermDebtAndCapitalLeaseObligation%2CannualLongTermCapitalLeaseObligation%2CtrailingLongTermCapitalLeaseObligation%2CannualLongTermDebt%2CtrailingLongTermDebt%2CannualLongTermProvisions%2CtrailingLongTermProvisions%2CannualCurrentLiabilities%2CtrailingCurrentLiabilities%2CannualOtherCurrentLiabilities%2CtrailingOtherCurrentLiabilities%2CannualCurrentDeferredLiabilities%2CtrailingCurrentDeferredLiabilities%2CannualCurrentDeferredRevenue%2CtrailingCurrentDeferredRevenue%2CannualCurrentDeferredTaxesLiabilities%2CtrailingCurrentDeferredTaxesLiabilities%2CannualCurrentDebtAndCapitalLeaseObligation%2CtrailingCurrentDebtAndCapitalLeaseObligation%2CannualCurrentCapitalLeaseObligation%2CtrailingCurrentCapitalLeaseObligation%2CannualCurrentDebt%2CtrailingCurrentDebt%2CannualOtherCurrentBorrowings%2CtrailingOtherCurrentBorrowings%2CannualLineOfCredit%2CtrailingLineOfCredit%2CannualCommercialPaper%2CtrailingCommercialPaper%2CannualCurrentNotesPayable%2CtrailingCurrentNotesPayable%2CannualPensionandOtherPostRetirementBenefitPlansCurrent%2CtrailingPensionandOtherPostRetirementBenefitPlansCurrent%2CannualCurrentProvisions%2CtrailingCurrentProvisions%2CannualPayablesAndAccruedExpenses%2CtrailingPayablesAndAccruedExpenses%2CannualCurrentAccruedExpenses%2CtrailingCurrentAccruedExpenses%2CannualInterestPayable%2CtrailingInterestPayable%2CannualPayables%2CtrailingPayables%2CannualOtherPayable%2CtrailingOtherPayable%2CannualDuetoRelatedPartiesCurrent%2CtrailingDuetoRelatedPartiesCurrent%2CannualDividendsPayable%2CtrailingDividendsPayable%2CannualTotalTaxPayable%2CtrailingTotalTaxPayable%2CannualIncomeTaxPayable%2CtrailingIncomeTaxPayable%2CannualAccountsPayable%2CtrailingAccountsPayable%2CannualTotalAssets%2CtrailingTotalAssets%2CannualTotalNonCurrentAssets%2CtrailingTotalNonCurrentAssets%2CannualOtherNonCurrentAssets%2CtrailingOtherNonCurrentAssets%2CannualDefinedPensionBenefit%2CtrailingDefinedPensionBenefit%2CannualNonCurrentPrepaidAssets%2CtrailingNonCurrentPrepaidAssets%2CannualNonCurrentDeferredAssets%2CtrailingNonCurrentDeferredAssets%2CannualNonCurrentDeferredTaxesAssets%2CtrailingNonCurrentDeferredTaxesAssets%2CannualDuefromRelatedPartiesNonCurrent%2CtrailingDuefromRelatedPartiesNonCurrent%2CannualNonCurrentNoteReceivables%2CtrailingNonCurrentNoteReceivables%2CannualNonCurrentAccountsReceivable%2CtrailingNonCurrentAccountsReceivable%2CannualFinancialAssets%2CtrailingFinancialAssets%2CannualInvestmentsAndAdvances%2CtrailingInvestmentsAndAdvances%2CannualOtherInvestments%2CtrailingOtherInvestments%2CannualInvestmentinFinancialAssets%2CtrailingInvestmentinFinancialAssets%2CannualHeldToMaturitySecurities%2CtrailingHeldToMaturitySecurities%2CannualAvailableForSaleSecurities%2CtrailingAvailableForSaleSecurities%2CannualFinancialAssetsDesignatedasFairValueThroughProfitorLossTotal%2CtrailingFinancialAssetsDesignatedasFairValueThroughProfitorLossTotal%2CannualTradingSecurities%2CtrailingTradingSecurities%2CannualLongTermEquityInvestment%2CtrailingLongTermEquityInvestment%2CannualInvestmentsinJointVenturesatCost%2CtrailingInvestmentsinJointVenturesatCost%2CannualInvestmentsInOtherVenturesUnderEquityMethod%2CtrailingInvestmentsInOtherVenturesUnderEquityMethod%2CannualInvestmentsinAssociatesatCost%2CtrailingInvestmentsinAssociatesatCost%2CannualInvestmentsinSubsidiariesatCost%2CtrailingInvestmentsinSubsidiariesatCost%2CannualInvestmentProperties%2CtrailingInvestmentProperties%2CannualGoodwillAndOtherIntangibleAssets%2CtrailingGoodwillAndOtherIntangibleAssets%2CannualOtherIntangibleAssets%2CtrailingOtherIntangibleAssets%2CannualGoodwill%2CtrailingGoodwill%2CannualNetPPE%2CtrailingNetPPE%2CannualAccumulatedDepreciation%2CtrailingAccumulatedDepreciation%2CannualGrossPPE%2CtrailingGrossPPE%2CannualLeases%2CtrailingLeases%2CannualConstructionInProgress%2CtrailingConstructionInProgress%2CannualOtherProperties%2CtrailingOtherProperties%2CannualMachineryFurnitureEquipment%2CtrailingMachineryFurnitureEquipment%2CannualBuildingsAndImprovements%2CtrailingBuildingsAndImprovements%2CannualLandAndImprovements%2CtrailingLandAndImprovements%2CannualProperties%2CtrailingProperties%2CannualCurrentAssets%2CtrailingCurrentAssets%2CannualOtherCurrentAssets%2CtrailingOtherCurrentAssets%2CannualHedgingAssetsCurrent%2CtrailingHedgingAssetsCurrent%2CannualAssetsHeldForSaleCurrent%2CtrailingAssetsHeldForSaleCurrent%2CannualCurrentDeferredAssets%2CtrailingCurrentDeferredAssets%2CannualCurrentDeferredTaxesAssets%2CtrailingCurrentDeferredTaxesAssets%2CannualRestrictedCash%2CtrailingRestrictedCash%2CannualPrepaidAssets%2CtrailingPrepaidAssets%2CannualInventory%2CtrailingInventory%2CannualInventoriesAdjustmentsAllowances%2CtrailingInventoriesAdjustmentsAllowances%2CannualOtherInventories%2CtrailingOtherInventories%2CannualFinishedGoods%2CtrailingFinishedGoods%2CannualWorkInProcess%2CtrailingWorkInProcess%2CannualRawMaterials%2CtrailingRawMaterials%2CannualReceivables%2CtrailingReceivables%2CannualReceivablesAdjustmentsAllowances%2CtrailingReceivablesAdjustmentsAllowances%2CannualOtherReceivables%2CtrailingOtherReceivables%2CannualDuefromRelatedPartiesCurrent%2CtrailingDuefromRelatedPartiesCurrent%2CannualTaxesReceivable%2CtrailingTaxesReceivable%2CannualAccruedInterestReceivable%2CtrailingAccruedInterestReceivable%2CannualNotesReceivable%2CtrailingNotesReceivable%2CannualLoansReceivable%2CtrailingLoansReceivable%2CannualAccountsReceivable%2CtrailingAccountsReceivable%2CannualAllowanceForDoubtfulAccountsReceivable%2CtrailingAllowanceForDoubtfulAccountsReceivable%2CannualGrossAccountsReceivable%2CtrailingGrossAccountsReceivable%2CannualCashCashEquivalentsAndShortTermInvestments%2CtrailingCashCashEquivalentsAndShortTermInvestments%2CannualOtherShortTermInvestments%2CtrailingOtherShortTermInvestments%2CannualCashAndCashEquivalents%2CtrailingCashAndCashEquivalents%2CannualCashEquivalents%2CtrailingCashEquivalents%2CannualCashFinancial%2CtrailingCashFinancial&merge=false&period1=493590046&period2=1708548967&corsDomain=finance.yahoo.com'

# remove existing json files
#rm ./*.json

while [ $IDX_SYM -le $TOTAL_SYMBOLS ]
do
    # Get the symbol name by current idx value
    SYM=$(awk -v sym_id=$IDX_SYM 'NR == sym_id {print}' $FILE_SYM)

    # print msg on screen - progress
    echo
    echo
    MSG=$(printf 'Fetch data for Symbol: %s (%s/%s)\n' "$SYM" "$IDX_SYM" "$TOTAL_SYMBOLS")
    echo $MSG

    # edit query
    CUR_QUERY_STATS_VAL=$(echo ${QUERY_STATS_VAL} | sed -n "s/COIN/${SYM}/gp")
    CUR_QUERY_STOCK_PRICE=$(echo ${QUERY_STOCK_PRICE} | sed -n "s/COIN/${SYM}/gp")
    CUR_QUERY_SHARES_INFO=$(echo ${QUERY_SHARES_INFO} | sed -n "s/COIN/${SYM}/gp")
    CUR_QUERY_HISTORY=$(echo ${QUERY_HISTORY} | sed -n "s/COIN/${SYM}/gp")
    CUR_QUERY_BAL_SHT=$(echo ${QUERY_BAL_SHT} | sed -n "s/COIN/${SYM}/gp")

    # show url query
    # echo ${CUR_QUERY_STATS_VAL}
    # echo ${CUR_QUERY_SHARES_INFO}

    # fetch data 
#    curl -sL ${CUR_QUERY_STATS_VAL} | jq > "${SYM}_VAL.${FILE_OUT_EXT}"
#    curl -sL ${CUR_QUERY_STOCK_PRICE} | jq > "${SYM}_STOCK_PRICE.${FILE_OUT_EXT}"
#    curl -sL ${CUR_QUERY_SHARES_INFO} -H "${COOKIE}" | jq > "${SYM}_SHARES_INFO.${FILE_OUT_EXT}"
#    curl -sL ${CUR_QUERY_HISTORY} | jq > "${SYM}_HIST.${FILE_OUT_EXT}"
    curl -sL ${CUR_QUERY_BAL_SHT} | jq > "${SYM}_BAL_SHT.${FILE_OUT_EXT}"
    
    # delay
    if (( $IDX_SYM % 4  == 0 ))
    then
        sleep 1
    fi

    # next item (iteration)
    (( ++IDX_SYM ))
    
done

echo
#python3 ./clean_stats.py
#less out.txt