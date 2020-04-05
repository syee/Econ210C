/*******************************************************************************
Program: ECON 210C Assignment
Author: Steven Yee
Date: 4/4/20
Purpose:
Update: 
*******************************************************************************/

cap log using  "YeeStevenMacro210CHW1", text
//Importing the FRED dataset
import fred GDPC1 PCECC96 GPDIC1 PAYEMS HOANBS CNP16OV, aggregate(quarterly,eop) clear
rename datestr DATESTR
rename daten DATEN
gen YEAR = year(DATEN)
sort YEAR DATEN 
by YEAR: replace YEAR = . if _n != 4
save FREDData, replace

import excel "/Users/stevenyee/Documents/UCSD/UCSDEconomics/Spring2020/ECON210C-MacroC/assignments/Assignment1/nipaData.xlsx", sheet("Sheet1") firstrow case(upper) clear

rename A YEAR
destring YEAR, replace
sort YEAR
save NIPAData, replace

use FREDData
sort YEAR DATEN
merge YEAR using NIPAData

sort DATEN
drop if _merge == 2

//Making it so only observations with full set of datapoints are kept
gen YEAR2 = year(DATEN)
drop YEAR
gen YEAR = YEAR2
drop if YEAR < 1947
drop if YEAR > 2019
format DATEN  %tq
gen quarterDates = qofd(DATEN)

// replace GDPC1 = GDPC1/CNP16OV * 1000000000
// replace PCECC96 = PCECC96/CNP16OV * 1000000000
// replace GPDIC1  = GPDIC1/CNP16OV * 1000000000
// replace NONRESIDENTIALCHAINTYPE = NONRESIDENTIALCHAINTYPE/CNP16OV * 1000000000

gen lnGDP = ln(GDPC1)
gen lnConsumption = ln(PCECC96)
gen lnRealInvest = ln(GPDIC1)
gen lnEmploy = ln(PAYEMS)
gen lnHours = ln(HOANBS)

// lnChainCapital
gen lnRealCapitalChain = ln(NONRESIDENTIALCHAINTYPE)
ipolate lnRealCapitalChain quarterDates, gen(lnRealCapitalChain2)
rename lnRealCapitalChain2 lnChainCapital

// lnIndexCapital
gen lnRealIndexCapital = ln(NONRESIDENTIALCURRENTCOS)
ipolate lnRealIndexCapital quarterDates, gen(lnRealIndexCapital2)
rename lnRealIndexCapital2 lnIndexCapital

