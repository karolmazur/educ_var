* Peter Xue
* This file cleans trnascation schedule non-food items to get education expenditure of households
* This version: 2023-06


clear all
set more off

*** Change the working directory before running the .do file ***

global filepath = "C:/Users/user/Desktop/educ_var" 

*========================2009=============================
	
* import the full dataset
import excel "$filepath/orig_data/2009/transaction/Non_food_items.xlsx", firstrow clear
	
destring *, replace

* reorganize VDS_ID
gen country = substr(VDS_ID,1,1)
gen state = substr(VDS_ID,2,2)
gen village = substr(VDS_ID,6,1)
gen household = substr(VDS_ID,7,4)

gen hhid = country + "-" + state + "-" + village + "-" + household
order VDS_ID hhid country state village household
replace vil = state + "-" + village

rename *, lower

* focus on education expenditure
keep if nf_item_name=="Education(Fee,books,stationary,transport,uniform)"
keep hhid period_from period_to nf_tot_val

* identify educ expenditure for different periods
gen aa = substr(period_from,7,4)
destring aa, replace
gen bb = substr(period_to,7,4)
destring bb, replace
gen ii = (aa==bb) // no need to worry about year-cross
gen year = bb
drop aa bb ii period_from period_to

preserve
keep if year == 2009
bysort hhid: egen educ_expen_2009 = sum(nf_tot_val)
duplicates drop hhid, force
keep hhid educ_expen_2009
save "$filepath/temp_data/educ_expen_2009.dta", replace
// NOTE: only have 09 second half
restore

preserve
keep if year == 2010
bysort hhid: egen educ_expen_2010 = sum(nf_tot_val)
duplicates drop hhid, force
keep hhid educ_expen_2010
save "$filepath/temp_data/educ_expen_2010.dta", replace
restore

*========================2010=============================

* import the full dataset
import excel "$filepath/orig_data/2010/transaction/Non_food_items.xlsx", firstrow clear
	
destring *, replace

* reorganize VDS_ID
gen country = substr(VDS_ID,1,1)
gen state = substr(VDS_ID,2,2)
gen village = substr(VDS_ID,6,1)
gen household = substr(VDS_ID,7,4)

gen hhid = country + "-" + state + "-" + village + "-" + household
order VDS_ID hhid country state village household
replace vil = state + "-" + village

rename *, lower

* focus on education expenditure
keep if nf_item_name=="Education(Fee,books,stationary,transport,uniform)"
keep hhid sur_mon_yr nf_tot_val

* identify educ expenditure for different periods
gen year = substr(sur_mon_yr,4,2)
destring year, replace
replace year = 2011 if year == 11
replace year = 2010 if year == 10
drop sur_mon_yr

preserve
keep if year == 2010
bysort hhid: egen educ_expen_2010_2 = sum(nf_tot_val)
duplicates drop hhid, force
keep hhid educ_expen_2010_2
merge using "$filepath/temp_data/educ_expen_2010.dta"
gen educ_expen2010 = educ_expen_2010_2 + educ_expen_2010
drop _merge educ_expen_2010 educ_expen_2010_2 
// aggregation is reasonable because the 2009 survey records consumption from 01/10-06/10, and 2010 survey records consumption from 07/10-12/10.
save "$filepath/temp_data/educ_expen_2010.dta", replace
restore

preserve
keep if year == 2011 // first half of 2011
bysort hhid: egen educ_expen_2011 = sum(nf_tot_val)
duplicates drop hhid, force
keep hhid educ_expen_2011
save "$filepath/temp_data/educ_expen_2011.dta", replace
restore


*========================2011=============================
* import the full dataset
import excel "$filepath/orig_data/2011/transaction/Non_food_items.xlsx", firstrow clear
	
destring *, replace

* reorganize VDS_ID
gen country = substr(VDS_ID,1,1)
gen state = substr(VDS_ID,2,2)
gen village = substr(VDS_ID,6,1)
gen household = substr(VDS_ID,7,4)

