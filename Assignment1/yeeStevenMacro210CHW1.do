/*******************************************************************************
Program: ECON 280 Stata Final Part 1
Author: Steven Yee
Date: 11/22/2019
Purpose: Clean Data, add educational status, race, female indicator, natural log of wage, experience, urban, occupation codes, and relationship status variables.
Update: 
		11/17/2019 Import code from exercises
		11/18/2019 Working same sex/opposite-sex variables
		11/20/2019 Same-Sex/opposite-sex variables added via egen
		11/22/2019 Finalized comments and descriptions.
IMPORTANT NOTE: This code was written on a MacOS machine. Accordingly, I used "/" instead of "\" in my paths. This may need to be changed depending on what machine the code is run on.
IMPORTANT NOTE: This code expects a specific file structure based on the root path that is decsribed in the first section of the code.
*******************************************************************************/

// Structure of program and files must be compatible with the below section. In particular, the program expects certain data files to be in the /YeeStevenFinal/data directory
clear all
// if there's a log open, close it
cap log close
// don't require space bar on results window to scroll down
set more off
version 16
/* if never using server, something like this would work instead: */
cap ssc install tablist


cap log using  "YeeStevenMacro210CHW1", text
//Saving the FRED API key as a local variable
local FREDapikey = "51296cfad067cf98109b7f86e8214624"
//Setting the fredkey for program
. set fredkey `FREDapikey', permanently
//Importing the FRED dataset GNPC96
import fred GDPC1 PCECC96 GPDIC1 PAYEMS HOANBS CNP16OV, aggregate(quarterly,eop) clear
rename datestr DATESTR
rename daten DATEN
gen year = year(DATEN)
sort year DATEN 
by year: replace year = . if _n != 4
// replace GDPC1 = GDPC1/CNP16OV * 1000000000
// replace PCECC96 = PCECC96/CNP16OV * 1000000000
// replace GPDIC1  = GPDIC1/CNP16OV * 1000000000


save FREDData, replace

import excel "/Users/stevenyee/Documents/UCSD/UCSDEconomics/Spring2020/ECON210C-MacroC/assignments/Assignment1/nipaData.xlsx", sheet("Sheet1") firstrow case(upper) clear

rename A year
destring year, replace
sort year

save NIPAData, replace

use FREDData

// keep if year != .
// keep if GDPC1 != .
sort year DATEN
merge year using NIPAData

sort DATEN
drop if _merge == 2
// replace NONRESIDENTIALCHAINTYPE = NONRESIDENTIALCHAINTYPE/CNP16OV * 1000000000

// line GDPC1 PCECC96 GPDIC1 PAYEMS HOANBS NONRESIDENTIALCHAINTYPE year

gen lnGDP = ln(GDPC1)
gen lnConsumption = ln(PCECC96)
gen lnRealInvest = ln(GPDIC1)
gen lnEmploy = ln(PAYEMS)
gen lnHours = ln(HOANBS)

// lnIndexCapital
gen lnRealCapital2 = ln(NONRESIDENTIALCHAINTYPE)
ipolate lnRealCapital2 DATEN, gen(lnQRealCapital)
rename lnQRealCapital lnIndexCapital

// lnStockCapital
gen lnRealCapital3 = ln(NONRESIDENTIALCURRENTCOS)
ipolate lnRealCapital3 DATEN, gen(lnQRealCapital2)
rename lnQRealCapital2 lnChainCapital



gen capitalShare = 0.67
gen lnSolowResidualIndex = lnGDP - (1 - capitalShare) * lnHours - capitalShare * lnIndexCapital
gen lnSolowResidualChain = lnGDP - (1 - capitalShare) * lnHours - capitalShare * lnChainCapital

gen year2 = year(DATEN)
drop year
gen year = year2
drop if year < 1947
drop if year > 2019

format DATEN  %tq
gen quarterDates = qofd(DATEN)
drop DATEN
gen DATEN = quarterDates


save cleanData, replace
line lnSolowResidualChain lnSolowResidualIndex DATEN
line lnGDP lnConsumption lnRealInvest lnEmploy lnHours lnChainCapital lnIndexCapital lnSolowResidualIndex lnSolowResidualChain DATEN



//HP Filter
tsset DATEN
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

cap gen linear = "linear"
foreach x in 1600 10000 99999{
	local varname = `x'
	local temp1 = `x'
	di `varname'
	if `varname' == 99999{
		local temp1 = "linear"
		di `temp1'
	}
	di `temp1'
	local varname = `temp1'
	di `varname'
}


gen linear = "linear"
foreach x in 1600 10000 99999{
	local varname = `x'
	di `varname'
	if `varname' == 99999{
		local temp = "linear"
		di "asd"