//Generating solow residual
local capitalShare = 0.67
gen lnSolowResidualIndex = lnGDP - (1 - `capitalShare') * lnHours - `capitalShare' * lnIndexCapital
gen lnSolowResidualChain = lnGDP - (1 - `capitalShare') * lnHours - `capitalShare' * lnChainCapital


save cleanData, replace
// line lnSolowResidualChain lnSolowResidualIndex quarterDatesc
line lnGDP lnConsumption lnRealInvest lnEmploy lnHours lnChainCapital lnIndexCapital lnSolowResidualIndex lnSolowResidualChain quarterDates



//HP Filter
tsset quarterDates
tsfilter hp gdp_hp1600 = lnGDP, smooth(1600)
tsfilter hp consumption_hp1600 = lnConsumption, smooth(1600)
tsfilter hp realInvest_hp1600 = lnRealInvest, smooth(1600)
tsfilter hp employ_hp1600 = lnEmploy, smooth(1600)
tsfilter hp hours_hp1600 = lnHours, smooth(1600)
tsfilter hp chainCapital_hp1600 = lnChainCapital, smooth(1600)
tsfilter hp indexCapital_hp1600 = lnIndexCapital, smooth(1600)
tsfilter hp solowIndex_hp1600 = lnSolowResidualIndex, smooth(1600)
tsfilter hp solowChain_hp1600 = lnSolowResidualChain, smooth(1600)

sum(lnGDP)
local gdpSD =  `r(sd)'
//4C
//standard deviation
sum(gdp_hp1600)
local gdp1600SD =  `r(sd)'
//Relative standard deviation to output
di `gdp1600SD'/`gdp1600SD'
//autocorrelation
correlate gdp_hp1600 l.gdp_hp1600
local gdp1600AC = `r(rho)'
//correlation with output
sum(gdp_hp1600)
local gdp1600CO =  `r(Var)'

//standard deviation
sum(consumption_hp1600)
local consumption_hp1600SD =  `r(sd)'
//Relative standard deviation to output
di `consumption_hp1600SD'/`gdp1600SD'
//autocorrelation
correlate consumption_hp1600 l.consumption_hp1600
local consumption_hp1600AC = `r(rho)'
//correlation with output
correlate consumption_hp1600 gdp_hp1600
local consumption_hp1600CO =  `r(rho)'

foreach lambda in 1600 10000 99999{
	local lambda = `lambda'
	if `lambda' == 99999{
		qui reg lnGDP quarterDates
		qui predict gdp_hp_99999 if e(sample),residuals
		qui reg lnConsumption quarterDates
		qui predict consumption_hp_99999 if e(sample),residuals
		qui reg lnRealInvest quarterDates
		qui predict realInvest_hp_99999 if e(sample),residuals
		qui reg lnEmploy quarterDates
		qui predict employ_hp_99999 if e(sample),residuals
		qui reg lnHours quarterDates
		qui predict hours_hp_99999 if e(sample),residuals
		qui reg lnChainCapital quarterDates
		qui predict chainCapital_hp_99999 if e(sample),residuals
		qui reg lnIndexCapital quarterDates
		qui predict indexCapital_hp_99999 if e(sample),residuals
		qui reg lnSolowResidualIndex quarterDates
		qui predict solowIndex_hp_99999 if e(sample),residuals
		qui reg lnSolowResidualChain quarterDates
		qui predict solowChain_hp_99999 if e(sample),residuals
	}
	else{
		qui tsset quarterDates
		tsfilter hp gdp_hp_`lambda' = lnGDP, smooth(`lambda')
		tsfilter hp consumption_hp_`lambda' = lnConsumption, smooth(`lambda')
		tsfilter hp realInvest_hp_`lambda' = lnRealInvest, smooth(`lambda')
		tsfilter hp employ_hp_`lambda' = lnEmploy, smooth(`lambda')
		tsfilter hp hours_hp_`lambda' = lnHours, smooth(`lambda')
		tsfilter hp chainCapital_hp_`lambda' = lnChainCapital, smooth(`lambda')
		tsfilter hp indexCapital_hp_`lambda' = lnIndexCapital, smooth(`lambda')
		tsfilter hp solowIndex_hp_`lambda' = lnSolowResidualIndex, smooth(`lambda')
		tsfilter hp solowChain_hp_`lambda' = lnSolowResidualChain, smooth(`lambda')
	}
}

foreach k in gdp_hp_* consumption_hp_* realInvest_hp_* employ_hp_* hours_hp_* chainCapital_hp_* indexCapital_hp_* solowIndex_hp_* solowChain_hp_*{
	line `k' quarterDates
}



program drop tableVars
program define tableVars
	version 11
	syntax varlist
	tempvar toReturn	
	di "Hello"

end

tableVars gdp_hp_1600 consumption_hp_1600 


program drop tableVars
program define tableVars, eclass
	version 11
	syntax varlist
	tempvar toReturn
	

// 	g `toReturn' = _n
// 	qui tsset `toReturn'

	// 	local denominator `: word 1 of `varlist''
	// 	qui tsset `time''	
	di "Hello"
	// 	di `denominator'
	// 	di '2'
	// 	qui sum('1')
	// 	local '1'SD =  `r(sd)'
	// 	di `r(sd)'
end

tableVars gdp_hp_1600 consumption_hp_1600 




sum(lnGDP)
local gdpSD =  `r(sd)'
//4C
//standard deviation
sum(gdp_hp1600)
local gdp1600SD =  `r(sd)'
//Relative standard deviation to output
di `gdp1600SD'/`gdp1600SD'
//autocorrelation
correlate gdp_hp1600 l.gdp_hp1600
local gdp1600AC = `r(rho)'
//correlation with output
sum(gdp_hp1600)
local gdp1600CO =  `r(Var)'

//standard deviation
sum(consumption_hp1600)
local consumption_hp1600SD =  `r(sd)'
//Relative standard deviation to output
di `consumption_hp1600SD'/`gdp1600SD'
//autocorrelation
correlate consumption_hp1600 l.consumption_hp1600
local consumption_hp1600AC = `r(rho)'
//correlation with output
correlate consumption_hp1600 gdp_hp1600
local consumption_hp1600CO =  `r(rho)'


line gdp_hp1600 consumption_hp1600 realInvest_hp1600 employ_hp1600 hours_hp1600 chainCapital_hp1600 indexCapital_hp1600 solowIndex_hp1600 solowChain_hp1600 quarterDates


tsfilter hp gdp_hp10000 = lnGDP, smooth(10000)
tsfilter hp consumption_hp10000 = lnConsumption, smooth(10000)
tsfilter hp realInvest_hp10000 = lnRealInvest, smooth(10000)
tsfilter hp employ_hp10000 = lnEmploy, smooth(10000)
tsfilter hp hours_hp10000 = lnHours, smooth(10000)
tsfilter hp chainCapital_hp10000 = lnChainCapital, smooth(10000)
tsfilter hp indexCapital_hp10000 = lnIndexCapital, smooth(10000)
tsfilter hp solowIndex_hp10000 = lnSolowResidualIndex, smooth(10000)
tsfilter hp solowChain_hp10000 = lnSolowResidualChain, smooth(10000)

line gdp_hp1600 consumption_hp10000 realInvest_hp10000 employ_hp10000 hours_hp10000 chainCapital_hp10000 indexCapital_hp10000 quarterDates

reg lnGDP quarterDates
predict GDPResid if e(sample),residuals
reg lnConsumption quarterDates
predict ConsumptionResid if e(sample),residuals
reg lnRealInvest quarterDates
predict RealInvestResid if e(sample),residuals
reg lnEmploy quarterDates
predict EmployResid if e(sample),residuals
reg lnHours quarterDates
predict HoursResid if e(sample),residuals
reg lnChainCapital quarterDates
predict ChainCapitalResid if e(sample),residuals
reg lnIndexCapital quarterDates
predict IndexCapitalResid if e(sample),residuals
reg lnSolowResidualIndex quarterDates
predict SolowResidualResid if e(sample),residuals
reg lnSolowResidualChain quarterDates
predict SolowResidualChainResid if e(sample),residuals

line GDPResid quarterDates
