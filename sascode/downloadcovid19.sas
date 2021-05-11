options mprint symbolgen ; 

%let homedir=%sysget(HOME); 
/*%let sample=hmeq; %let caslib=casuser; */
%let path=&homedir;
options dlcreatedir; 
libname data "&path"; 



libname covid "&path/covid19"; 

filename out "&path/covid19/COVID19BE.xlsx";
proc http
 url='https://epistat.sciensano.be/Data/COVID19BE.xlsx'
 method="get" out=out;
 *debug level=3;
run;

libname xlscov xlsx "&path/covid19/COVID19BE.xlsx"; 
proc contents data=xlscov._all_; 
run;
/*copy all sheets to sas tables*/
proc copy inlib=xlscov outlib=covid; 
run; 
cas mysession; 
proc casutil ; 
droptable casdata="covid19_cases_agesex" quiet; 
droptable casdata="covid19_hosp" quiet; 
droptable casdata="covid19_mort" quiet; 
droptable casdata="covid19_tests" quiet; 
droptable casdata="covid19_cases_muni" quiet; 
droptable casdata="covid19_cases_muni_cum" quiet; 
droptable casdata="covid19_vacc" quiet; 
droptable casdata="covid19_vacc_muni_cum" quiet; 
load data=covid.cases_agesex casout="covid19_cases_agesex";
load data=covid.hosp casout="covid19_hosp";
load data=covid.mort casout="covid19_mort"; 
load data=covid.tests casout="covid19_tests"; 
load data=covid.cases_muni casout="covid19_cases_muni"; 
load data=covid.cases_muni_cum casout="covid19_cases_muni_cum"; 
load data=covid.vacc casout="covid19_vacc"; 
load data=covid.vacc_muni_cum casout="covid19_vacc_muni_cum"; 

quit; 
