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

data covid.cases_agesex; 
set xlscov.'CASES_AGESEX'n;
run; 

proc contents data=xlscov._all_; 
run;