// 		di `varname'
// 		replace `varname' =  "linear" if `x'=="99999"
// // 		`varname' =  "linear"
// 		di `varname'
		di `temp'
	}
	
}
	di "HELLO"
	replace `varname' = "linear" if `varname' == 99999
// 		`varname' = 8
// 		replace `varname' 8
	di varname
}

line gdp_hp1600 consumption_hp1600 realInvest_hp1600 employ_hp1600 hours_hp1600 chainCapital_hp1600 indexCapital_hp1600 solowIndex_hp1600 solowChain_hp1600 DATEN


tsfilter hp gdp_hp10000 = lnGDP, smooth(10000)
tsfilter hp consumption_hp10000 = lnConsumption, smooth(10000)
tsfilter hp realInvest_hp10000 = lnRealInvest, smooth(10000)
tsfilter hp employ_hp10000 = lnEmploy, smooth(10000)
tsfilter hp hours_hp10000 = lnHours, smooth(10000)
tsfilter hp chainCapital_hp10000 = lnChainCapital, smooth(10000)
tsfilter hp indexCapital_hp10000 = lnIndexCapital, smooth(10000)
tsfilter hp solowIndex_hp10000 = lnSolowResidualIndex, smooth(10000)
tsfilter hp solowChain_hp10000 = lnSolowResidualChain, smooth(10000)

line gdp_hp1600 consumption_hp10000 realInvest_hp10000 employ_hp10000 hours_hp10000 chainCapital_hp10000 indexCapital_hp10000 DATEN

reg lnGDP DATEN
predict GDPResid if e(sample),residuals

reg lnConsumption DATEN
predict ConsumptionResid if e(sample),residuals
reg lnRealInvest DATEN
predict RealInvestResid if e(sample),residuals
reg lnEmploy DATEN
predict EmployResid if e(sample),residuals
reg lnHours DATEN
predict HoursResid if e(sample),residuals
reg lnChainCapital DATEN
predict ChainCapitalResid if e(sample),residuals
reg lnIndexCapital DATEN
predict IndexCapitalResid if e(sample),residuals
reg lnSolowResidualIndex DATEN
predict SolowResidualResid if e(sample),residuals
reg lnSolowResidualChain DATEN
predict SolowResidualChainResid if e(sample),residuals

line GDPResid DATEN

//Save new data set as acs_clean.dta
// save "data/acs_clean.dta", replace



// //I'm renaming the variables to be all uppercase since the original variable names were in all lowercase


// //help sum
// sum GNPC96
// di r(mean)
// cap log close





// // Generating new variables based on race
// label define white1 0 "Not White" 1 "White"
// gen white = race == 1 & hispan == 0
// label define black1 0 "Not Black" 1 "Black"
// gen black = race == 2
// label define asian1 0 "Not Asian" 1 "Asian"
// gen asian = inlist(race, 4, 5, 6)
// gen race_other = inlist(race, 3, 7, 8 ,9)
// label variable race_other "Other Race"
// gen hispanic = inrange(hispan, 1, 4)
// label define hispanic1 0 "Not Hispanic" 1 "Hispanic"