gen hhid = country + "-" + state + "-" + village + "-" + household
order VDS_ID hhid country state village household
replace vil = state + "-" + village

rename *, lower

* focus on education expenditure
keep if nf_item_name=="Education expenses"
keep hhid sur_mon_yr nf_tot_val

* identify educ expenditure for different periods
gen year = substr(sur_mon_yr,4,2)
destring year, replace
replace year = 2012 if year == 12
replace year = 2011 if year == 11
drop sur_mon_yr

preserve
keep if year == 2011
bysort hhid: egen educ_expen_2011_2 = sum(nf_tot_val)
duplicates drop hhid, force
keep hhid educ_expen_2011_2
merge using "$filepath/temp_data/educ_expen_2011.dta"
gen educ_expen2011 = educ_expen_2011_2 + educ_expen_2011
drop _merge educ_expen_2011 educ_expen_2011_2 
save "$filepath/temp_data/educ_expen_2011.dta", replace
restore

preserve
keep if year == 2012 // first half of 2012
bysort hhid: egen educ_expen_2012 = sum(nf_tot_val)
duplicates drop hhid, force
keep hhid educ_expen_2012
save "$filepath/temp_data/educ_expen_2012.dta", replace
restore

*========================2012=============================
* import the full dataset
foreach x in "AP" "GJ" "KN" "MH" "MP"{
  import excel "$filepath/orig_data/2012/transaction/Non_food_items_`x'.xlsx", firstrow clear
  save "$filepath/temp_data/Non_food_items_`x'_2012.dta", replace
  clear
}

use "$filepath/temp_data/Non_food_items_AP_2012.dta"
foreach x in "GJ" "KN" "MH" "MP"{
  append using "$filepath/temp_data/Non_food_items_`x'_2012.dta", force
}

destring *, replace

* reorganize VDS_ID
gen country = substr(VDS_ID,1,1)
gen state = substr(VDS_ID,2,2)
gen village = substr(VDS_ID,6,1)
gen household = substr(VDS_ID,7,4)

gen hhid = country + "-" + state + "-" + village + "-" + household
order VDS_ID hhid country state village household
replace vil = state + "-" + village

rename *, lower

* focus on education expenditure
keep if nf_item_name=="Education expenses"
keep hhid sur_mon_yr nf_tot_val

* identify educ expenditure for different periods
gen year = substr(sur_mon_yr,4,2)
destring year, replace
replace year = 2013 if year == 13
replace year = 2012 if year == 12
drop sur_mon_yr

preserve
keep if year == 2012
bysort hhid: egen educ_expen_2012_2 = sum(nf_tot_val)
duplicates drop hhid, force
keep hhid educ_expen_2012_2
merge using "$filepath/temp_data/educ_expen_2012.dta"
gen educ_expen2012 = educ_expen_2012_2 + educ_expen_2012
drop _merge educ_expen_2012 educ_expen_2012_2 
save "$filepath/temp_data/educ_expen_2012.dta", replace
restore

preserve
keep if year == 2013 
bysort hhid: egen educ_expen_2013 = sum(nf_tot_val)
duplicates drop hhid, force
keep hhid educ_expen_2013
save "$filepath/temp_data/educ_expen_2013.dta", replace
restore

* erase temp data
foreach x in "AP" "GJ" "KN" "MH" "MP"{
  erase "$filepath/temp_data/Non_food_items_`x'_2012.dta"
}

*========================2013=============================
* import the full dataset
foreach x in "AP" "GJ" "KN" "MH" "MP"{
  import excel "$filepath/orig_data/2013/transaction/Non_food_items_`x'.xlsx", firstrow clear
  save "$filepath/temp_data/Non_food_items_`x'_2013.dta", replace
  clear
}

