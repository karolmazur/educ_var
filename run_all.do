* =========================================================================== *

** All the results below are generated on a Windows 11 computer with Stata SE 15.0. 

* =========================================================================== *

clear all 
set more off

//  log using record, text

* Define the file path
global path "C:/Users/user/Desktop/educ_var"

* clean GES data
do "$path/do_files/clean_GES_hh_details.do"

* obtain individual-level education data
do "$path/do_files/gen_GES_educ.do"

* clean HCS2014 data to obtain household-level data of total anmount of gov't benefits received
do "$path/do_files/clean_HCS_2014_govt_prog.do"

* clean transaction module data to obtain household-level data of education expenditure
do "$path/do_files/clean_transaction_educ.do"


// log close _all