// // Label variables
// label values white white1
// label variable white "White Race"
// label values black black1
// label variable black "Black Race"
// label values asian asian1
// label variable asian "Asian Race"
// label values hispanic hispanic1
// label variable hispanic "Hispanic Race"

// // Generating female variable
// gen female = sex == 2
// label define female1 0 "Male" 1 "Female"
// label values female female1
// label variable female "Female"

// //Generating wage variable
// gen lnwage = ln(incwage) if incwage != 9999998 & incwage != 9999999
// label variable lnwage "Natural Log of Wage"

// // Generating new education label based on educ and educd
// label define educ 1 "Less than HS" 2 "HS" 3 "Some College" 4 "College" 5 "Graduate School"
// gen labeled_ed = .
// replace labeled_ed = 1 if inrange(educ, 0, 5)
// replace labeled_ed = 2 if educ == 6
// replace labeled_ed = 3 if inrange(educ, 7, 9)
// replace labeled_ed = 4 if educ == 10 | inrange(educd, 100, 101)
// replace labeled_ed = 5 if inrange(educd, 114, 116)
// replace labeled_ed = . if educ == . | educd == .
// // Actually apply the label to the labeled_ed variable
// label values labeled_ed educ
// label variable labeled_ed "Education Status"

// // Generate new variable of when individual started work based on education status
// gen age_started_work = .
// label variable age_started_work "Age Started Work"
// replace age_started_work = 16 if labeled_ed == 1
// replace age_started_work = 18 if labeled_ed == 2
// replace age_started_work = 20 if labeled_ed == 3
// replace age_started_work = 22 if labeled_ed == 4
// replace age_started_work = 24 if educd == 114
// replace age_started_work = 28 if educd == 115 | educd == 116
// // Generate experience variable based on person's current age vs when they started work
// gen exp = age - age_started_work
// label variable exp "Years of Experience"
// replace exp = 0 if exp < 0
// // Generate experience squared variable
// gen exp2 = exp ^ 2
// label variable exp2 "Years of Experience Squared"
// // Generate variable to determine if individual works full time based on usual hours worked
// gen full_time = .
// replace full_time = 1 if uhrswork >= 35
// replace full_time = 0 if uhrswork <= 35
// label define full_time1 0 "Not Full Time" 1 "Full Time"
// label values full_time full_time1
// label variable full_time "Full Time"

// // Generate a new variable called urban based on metro value
// gen urban = .
// replace urban = 0 if metro == 1
// replace urban = 1 if inrange(metro, 2, 4)
// replace urban = . if metro == .
// label variable urban "Living in Urban Area"

// preserve
// // Bring in OCC recodes from Excel file using the first row of Excel data as variable names
// import excel using data/occ_recode, firstrow clear


// // Rename variable
// rename occ_acs occ
// label variable occ "Occupational Code"
// tempfile tempdata
// save `tempdata'
// restore
// // Merge new occupation code into initial data set based on occ variable
// merge m:1 occ using `tempdata', generate(occ_merge)
// label variable occ_merge "Occupational Merge"
// //Save new data set as acs_clean.dta
// // save "data/acs_clean.dta", replace

// // preserve
// // Only keeping heads of households, spouses, and unmarried partners
// keep if inlist(related, 101, 201, 1114)

// // Generate an indicator if the head of household is a female
// by serial, sort: egen head_household_female = total(related == 101 & female ==1)
// label define head_household_female1 0 "Male Head of Household" 1 "Female Head of Household"
// label values head_household_female head_household_female1
// label variable head_household_female "Head of Household"
// // Generate opposite-sex marriage variable os_mar if head of household is female
// by serial, sort: egen os_mar = total(head_household_female == 1 & female == 0 & related == 201)
// // Generate opposite-sex marriage variable os_mar2 if head of household is male
// by serial, sort: egen os_mar2 = total(head_household_female == 0 & female == 1 & related == 201)
// // Add up the two marriage variables so they can be combined into a single variable
// gen ult_os_mar = os_mar + os_mar2
// drop os_mar
// drop os_mar2
// // Single opposite sex marriage variable, named as desired
// rename ult_os_mar os_mar
// label define os_mar1 0 "Not Opposite Sex Marriage" 1 "Opposite Sex Marriage"
// label values os_mar os_mar1
// label variable os_mar "Opposite Sex Marriage"

