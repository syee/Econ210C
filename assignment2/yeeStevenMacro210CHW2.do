/*******************************************************************************
Program: ECON 210C Assignment 2
Author: Steven Yee
Date: 4/18/20
Purpose:
Update: 
*******************************************************************************/

cap log using  "YeeStevenMacro210CHW2", text
import fred FEDFUNDS UNRATE A191RI1Q225SBEA, aggregate(quarterly,avg) clear
rename datestr DATESTR
rename daten DATEN

gen DATEQ = qofd(DATEN)
format DATEQ %tq

//Look at data in specific range. You can adjust tq
// br if inrange(DATEQ, tq(1960q1), tq(2007q4))

rename *, lower
rename a191ri1q225sbea gdp_deflator
rename unrate unemployment

tsset dateq
//Plot raw series
foreach series of varlist gdp_deflator unemployment fedfunds{
	tsline `series', ytitle(,size(small)) ylabel(,labsize(small)) xtitle("") xlabel(,labsize(small)) title(`series')
	graph export `series'.png, replace
}

*******************************************************************************
// Estimating VAR
*******************************************************************************
/*Estimate a VAR with 4 lags from 1960Q1:2007Q4. The ordering of your variables should be πt, ut,Rt.
(c) Briefly, explain why it would make sense to end the sample in 2007Q4?
(d) Plot the IRFs from the SVAR with the same ordering. [Optional: add 95% error bands]
(e) Briefly, interpret your results.
(f) Plot the time series of your identified monetary shocks.
(g) What are the identified monetary shocks in 2001Q3 and 2001Q4? How should one interpret these shocks?
*/

local start_date = "1960q1"
local end_date = "2007q4"

var gdp_deflator unemployment fedfunds if inrange(dateq, tq(`start_date'), tq(`end_date')), lags(1/4)
irf create order1, set(var1.irf) replace step(20)
irf graph irf, xlabel(0(4)20) irf(order1) yline(0,lcolor(black)) byopts(yrescale)
graph export macroC_ps2_1b_var.png, replace


//1c
/* It makes sense to end the sample in 2007Q4 because that is when the great recession was starting
*/

// A is the constraints on our variable relationships
matrix A1 = (1,0,0 \ .,1,0 \ .,.,1)
// B is the constraints on the covariance/variance between contemporaneous shocks
matrix B1 = (.,0,0 \ 0,.,0 \ 0,0,.)

//running the ordered structural VAR with 4 lags according to our constraints
svar gdp_deflator unemployment fedfunds if inrange(dateq, tq(`start_date'), tq(`end_date')), lags(1/4) aeq(A1) beq(B1)

//1d
irf create order1, set(var1.irf) replace step(20)
irf graph sirf, xlabel(0(4)20) irf(order1) yline(0,lcolor(black)) byopts(yrescale)
graph export macroC_ps2_1d.png, replace
/*
e(bf_var) - shows full list of coefficients on lags. It does not include contemporaneous coefficients
e(B) - shows covariance between contemporaneous shocks
e(A) - shows contemporaneous coefficients
*/
//1e


//1f
predict money_shock if e(sample), residuals equation(#3)
tsline money_shock if inrange(dateq, tq(`start_date'), tq(`end_date')), ytitle(,size(small)) ylabel(,labsize(small)) xtitle("") xlabel(,labsize(small)) title("Money Shock")
	graph export macroC_ps2_1f_moneyshock.png, replace

/* (g) What are the identified monetary shocks in 2001Q3 and 2001Q4? How should one interpret these shocks?
Response to 9/11
*/

save fred.dta, replace



*******************************************************************************
*******************************************************************************
// Problem 2

//2a
use RR_monetary_shock_quarterly.dta, clear

rename date dateq
rename *, lower
merge 1:1 dateq using fred

replace resid_romer = 0 if dateq < tq(1969q1)

//2b
local start_date = "1969q1"
local end_date = "2007q4"
tsset dateq

// reg gdp_deflator L(1/8).gdp_deflator L(1/8).unemployment L(1/8).fedfunds L(0/12).resid_romer if inrange(dateq, tq(`start_date'), tq(`end_date'))
// reg unemployment L(1/8).gdp_deflator L(1/8).unemployment L(1/8).fedfunds L(0/12).resid_romer if inrange(dateq, tq(`start_date'), tq(`end_date'))
// reg fedfunds L(1/8).gdp_deflator L(1/8).unemployment L(1/8).fedfunds L(0/12).resid_romer if inrange(dateq, tq(`start_date'), tq(`end_date'))

var gdp_deflator unemployment fedfunds if inrange(dateq, tq(`start_date'), tq(`end_date')), lags(1/8) exog(L(0/12).resid_romer)
irf create order1, set(var1.irf) replace step(20)
irf graph irf, xlabel(0(4)20) irf(order1) yline(0,lcolor(black)) byopts(yrescale)
graph export macroC_ps2_2b_non_romer.png, replace

var gdp_deflator unemployment fedfunds if inrange(dateq, tq(`start_date'), tq(`end_date')), lags(1/8) exog(L(0/12).resid_romer)
irf create dm, set(myirf) step(20) replace
irf graph dm, impulse(resid_romer) response(gdp_deflator unemployment fedfunds) xlabel(0(4)20) irf(dm) yline(0,lcolor(black)) byopts(yrescale)
graph export macroC_ps2_2b_romer.png, replace




//2c
// A is the constraints on our variable relationships
matrix A2 = (1,0,0,0 \ .,1,0,0 \ .,.,1,0 \ .,.,.,1)
// B is the constraints on the covariance/variance between contemporaneous shocks
matrix B2 = (.,0,0,0 \ 0,.,0,0 \ 0,0,.,0 \ 0,0,0,.)

//running the ordered structural VAR with 4 lags according to our constraints
svar resid_romer gdp_deflator unemployment fedfunds if inrange(dateq, tq(`start_date'), tq(`end_date')), lags(1/4) aeq(A2) beq(B2)

irf create order1, set(var2.irf) replace step(20)
irf graph sirf, xlabel(0(4)20) irf(order1) yline(0,lcolor(black)) byopts(yrescale)
graph export macroC_ps2_2c.png, replace

//Briefly, explain why it is sensible to order the Romer shock first in the VAR.
/* It is sensible to order the Romer shock first in the ordered VAR because it's not determined by anything contemporaneously. It is completely exogenous contemporaneously.
*/

//2e
//Compare the IRFs for the Romer shocks from the two methods. How are they different, and why?
/*

*/