use "$filepath/temp_data/Non_food_items_AP_2013.dta"
foreach x in "GJ" "KN" "MH" "MP"{
  append using "$filepath/temp_data/Non_food_items_`x'_2013.dta", force
}

destring *, replace

* reorganize VDS_ID
gen country = substr(VDS_ID,1,1)
gen state = substr(VDS_ID,2,2)
gen village = substr(VDS_ID,6,1)
gen household = substr(VDS_ID,7,4)

gen hhid = country + "-" + state + "-" + village + "-" + household
order VDS_ID hhid country state village household
replace vil = state + "-" + village

rename *, lower

* focus on education expenditure
replace nf_item_name = strrtrim(nf_item_name) // trim space characters (right-side)
keep if nf_item_name=="Education expenses"
keep hhid sur_mon_yr nf_tot_val

* identify educ expenditure for different periods
gen year = substr(sur_mon_yr,4,2)
destring year, replace
replace year = 2013 if year == 13
replace year = 2014 if year == 14
drop sur_mon_yr

preserve
keep if year == 2013
bysort hhid: egen educ_expen_2013_2 = sum(nf_tot_val)
duplicates drop hhid, force
keep hhid educ_expen_2013_2
merge using "$filepath/temp_data/educ_expen_2013.dta"
gen educ_expen2013 = educ_expen_2013_2 + educ_expen_2013
drop _merge educ_expen_2013 educ_expen_2013_2 
save "$filepath/temp_data/educ_expen_2013.dta", replace
restore

preserve
keep if year == 2014
bysort hhid: egen educ_expen_2014 = sum(nf_tot_val)
duplicates drop hhid, force
keep hhid educ_expen_2014
save "$filepath/temp_data/educ_expen_2014.dta", replace
restore

* erase temp data
foreach x in "AP" "GJ" "KN" "MH" "MP"{
  erase "$filepath/temp_data/Non_food_items_`x'_2013.dta"
}


*========================2014=============================
* import the full dataset
import excel "$filepath/orig_data/2014/transaction/Non_food_items.xlsx", firstrow clear
	
destring *, replace

* reorganize VDS_ID
gen country = substr(VDS_ID,1,1)
gen state = substr(VDS_ID,2,2)
gen village = substr(VDS_ID,6,1)
gen household = substr(VDS_ID,7,4)

gen hhid = country + "-" + state + "-" + village + "-" + household
order VDS_ID hhid country state village household
replace vil = state + "-" + village

rename *, lower

* focus on education expenditure
replace nf_item_name = strrtrim(nf_item_name)
keep if nf_item_name=="Education expenses"
keep hhid sur_mon_yr nf_tot_val

* identify educ expenditure for different periods
gen year = substr(sur_mon_yr,4,2)
destring year, replace
replace year = 2014 if year == 14
replace year = 2015 if year == 15
drop sur_mon_yr

preserve
keep if year == 2014
bysort hhid: egen educ_expen_2014_2 = sum(nf_tot_val)
duplicates drop hhid, force
keep hhid educ_expen_2014_2
merge 1:m hhid using "$filepath/temp_data/educ_expen_2014.dta"
gen educ_expen2014 = educ_expen_2014_2 + educ_expen_2014
drop _merge educ_expen_2014 educ_expen_2014_2 
save "$filepath/temp_data/educ_expen_2014.dta", replace
restore

// 2015 data omitted

*============= merge 09-14 educ expen data =================
clear
use "$filepath/temp_data/educ_expen_2009.dta"

forvalues y = 2010/2014{
  merge 1:m hhid using "$filepath/temp_data/educ_expen_`y'.dta"
  drop _merge
}

* wide to long
rename educ_expen_2009 educ_expen2009
reshape long educ_expen, i(hhid) j(year)
save "$filepath/temp_data/hh_educ_expen.dta", replace


* erase temp data
forvalues y = 2009/2014{
	erase "$filepath/temp_data/educ_expen_`y'.dta"
}