// // Generate opposite-sex cohabiting variable os_unmar if head of household is female
// by serial, sort: egen os_unmar = total(head_household_female == 1 & female == 0 & related == 1114)
// // Generate opposite-sex cohabiting variable os_unmar2 if head of household is male
// by serial, sort: egen os_unmar2 = total(head_household_female == 0 & female == 1 & related == 1114)
// // Add up the two cohabiting variables so they can be combined into a single variable
// gen ult_os_unmar = os_unmar + os_unmar2
// drop os_unmar
// drop os_unmar2
// // Single cohabiting sex marriage variable, named as desired
// rename ult_os_unmar os_unmar
// label define os_unmar1 0 "Not Opposite Sex Cohabiting" 1 "Opposite Sex Cohabiting"
// label values os_unmar os_unmar1
// label variable os_unmar "Opposite Sex Cohabiting"

// // Generate same-sex marriage variable os_mar if head of household is female
// by serial, sort: egen ss_mar = total(head_household_female == 1 & female == 1 & related == 201)
// // Generate same-sex marriage variable os_mar2 if head of household is male
// by serial, sort: egen ss_mar2 = total(head_household_female == 0 & female == 0 & related == 201)
// // Add up the two same-sex marriage variables so they can be combined into a single variable
// gen ult_ss_mar = ss_mar + ss_mar2
// drop ss_mar
// drop ss_mar2
// // Single same sex marriage variable, named as desired
// rename ult_ss_mar ss_mar
// label define ss_mar1 0 "Not Same Sex Marriage" 1 "Same Sex Marriage"
// label values ss_mar ss_mar1
// label variable ss_mar "Same Sex Marriage"

// // Generate same-sex cohabiting variable ss_mar if head of household is female
// by serial, sort: egen ss_unmar = total(head_household_female == 1 & female == 1 & related == 1114)
// // Generate same-sex cohabiting variable ss_mar2 if head of household is male
// by serial, sort: egen ss_unmar2 = total(head_household_female == 0 & female == 0 & related == 1114)
// // Add up the two cohabiting variables so they can be combined into a single variable
// gen ult_ss_unmar = ss_unmar + ss_unmar2
// drop ss_unmar
// drop ss_unmar2
// // Single same sex cohabiting variable, named as desired
// rename ult_ss_unmar ss_unmar
// label define ss_unmar1 0 "Not Same Sex Cohabiting" 1 "Same Sex Cohabiting"
// label values ss_unmar ss_unmar1
// label variable ss_unmar "Same Sex Cohabiting"

// // Generating opposite sex relationship indicator
// gen oppsex = 0
// replace oppsex = 1 if os_unmar == 1 | os_mar == 1
// label define oppsex1 0 "In Same-Sex Couple" 1 "In Opposite-Sex Couple"
// label values oppsex oppsex1
// label variable oppsex "Opposite Sex Relationship"

// // Generating same sex relationship indicator
// gen samesex = 0
// replace samesex = 1 if ss_unmar == 1 | ss_mar == 1
// label define samesex1 0 "In Opposite-Sex Couple" 1 "In Same-Sex Couple"
// label values samesex samesex1
// label variable samesex "Same Sex Relationship"

// // Dropping all women plus men not in relationships
// keep if oppsex == 1 | samesex == 1
// keep if female == 0

// // Display frequency table of same sex variable
// di "Chelsea, here is the frequency table:"
// tab samesex

// // Saving data
// save "data/acs_part1.dta", replace

// cap log close

// //////////
// //////////
// // Run /YeeStevenFinal/YeeStevenFinalv5Part2.do for Part 2
// //////////
// //////////
