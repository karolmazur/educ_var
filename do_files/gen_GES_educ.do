* Peter Xue
* This file generates education variables for heads and children.
* This version: 2023-06


clear all
set more off

*** Change the working directory before running the .do file ***

global filepath = "C:/Users/user/Desktop/educ_var" 



*============ isolate head, son, daughter info from the individual-level dataset =============

use "$filepath/temp_data/individual_all.dta"


* keep related variables
local varlist "hhid year memberid pre_mem_id rel age male edu_level yrs_edu yr_stop_edu rea_stop_edu rea_stop_edu_ot dropout_before_09 dropout_after_09 main_occp main_occp_ot subs_occp subs_occp_ot height weight arm_circum ch_stat"
keep `varlist'
label var dropout_before_09 "dropout before 2009"
label var dropout_after_09 "dropout after 2009"
order hhid year memberid pre_mem_id  rel age ch_stat male edu_level yrs_edu yr_stop_edu rea_stop_edu rea_stop_edu_ot dropout_before_09 dropout_after_09 main_occp main_occp_ot subs_occp subs_occp_ot height weight arm_circum 

*1. household head
preserve

* select head
keep if rel==1

* rename variables
ssc install renvarlab, replace
local varlist2 "age male edu_level yrs_edu yr_stop_edu rea_stop_edu rea_stop_edu_ot main_occp main_occp_ot subs_occp subs_occp_ot height weight arm_circum dropout_before_09 dropout_after_09"
renvarlab `varlist2', prefix(head_)

save "$filepath/temp_data/individual_head_educ.dta", replace

restore

*2. household son
preserve

* select son
keep if rel==5

sort year, stable

sort hhid, stable

* calculate the number of sons
by hhid memberid, sort: gen nvals=_n==1
// if son appears for the first time, assign the value as 1, otherwise 0.
bys hhid: egen totalson = sum(nvals)
order hhid year totalson
sort hhid year


save "$filepath/temp_data/individual_son_educ.dta", replace

restore

*3. household daughter
preserve

* select daughter
keep if rel==6

sort year, stable

sort hhid, stable

* calculate the number of daughters
by hhid memberid, sort: gen nvals=_n==1
// if daughter appears for the first time, assign the value as 1, otherwise 0.
bys hhid: egen totaldaughter = sum(nvals)
order hhid year totaldaughter
sort hhid year

save "$filepath/temp_data/individual_daughter_educ.dta", replace

restore


