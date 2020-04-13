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

//Make terms per capita
// replace GDPC1 = GDPC1/CNP16OV * 1000000000
// replace PCECC96 = PCECC96/CNP16OV * 1000000000
// replace GPDIC1  = GPDIC1/CNP16OV * 1000000000
// replace NONRESIDENTIALCHAINTYPE = NONRESIDENTIALCHAINTYPE/CNP16OV * 1000000000
// replace NONRESIDENTIALCURRENTCOS = NONRESIDENTIALCURRENTCOS/CNP16OV * 1000000000

gen realCapital = NONRESIDENTIALCURRENTCOS[264]* NONRESIDENTIALCHAINTYPE/100
// gen realCapital = NONRESIDENTIALCURRENTCOS

//Plot raw series
tsset quarterDates
foreach series of varlist GDPC1 PCECC96 GPDIC1 PAYEMS HOANBS realCapital {
	tsline `series', title(`series') saving(`series', replace)
	graph export `series'.png, replace
}
graph combine GDPC1.gph PCECC96.gph GPDIC1.gph PAYEMS.gph HOANBS.gph realCapital.gph, col(2)
graph export all_series_raw.png, replace

gen lnGDP = ln(GDPC1)
gen lnConsumption = ln(PCECC96)
gen lnRealInvest = ln(GPDIC1)
gen lnEmploy = ln(PAYEMS)
gen lnHours = ln(HOANBS)


gen lnRealCapital_copy = ln(realCapital)
ipolate lnRealCapital_copy quarterDates, gen(lnRealCapital)

//Generating solow residual
local capitalShare = 0.67
gen lnSolowResidualIndex = lnGDP - (1 - `capitalShare') * lnHours - `capitalShare' * lnRealCapital


save cleanData, replace
// line lnSolowResidualChain lnSolowResidualIndex quarterDatesc

tsset quarterDates

//Plot logged series
foreach series of varlist lnGDP lnConsumption lnRealInvest lnEmploy lnHours lnRealCapital lnSolowResidualIndex{
	tsline `series', ytitle(,size(small)) ylabel(,labsize(small)) xtitle("") xlabel(,labsize(small)) title(`series') saving(`series', replace)
	graph export `series'.png, replace
}
graph combine lnGDP.gph lnConsumption.gph lnRealInvest.gph lnEmploy.gph lnHours.gph lnRealCapital.gph lnSolowResidualIndex.gph, col(2)
graph export all_series_log.png, replace



//HP Filter
tsset quarterDates

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
		qui reg lnRealCapital quarterDates
		qui predict realCapital_hp_99999 if e(sample),residuals
		qui reg lnSolowResidualIndex quarterDates
		qui predict solowIndex_hp_99999 if e(sample),residuals
	}
	else{
		qui tsset quarterDates
		tsfilter hp gdp_hp_`lambda' = lnGDP, smooth(`lambda')
		tsfilter hp consumption_hp_`lambda' = lnConsumption, smooth(`lambda')
		tsfilter hp realInvest_hp_`lambda' = lnRealInvest, smooth(`lambda')
		tsfilter hp employ_hp_`lambda' = lnEmploy, smooth(`lambda')
		tsfilter hp hours_hp_`lambda' = lnHours, smooth(`lambda')
		tsfilter hp realCapital_hp_`lambda' = lnRealCapital, smooth(`lambda')
		tsfilter hp solowIndex_hp_`lambda' = lnSolowResidualIndex, smooth(`lambda')
	}
}


foreach series in "gdp_hp" "consumption_hp" "realInvest_hp" "employ_hp" "hours_hp" "realCapital_hp" "solowIndex_hp"{
	tsline `series'*, legend(lab(1 "{stSymbol:l}=1600") lab(2 "{stSymbol:l}=10,000") lab(3 "Linear Trend")) ytitle(,size(small)) ylabel(,labsize(small)) xtitle("") xlabel(,labsize(small)) title(`series') saving(`series', replace)
	graph export `series'.png, replace
}


cap program drop tableVars
program define tableVars, eclass
	version 11
	syntax varlist
	tempvar toReturn	
	g `toReturn' =_n
	qui tsset `toReturn'
	mat drop _all
	local gdp `: word 1 of `varlist''
	qui sum(`gdp')
	local sd_`gdp' = `r(sd)'
	local size : list sizeof varlist
	mat table_out=J(`=`size'',4,.)
	local rownames
	local i = 1
	foreach category of local varlist {
		di "Your correlation is"
		qui su `category'
		mat table_out[`i',1]=100*`r(sd)'
		mat table_out[`i',2]=`r(sd)'/`sd_`gdp''
		
		qui correlate `category' L1.`category'
		mat table_out[`i',3]= `r(rho)'
		
		qui correlate `category' `gdp'
		mat table_out[`i',4]=`r(rho)'
		
		local `++i'
		local rownames `rownames' "`category'"
	}
	mat colnames table_out="Standard Deviation" "Relative Standard Deviation" "First-Order Autocorrelation" "Correlation with Output"
	mat rownames table_out= `rownames'
	
	matlist 		table_out, format(%20.2f) border(top bottom)
		
end

foreach i in 1600 10000 99999{
	tableVars gdp_hp_`i' consumption_hp_`i' realInvest_hp_`i' employ_hp_`i' hours_hp_`i' realCapital_hp_`i' solowIndex_hp_`i'
	asdoc wmat, matrix(table_out) dec(2) tzok rnames(Y C I N H K SR) cnames(Standard_Deviation Relative_Standard_Deviation First-Order_Autocorrelation Comtemporaneous_Correlation_with_Output) save(ps1_tables.doc)
}

