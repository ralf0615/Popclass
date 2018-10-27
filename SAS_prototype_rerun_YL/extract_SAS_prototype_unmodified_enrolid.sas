
%include '/opt/SAS94/SASFoundation/9.4/autoexec.sas';

Options obs=max mprint mlogic;

%Let Prevyear=2013;
%Let     year=2014;
%Let Nextyear=2015;
%Let MSversionPrev=133;
%Let MSversion    =143;
%Let MSversionNext=152;
%Let StartDate='31DEC2014'd; /* always choose the end of month */
%let version=31DEC2014Client450_10162018;
%Let AEoutpath=/rpscan/u071439/AEout/&version.;
%Let outpath=/rpscan/u071439/output/&version.;
%Let username=u071439;
%Let createMScopy=0;  /* set this to 1 if we want to create the MarketScan version */ 
%Let skipImport=1; /* set this to 1 if we create directly the SAS dataset SamplewClassification and we want to skip the import */

x "mkdir -p /rpscan/u071439/temp/&version.";
x "mkdir -p /rpscan/u071439/AEout/&version.";
x "mkdir -p /rpscan/u071439/output/&version.";
libname temp "/rpscan/u071439/temp/&version.";

%macro libsetup;
%if &createMScopy.=1 %then %do;
	libname arch&year. "/rpscan/u071439/temp/&version.";
	libname arch&Nextyear. "/rpscan/u071439/temp/&version.";
%end;
%mend libsetup;

/*** create the sample file if needed ***/
/*import MCC cohort*/
data temp.SamplewClassification;
set arch&year..ccaea&MSversion.;
keep enrolid;
where client=450 and enrind12=1;
run;

*** export data into csv;
proc export
data=temp.SamplewClassification
outfile="&AEoutpath./SamplewClassification.csv"
replace;
run;

