/****************************/
/*       sample sql code    */
/****************************/

* create an sql view;
* and count number of observations into a macro variable;

proc sql;
 create view a1 as 
 select * 
 from sashelp.baseball 
 order by team;
 select count(team) into: num_teams
 from a1;
quit;
%put num_teams=&num_teams;

proc sql noprint;
  select count (*) INTO : numvars 
  from sashelp.vcolumn
  where memname = "BASEBALL";
quit;

proc sql ;
  select count (*) as numcols label = "number of columns" 
  from sashelp.vcolumn
  where memname = "BASEBALL";
quit;

proc sql noprint;
	select nobs into :nobs separated by ' ' from dictionary.tables
	where libname='SASHELP' and memname='BASEBALL';
quit;
 
%put TNote:  nobs=&nobs;

%macro obscnt(dsn);
 %local nobs dsnid;
 %let nobs=.;
  
 %* Open the data set of interest;
 %let dsnid = %sysfunc(open(&dsn));
 
 %* If the open was successful get the;
 %* number of observations and CLOSE &dsn;
 %if &dsnid %then %do;
     %let nobs=%sysfunc(attrn(&dsnid,nlobs));
     %let rc  =%sysfunc(close(&dsnid));
 %end;
 %else %do;
     %put Unable to open &dsn - %sysfunc(sysmsg());
 %end;
 
%* Return the number of observations;
%put nobs=&nobs;
%mend obscnt;

options mprint mlogic;

%obscnt(sashelp.baseball);
