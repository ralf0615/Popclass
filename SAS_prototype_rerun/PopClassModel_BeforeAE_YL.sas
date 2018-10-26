/*** connect to the nike server - trvlapp1465.tsh.thomson.com ***/

%include '/opt/SAS94/SASFoundation/9.4/autoexec.sas';

Options obs=max mprint mlogic;

%Let Prevyear=2014;
%Let     year=2015;
%Let Nextyear=2016;
%Let MSversionPrev=143;
%Let MSversion    =153;
%Let MSversionNext=162;
%Let StartDate='31DEC2015'd; /* always choose the end of month */
%let version=31DEC2015Client200_10252018;
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

*** exclusions for what not is considered to be a specialist (Anne);
%Let SpecExclusionList=200,202,204,206,240,245,320,400;
*** exclusions for what counts as a visit based on SvcCat and Procedure (Amy);
%Let SvcCatExclusionList="30","32","37","38","51","52","53","54","55","56","59","61","62","63","64","65","66","67","68","69";
%Let ProcExclusionList="36415","G0001","36400","36405","36406","36410","36416";
*** CPT codes for Oxygen;
%let OxygenCPTList="E0431","E0434","E0439","E0441","E0442","E0443","E0444","E1390","E1392","K0738";
*** Therapeutic Intermediate Classes for Opiates;
%let OpiatesTCLS=60,61;
%let OpiatesGNID=108156,118478,124984,124986,124988,128184,128947,129199,129311,129314,129315,130023,131028,131029,131146,131486;
%let SvcCatMHSA='PSY02','PSY03','PSY80';
%let SvcCatGYN='GYN01','GYN02','GYN03','GYN06','GYN09','GYN10','GYN12','GYN27','GYN29','GYN30';
*** Rebalance;
%let ConditionDxCat='CVS11','CVS10';
%let ConditionDxCatStage=3;
%let ConditionDxCatER='PSY';
%let ConditionDRG='280','281','282','283','284','285','239','241','474','475','476','616','617','618','619','620','621','003','004','011','012','013','240';
%let ConditionAdminType='4';
%let ConditionProcGRP='0090','0095','2370','1045','4580','4585';
*** NeoNates;
%let NeonatesDRGList=790,791,792,793,794,795;



* Beginning of Ujwal's modification regarding setting up SamplewClassification;
* Import a list of 2000 enrolid;
PROC IMPORT
DATAFILE='/rpscan/u071439/data/enrolids_200.csv'
OUT=enrolids
DBMS=CSV
REPLACE;
GETNAMES=YES;
GUESSINGROWS=MAX;
RUN;

data ccaea;
infile '/rpscan/u071439/data/ccaea.csv' delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
informat 'ENROLID'n BEST32.;
informat 'AGE'n BEST32.;
informat 'SEX'n $1.;
informat 'MSA'n BEST32.;
informat 'RX'n $1.;
informat 'ENRIND1'n BEST32.;
informat 'ENRIND2'n BEST32.;
informat 'ENRIND3'n BEST32.;
informat 'ENRIND4'n BEST32.;
informat 'ENRIND5'n BEST32.;
informat 'ENRIND6'n BEST32.;
informat 'ENRIND7'n BEST32.;
informat 'ENRIND8'n BEST32.;
informat 'ENRIND9'n BEST32.;
informat 'ENRIND10'n BEST32.;
informat 'ENRIND11'n BEST32.;
informat 'ENRIND12'n BEST32.;
informat 'PLNTYP1'n BEST32.;
informat 'PLNTYP2'n BEST32.;
informat 'PLNTYP3'n BEST32.;
informat 'PLNTYP4'n BEST32.;
informat 'PLNTYP5'n BEST32.;
informat 'PLNTYP6'n BEST32.;
informat 'PLNTYP7'n BEST32.;
informat 'PLNTYP8'n BEST32.;
informat 'PLNTYP9'n BEST32.;
informat 'PLNTYP10'n BEST32.;
informat 'PLNTYP11'n BEST32.;
informat 'PLNTYP12'n BEST32.;
format 'ENROLID'n BEST12.;
format 'AGE'n BEST12.;
format 'SEX'n $1.;
format 'MSA'n BEST12.;
format 'RX'n $1.;
format 'ENRIND1'n BEST12.;
format 'ENRIND2'n BEST12.;
format 'ENRIND3'n BEST12.;
format 'ENRIND4'n BEST12.;
format 'ENRIND5'n BEST12.;
format 'ENRIND6'n BEST12.;
format 'ENRIND7'n BEST12.;
format 'ENRIND8'n BEST12.;
format 'ENRIND9'n BEST12.;
format 'ENRIND10'n BEST12.;
format 'ENRIND11'n BEST12.;
format 'ENRIND12'n BEST12.;
format 'PLNTYP1'n BEST12.;
format 'PLNTYP2'n BEST12.;
format 'PLNTYP3'n BEST12.;
format 'PLNTYP4'n BEST12.;
format 'PLNTYP5'n BEST12.;
format 'PLNTYP6'n BEST12.;
format 'PLNTYP7'n BEST12.;
format 'PLNTYP8'n BEST12.;
format 'PLNTYP9'n BEST12.;
format 'PLNTYP10'n BEST12.;
format 'PLNTYP11'n BEST12.;
format 'PLNTYP12'n BEST12.;
label 'ENROLID'n = 'ENROLID';
label 'AGE'n = 'AGE';
label 'SEX'n = 'SEX';
label 'MSA'n = 'MSA';
label 'RX'n = 'RX';
label 'ENRIND1'n = 'ENRIND1';
label 'ENRIND2'n = 'ENRIND2';
label 'ENRIND3'n = 'ENRIND3';
label 'ENRIND4'n = 'ENRIND4';
label 'ENRIND5'n = 'ENRIND5';
label 'ENRIND6'n = 'ENRIND6';
label 'ENRIND7'n = 'ENRIND7';
label 'ENRIND8'n = 'ENRIND8';
label 'ENRIND9'n = 'ENRIND9';
label 'ENRIND10'n = 'ENRIND10';
label 'ENRIND11'n = 'ENRIND11';
label 'ENRIND12'n = 'ENRIND12';
label 'PLNTYP1'n = 'PLNTYP1';
label 'PLNTYP2'n = 'PLNTYP2';
label 'PLNTYP3'n = 'PLNTYP3';
label 'PLNTYP4'n = 'PLNTYP4';
label 'PLNTYP5'n = 'PLNTYP5';
label 'PLNTYP6'n = 'PLNTYP6';
label 'PLNTYP7'n = 'PLNTYP7';
label 'PLNTYP8'n = 'PLNTYP8';
label 'PLNTYP9'n = 'PLNTYP9';
label 'PLNTYP10'n = 'PLNTYP10';
label 'PLNTYP11'n = 'PLNTYP11';
label 'PLNTYP12'n = 'PLNTYP12';
input    'ENROLID'n
'AGE'n
'SEX'n $
'MSA'n
'RX'n $
'ENRIND1'n
'ENRIND2'n
'ENRIND3'n
'ENRIND4'n
'ENRIND5'n
'ENRIND6'n
'ENRIND7'n
'ENRIND8'n
'ENRIND9'n
'ENRIND10'n
'ENRIND11'n
'ENRIND12'n
'PLNTYP1'n
'PLNTYP2'n
'PLNTYP3'n
'PLNTYP4'n
'PLNTYP5'n
'PLNTYP6'n
'PLNTYP7'n
'PLNTYP8'n
'PLNTYP9'n
'PLNTYP10'n
'PLNTYP11'n
'PLNTYP12'n;
run;

%Let lastmonth=%sysfunc(month(&StartDate.),2.);
proc sql;
Create Table temp.SamplewClassification as select a.enrolid,
' ' as AssignmentFinal
from ccaea a
inner join enrolids e  On e.enrolid = a.enrolid
where a.enrind&lastmonth.=1;
quit;
* End of Ujwal's modification regarding setting up SamplewClassification;


* Save temp.SampleClassification to csv;
proc export
data=temp.SamplewClassification
outfile="&AEoutpath./&version._SamplewClassification.csv"
replace;
run;



*** importing the MetaData;
%macro ImportMeta(inputdata,sasoutput);
%if &sasoutput.=SamplewClassification and &skipImport.=1 %then %return;
PROC IMPORT
datafile="/rpscan/u071439/data/&inputdata."
out=temp.&sasoutput.
replace;
getnames=YES;
guessingrows=MAX;
run;
%mend ImportMeta;
*** sample of 100 patients with classification;
%ImportMeta(AllClientSample&version..csv,SamplewClassification);
*** Crossmap from HCPC codes to Procedure Groups --- not used anymore;
%ImportMeta(HCPCcrossmapPROCGRP16r2.csv,HcpcXwalkGRP);*/
*** List of DxCat and HCPC that define cancer treamtent;
%ImportMeta(JanetMetadata_CancerTreatment.csv,CancerTreatment);
*** DxCat mapping into chronic or acute;
%ImportMeta(JanetMetadata_GeneralAssignments.csv,GeneralAssignments);
*** Import the Mapping of Procedure Group (OPEG) to ATG;
%ImportMeta(FromOPEG_ProcedureGroup_lookup_v2015_2.csv,OPEGLookup);
*** Import the Mapping from DxCat to Significant Conditions;
%ImportMeta(JanetMetadata_SignificantConditions.csv,SignificantConditions);
*** Import the Maintenance Drugs List;
%ImportMeta(JanetMetadata_MaintenanceDrugs.csv,ChronicRx);
*** Import the mapping to Body Systems List;
%ImportMeta(JanetMetadata_BodySystem.csv,BodySystem);
*** Import the list of conditions for Treatment Navigation logic;
%ImportMeta(JanetMetadata_TreatmentNavigation.csv,TreatmentNavigation);
*** Import the list of DxCats for general active cancer for Surveillance logic;
%ImportMeta(JanetMetadata_SurveillanceGeneralActiveCancerDxCat.csv,SurvGeneralActiveCancerDxCat);
*** Import the list of PROCGRP for general active cancer for Surveillance logic;
%ImportMeta(JanetMetadata_SurveillanceGeneralActiveCancerPROCGRP.csv,SurvGeneralActiveCancerPROCGRP);


*** Ujwal's modification regarding temp.SurvSpecificActiveCancer;
data  temp.SurvSpecificActiveCancer;
infile '/rpscan/u071439/data/JanetMetadata_SurveillanceSpecificActiveCancer.csv' delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
informat 'DxCat'n $5.;
informat 'DxCatDesc'n $75.;
informat 'PROCGRP'n BEST32.;
informat 'Procedure_group'n $51.;
informat 'stage'n BEST32.;
format 'DxCat'n $5.;
format 'DxCatDesc'n $75.;
format 'PROCGRP'n BEST12.;
format 'Procedure_group'n $51.;
format 'stage'n BEST12.;
label 'DxCat'n = 'DxCat';
label 'DxCatDesc'n = 'DxCatDesc';
label 'PROCGRP'n = 'PROCGRP';
label 'Procedure_group'n = 'Procedure group';
label 'stage'n = 'stage';
input    'DxCat'n $
'DxCatDesc'n $
'PROCGRP'n
'Procedure_group'n $
'stage'n;
run;
*** Ujwal's modification regarding temp.SurvSpecificActiveCancer;


*** Import the list of PROCGRP for miscellaneous for Surveillance logic;
%ImportMeta(JanetMetadata_SurveillanceMiscellaneous.csv,SurvMiscellaneous);
*** Import the list of PROCGRP for Chemo Active for Surveillance;
%ImportMeta(JanetMetadata_SurveillanceChemoActive.csv,SurvChemoActive);
*** Import the list of PROCGRP for Chemo Chronic for Surveillance;
%ImportMeta(JanetMetadata_SurveillanceChemoChronic.csv,SurvChemoChronic);
*** Import the list of DxCat for Rebalance, new conditions;
%ImportMeta(JanetMetadata_RebalanceNewDxCat.csv,RebalanceNewDxCat);
*** Import the list of DxCat for Rebalance, new conditions wo drugs in the prior 90 days;
%ImportMeta(JanetMetadata_RebalanceNewDxCatwoRx.csv,RebalanceNewDxCatwoRx);
*** Import the list of DxCat for Rebalance, new ICD9;
%ImportMeta(JanetMetadata_RebalanceNewDx.csv,RebalanceNewDx);
*** Import the list of DxCat for Rebalance, new DRG;
%ImportMeta(JanetMetadata_RebalanceNewDRG.csv,RebalanceNewDRG);

*** labels for all categories, the ranking is important!!!;
proc format;
value categories
10='Crisis Management'
9='Surveillance'
8='Rebalancing'
7='Recovery Guidance'
6='Monitoring'
5='Coordination'
4='Treatment Navigation'
3='Support'
2='Prevention'
1='Engagement'
;

value RuleConfidence
1= 0.933
2= 0.6
3= 0.667
4= 0.865
5= 0.667
6= 0.667
7= 0.851
8= 0.727
9= 0.75
10= 0.765
11= 0.667
12= 0.909
13= 0.667
;

*** sort the sample by ENROLID, it is needed for the last merge at the end;
proc sort data=temp.SamplewClassification;
by enrolid;
run;

*** convert NDCNUM to character;
data temp.ChronicRx(drop=ndcnum_old);
set temp.ChronicRx(rename=(ndcnum=ndcnum_old));
NDCNUM=put(ndcnum_old,z11.);
run;

*** creating a format for Acute/Chronic;
data trash(keep=start label fmtname);
set temp.GeneralAssignments;
start=DxCat;
label=Category;
fmtname='$DxCatAssign';
run;
proc format cntlin=trash; run;

*** creating a format for Significant DxCat;
data trash(keep=start label fmtname);
set temp.SignificantConditions;
start=DxCat;
label=Significance;
fmtname='$DxCatHigh';
run;
proc format cntlin=trash; run;

*** creating a format for Body Systems;
data trash(keep=start label fmtname hlo);
set temp.BodySystem end=end;
start=DxCat;
label=Body;
fmtname='$DxCatBody';
if end then do;
hlo='O';                            /* for DxCats that are not in the map from Janet, just map them to '99'-Other */
label='99';
end;
run;
proc format cntlin=trash; run;

*** creating a format for list of DxCat (based on Dx conditions) for Surveillance - Active Cancer definition;
data trash(keep=start label fmtname);
set temp.SurvGeneralActiveCancerDxCat end=end;
where Type='Dx';
start=DxCat;
label='Y';
fmtname='$SurvActiveCancerDxcat';
run;
proc format cntlin=trash; run;

*** creating a format for list of DxCat (based on Px conditions) for Surveillance - Active Cancer definition;
data trash(keep=start label fmtname);
set temp.SurvGeneralActiveCancerDxCat end=end;
where Type='Px';
start=DxCat;
label='Y';
fmtname='$SurvActiveCancerPxDxcat';
run;
proc format cntlin=trash; run;

*** creating a format for list of ProcGRP (based on Px conditions) for Surveillance - Active Cancer definition;
data trash_1(keep=start label fmtname);
set temp.SurvGeneralActiveCancerPROCGRP end=end;
start=PROCGRP;
label='Y';
fmtname='SurvActiveCancerPROCGRP';
run;
proc format cntlin=trash_1; run;

********************************************************************************;
*%include '/rpscan/u071439/script/PopClassModel_BeforeAE_YL.sas';

********** run AE for DS using above configuration file-AE not working on nike;
****************x "&AEpath./AnalyticsEngine.sh &AEpath./Configfile.properties";

******************************************************************************;
*%include '/rpscan/u071439/script/PopClassModel_AfterAE_YL.sas';









/** create a copy of MarketScan for the timeframe defined by 1 year prior and after the &StartDate **/
%macro MarketScansetup;
%if &createMScopy.=1 %then %do;

* create a clone MarketScan INPATIENT data based on the reference date and looking back 1 year, same for the forward year *;
	data temp.ccaei&MSversion.;
	set 
		arch&year..ccaei&MSversion.(where=(admdate <= &StartDate.)) 
		arch&Prevyear..ccaei&MSversionPrev.(where=(admdate > &StartDate. - 366));
	keep
		ENROLID
		PDXCAT
		ADMDATE
		DISDATE
		DRG
		ADMTYP
		TOTPAY
		DSTATUS;
	run;
	data temp.ccaei&MSversionNext.;
	set 
		arch&Nextyear..ccaei&MSversionNext.(where=(admdate <= &StartDate. + 366))
		arch&year..ccaei&MSversion.(where=(admdate > &StartDate.)) ;
	keep
		ENROLID
		ADMDATE
		DRG
		TOTPAY
		DSTATUS;
	run;

* create a clone MarketScan OUTPATIENT data based on the reference date and looking back 1 year, same for the forward year *;
	data temp.ccaeo&MSversion.;
	set 
		arch&year..ccaeo&MSversion.(where=(svcdate <= &StartDate.) in=a) 
		arch&Prevyear..ccaeo&MSversionPrev.(where=(svcdate > &StartDate. - 366) in=b);
	keep
		ENROLID
		FACPROF
		SEQNUM
		AGE
		SEX
		PROC1
		DX1-DX4
		%if &Prevyear. >= 2015 %then DXVER;
		SVCSCAT
		SVCDATE
		MSCLMID
		FACHDID
		PROCGRP
		DXCAT
		STDPROV
		PAY
		;
	SEQNUM=_n_; /*avoid duplicated SEQNUM from different years */
	if a then FACHDID=10**11+FACHDID; /* avoid duplicates for FACHDID, modify it only for current year, numeric length is 6 max=132E9 */
	if a then MSCLMID=10**11+MSCLMID; /* avoid duplicates for MSCLMID, modify it only for current year, numeric length is 6 max=132E9 */
	run;
	data temp.ccaeo&MSversionNext.;
	set 
		arch&Nextyear..ccaeo&MSversionNext.(where=(svcdate <= &StartDate. + 366) in=b)
		arch&year..ccaeo&MSversion.(where=(svcdate > &StartDate.) in=a);		
	keep
		ENROLID
		SVCDATE
		PAY
		FACPROF
		SVCSCAT
		PROC1
		MSCLMID
		FACHDID;
	if a then FACHDID=10**11+FACHDID; /* avoid duplicates for FACHDID, modify it only for current year, numeric length is 6 max=132E9 */
	if a then MSCLMID=10**11+MSCLMID; /* avoid duplicates for MSCLMID, modify it only for current year, numeric length is 6 max=132E9 */
	run;


* create a clone MarketScan DRUGS data based on the reference date and looking back 1 year, same for the forward year *;
	data temp.ccaed&MSversion.;
	set 
		arch&year..ccaed&MSversion.(where=(svcdate <= &StartDate.)) 
		arch&Prevyear..ccaed&MSversionPrev.(where=(svcdate > &StartDate. - 366));
	keep
		ENROLID
		SVCDATE
		DAYSUPP
		NDCNUM
		GENERID
		THERCLS
		PAY;
	run;
	data temp.ccaed&MSversionNext.;
	set 
		arch&Nextyear..ccaed&MSversionNext.(where=(svcdate <= &StartDate. + 366))
		arch&year..ccaed&MSversion.(where=(svcdate > &StartDate.));		
	keep
		ENROLID
		SVCDATE
		PAY;
	run;

* create a clone MarketScan INPATIENT SERVICES, _S_ data based on the reference date and looking back 1 year, same for the forward year *;
	data temp.ccaes&MSversion.;
	set 
		arch&year..ccaes&MSversion.(where=(svcdate <= &StartDate.)) 
		arch&Prevyear..ccaes&MSversionPrev.(where=(svcdate > &StartDate. - 366));
	keep
		ENROLID
		SEQNUM
		AGE
		SEX
		PROC1
		%if &Prevyear. >= 2015 %then DXVER;
		DX1-DX4
		ADMTYP
		SVCSCAT
		SVCDATE;
	SEQNUM=_n_; /*avoid duplicated of SEQNUM from different years */
	run;

* create a clone MarketScan OUTPATIENT FACILITY HEADERS, _F_ data based on the reference date and looking back 1 year, same for the forward year *;
	data temp.ccaef&MSversion.;
	set 
		arch&year..ccaef&MSversion.(where=(svcdate <= &StartDate.) in=a) 
		arch&Prevyear..ccaef&MSversionPrev.(where=(svcdate > &StartDate. - 366) in=b);
	keep
		ENROLID
		SVCDATE
		TSVCDAT
		DAYS
		FACHDID
		CASEID;
	if a then FACHDID=10**11+FACHDID; /* avoid duplicates for FACHDID, modify it only for current year, numeric length is 6 max=132E9 */
	if a then CASEID=10**11+CASEID;   /* avoid duplicates for CASEID, modify it only for current year, numeric length is 6 max=132E9 */
	run;
	data temp.ccaef&MSversionNext.;
	set 
		arch&Nextyear..ccaef&MSversionNext.(where=(svcdate <= &StartDate. + 366) in=b)
		arch&year..ccaef&MSversion.(where=(svcdate > &StartDate.) in=a);		
	keep
		ENROLID
		FACHDID
		CASEID;
	if a then FACHDID=10**11+FACHDID; /* avoid duplicates for FACHDID, modify it only for current year, numeric length is 6 max=132E9 */
	if a then CASEID=10**11+CASEID;   /* avoid duplicates for CASEID, modify it only for current year, numeric length is 6 max=132E9 */
	run;

* create a clone MarketScan ENROLLMENT FILE data based on the reference date and looking back 1 year, same for the forward year *;
	data temp.ccaea&MSversion.;
	merge 		
		arch&year..ccaea&MSversion.(keep=enrolid age sex msa rx enrind1-enrind%sysfunc(month(&StartDate.)) plntyp1-plntyp%sysfunc(month(&StartDate.)) in=a) 
		arch&Prevyear..ccaea&MSversionPrev.(keep=enrolid enrind%eval(%sysfunc(month(&StartDate.))+1)-enrind12 plntyp%eval(%sysfunc(month(&StartDate.))+1)-plntyp12 in=b);
	by ENROLID;
	array e[12] enrind1-enrind12;
	if a;
	do i=1 to 12;
		e[i]=max(e[i],0);
	end;
	run;

	data temp.ccaea&MSversionNext.;
	merge 		
		arch&year..ccaea&MSversion.(keep=enrolid age sex msa rx enrind%eval(%sysfunc(month(&StartDate.))+1)-enrind12 plntyp%eval(%sysfunc(month(&StartDate.))+1)-plntyp12 in=a) 
		arch&Nextyear..ccaea&MSversionNext.(keep=enrolid enrind1-enrind%sysfunc(month(&StartDate.)) plntyp1-plntyp%sysfunc(month(&StartDate.)) in=b);
	by ENROLID;
	array e[12] enrind1-enrind12;
	if a;
	do i=1 to 12;
		e[i]=max(e[i],0);
	end;
	run;
	
%end;
%mend MarketScansetup;

%MarketScansetup;
%libsetup;


*** summarize the inpatient data ***;
************************************;

*** get all the inpatient data from the matched IDs;
PROC SQL;
Create Table trash201 as select 
	a.enrolid,
	a.pdxcat,
	a.admdate,
	a.disdate,
	a.drg,
	a.admtyp,
	a.totpay,
	a.dstatus
From 
	arch&year..ccaei&MSversion.			as a,
	temp.SamplewClassification	as b
Where
	a.enrolid=b.enrolid
Order by
	a.enrolid,
	a.admdate;

*** bring in the chronic/acute info based on principal PDx;
Create Table temp.SampleInp1 as select 
	a.*,
	b.category
From 
	trash201					as a
Left Join
	temp.GeneralAssignments		as b
On
	a.pdxcat=b.dxcat
Order by
	a.enrolid,
	a.admdate;
;
Quit;

/*** check some counts of patients/admissions in the data selected above;
PROC SQL;
select count (distinct enrolid) as count_ids from temp.SampleInp1;
select mean(count_admits) as average_admits from (select enrolid format=15.0, count(distinct admdate) as count_admits from temp.SampleInp1 group by enrolid);*/

PROC SQL;
*** count the unique(ENROLID+admdate) admits in the past 3 months;
Create View work.trash202 as
		Select
			enrolid,
			count(distinct admdate) as CountAdm3mAll
		From
			temp.SampleInp1
		Where
			admdate > &StartDate. - 90
		Group By
			enrolid;

*** count the unique(ENROLID+admdate) Chronic admits based on the principal PDx in the past 3 months;
Create View work.trash203 as
		Select
			enrolid,
			count(distinct admdate) as CountAdm3mChronic
		From
			temp.SampleInp1
		Where
			admdate > &StartDate. - 90 and
			category='Chronic'
		Group By
			enrolid;

*** count the uniqu(ENROLID+admdate) admits in the past 6 months;
Create View work.trash204 as
		Select
			enrolid,
			count(distinct admdate) as CountAdm6mAll
		From
			temp.SampleInp1
		Where
			admdate > &StartDate. - 180
		Group By
			enrolid;

*** count the unique(ENROLID+admdate) Chronic admits based on the principal PDx in the past 6 months;
Create View work.trash205 as
		Select
			enrolid,
			count(distinct admdate) as CountAdm6mChronic
		From
			temp.SampleInp1
		Where
			admdate > &StartDate. - 180 and
			category='Chronic'
		Group By
			enrolid;

*** sum all LOS in the past 90 days;
Create View work.trash206 as
		Select
			enrolid,
			sum(disdate-admdate+1) as SumLOS3mAll
		From
			temp.SampleInp1
		Where
			admdate > &StartDate. - 90
		Group By
			enrolid;

*** Days to the last admission(admdate) in the past year;
Create View work.trash207 as
		Select
			enrolid,
			&StartDate. - max(admdate) as DaysAnyAdm
		From
			temp.SampleInp1
		Group By
			enrolid;

*** Days to the last chronic admission(admdate) in the past year;
Create View work.trash208 as
		Select
			enrolid,
			&StartDate. - max(admdate) as DaysChronicAdm
		From
			temp.SampleInp1
		Where
			category='Chronic'
		Group By
			enrolid;

*** Days to the last surgical admission(admdate) in the past year;
Create View work.trash209 as
		Select
			enrolid,
			&StartDate. - max(admdate) as DaysSurgAdm
		From
			temp.SampleInp1
		Where
			admtyp='1'
		Group By
			enrolid;

*** Days to the last medical admission(admdate) in the past year;
Create View work.trash210 as
		Select
			enrolid,
			&StartDate. - max(admdate) as DaysMedicalAdm
		From
			temp.SampleInp1
		Where
			admtyp='2'
		Group By
			enrolid;

*** Days to the last maternity admission(admdate) in the past year;
Create View work.trash211 as
		Select
			enrolid,
			&StartDate. - max(admdate) as DaysMtrntyAdm
		From
			temp.SampleInp1
		Where
			admtyp='3'
		Group By
			enrolid;

*** Days to the last mental health/substance abuse admission(admdate) in the past year;
Create View work.trash212 as
		Select
			enrolid,
			&StartDate. - max(admdate) as DaysMHSAAdm
		From
			temp.SampleInp1
		Where
			admtyp='4'
		Group By
			enrolid;
Quit;

*** put all the inpatient related variables together;
DATA
	work.trash213;
Merge
	trash202(in=a)
	trash203(in=b)
	trash204(in=c)
	trash205(in=d)
	trash206(in=e)
	trash207(in=f)
	trash208(in=g)
	trash209(in=h)
	trash210(in=i)
	trash211(in=j)
	trash212(in=k);
By 
	enrolid;
If
	a or b or c or d or e or f or g or h or i or j or k;
run;

*** Merge with the original Sample and use counts of zero when no admissions;
PROC SQL;
Create Table temp.IP as
Select
	a.enrolid,
	max(0,b.CountAdm3mAll)			as CountAdm3mAll,
	max(0,b.CountAdm3mChronic)		as CountAdm3mChronic,
	max(0,b.CountAdm6mAll)			as CountAdm6mAll,
	max(0,b.CountAdm6mChronic)		as CountAdm6mChronic,
	max(0,b.SumLOS3mAll)			as SumLOS3mAll,
	min(365,DaysAnyAdm)				as DaysAnyAdm,
	min(365,DaysChronicAdm)			as DaysChronicAdm,
	min(365,DaysSurgAdm)			as DaysSurgAdm,
	min(365,DaysMedicalAdm)			as DaysMedicalAdm,
	min(365,DaysMtrntyAdm)			as DaysMtrntyAdm,
	min(365,DaysMHSAAdm)			as DaysMHSAAdm
From
	(Select distinct enrolid from temp.SamplewClassification) as a
Left Join
	work.trash213 as b
On
	a.enrolid=b.enrolid
Order by
	a.enrolid;


*** summarize the drugs data ***;
********************************;

*** get all the drugs data from the matched IDs;
PROC SQL;
Create Table trash301 as select distinct
	a.enrolid,
	a.svcdate,
	a.daysupp,
	a.ndcnum,
	a.generid,
	a.thercls,
	a.pay
From 
	arch&year..ccaed&MSversion.			as a,
	temp.SamplewClassification	as b
Where
	a.enrolid=b.enrolid
Order by
	a.enrolid,
	a.svcdate;

*** bring in the maintenance flag for the Rx based on metadata table;
Create Table temp.SampleRx1 as select 
	a.*,
	b.category
From 
	trash301			as a
Left Join
	temp.ChronicRx		as b
On
	a.ndcnum=b.ndcnum
Order by
	a.enrolid,
	a.svcdate;
;
Quit;

/*** check some counts of patients/drugs in the data selected above;
PROC SQL;
select count (distinct enrolid) as count_ids from temp.SampleRx1;
select mean(count_drugs) as average_drugs from (select enrolid format=15.0, count(distinct ndcnum) as count_drugs from temp.SampleRx1 group by enrolid);*/

*** count of maintenance drugs 1 year;
proc sql;
Create View work.trash302 as
		Select
			enrolid,
			max((category="Maintenance")) as FlagChronicRx
		From
			temp.SampleRx1
		Group By
			enrolid;


*** count of the new maintenance drugs in the past 90 days where no drugs in same thercls is found before;
proc sql;
Create View work.trash3031 as
		Select
			enrolid,
			thercls,
			min(svcdate) as dateafter format=date10.
		From
			temp.SampleRx1
		Where
			category="Maintenance"	and
			svcdate > &StartDate.-90
		Group by
			enrolid,
			thercls;

Create View work.trash3032 as
		Select distinct
			enrolid,
			thercls,
			max(svcdate) as datebefore format=date10.
		From
			temp.SampleRx1
		Where
			category="Maintenance"	and
			svcdate <= &StartDate.-90
		Group by
			enrolid,
			thercls;

Create View work.trash303 as
		Select
			a.enrolid,
			max((a.thercls^=b.thercls))			as	FlagNewChronicRx
		From
			work.trash3031 as a
		Left Join
			work.trash3032 as b
		On
			a.enrolid=b.enrolid and
			a.thercls=b.thercls
		Group by
			a.enrolid;

*** count of days supply in the past 90/180 days;
proc sql;
Create View work.trash304 as
		Select
			enrolid,
			sum(daysupp*(svcdate > &StartDate.-90)) 							as CountDaysSupp3m,
			sum(daysupp*(svcdate > &StartDate.-180))							as CountDaysSupp6m,
			sum(daysupp*(svcdate > &StartDate.-90) *(category="Maintenance")) 	as CountDaysSuppChronic3m,
			sum(daysupp*(svcdate > &StartDate.-180)*(category="Maintenance")) 	as CountDaysSuppChronic6m,
			sum(daysupp*(svcdate > &StartDate.-90) * max(thercls in (&OpiatesTCLS.),generid in (&OpiatesGNID.))) 	as CountDaysSuppOpiates3m,
			sum(daysupp*(svcdate > &StartDate.-180)* max(thercls in (&OpiatesTCLS.),generid in (&OpiatesGNID.))) 	as CountDaysSuppOpiates6m
		From
			temp.SampleRx1
		Group by
			enrolid;

*** count of unique all/maintenance(Chronic) therapeutic classes  in the past 90/180 days;
proc sql;
Create View work.trash305 as
		Select
			enrolid,
			count(distinct thercls)		as CountTherClass3m
		From
			temp.SampleRx1
		Where
			svcdate > &StartDate.-90
		Group by
			enrolid;

proc sql;
Create View work.trash306 as
		Select
			enrolid,
			count(distinct thercls)		as CountTherClass6m
		From
			temp.SampleRx1
		Where
			svcdate > &StartDate.-180
		Group by
			enrolid;

proc sql;
Create View work.trash307 as
		Select
			enrolid,
			count(distinct thercls)		as CountTherClassChronic3m
		From
			temp.SampleRx1
		Where
			svcdate > &StartDate.-90	and
			category="Maintenance"
		Group by
			enrolid;

proc sql;
Create View work.trash308 as
		Select
			enrolid,
			count(distinct thercls)		as CountTherClassChronic6m
		From
			temp.SampleRx1
		Where
			svcdate > &StartDate.-180	and
			category="Maintenance"
		Group by
			enrolid;

*** put all the drugs related variables together;
DATA
	work.trash311;
Merge
	trash302(in=a)
	trash303(in=b)
	trash304(in=c)
	trash305(in=d)
	trash306(in=e)
	trash307(in=f)
	trash308(in=g);
By 
	enrolid;
If
	a or b or c or d or e or f or g;
run;

*** Merge with the original Sample and use counts of zero when no admissions;
PROC SQL;
Create Table temp.Rx as
Select
	a.enrolid,
	max(0,b.FlagChronicRx)				as FlagChronicRx,
	max(0,b.FlagNewChronicRx)			as FlagNewChronicRx,
	max(0,b.CountDaysSupp3m)			as CountDaysSupp3m,
	max(0,b.CountDaysSupp6m)			as CountDaysSupp6m,
	max(0,b.CountDaysSuppChronic3m)		as CountDaysSuppChronic3m,
	max(0,b.CountDaysSuppChronic6m)		as CountDaysSuppChronic6m,
	max(0,b.CountDaysSuppOpiates3m)		as CountDaysSuppOpiates3m,
	max(0,b.CountDaysSuppOpiates6m)		as CountDaysSuppOpiates6m,
	max(0,b.CountTherClass3m)			as CountTherClass3m,
	max(0,b.CountTherClass6m)			as CountTherClass6m,
	max(0,b.CountTherClassChronic3m)	as CountTherClassChronic3m,
	max(0,b.CountTherClassChronic6m)	as CountTherClassChronic6m
From
	(Select distinct enrolid from temp.SamplewClassification) as a
Left Join
	work.trash311 as b
On
	a.enrolid=b.enrolid
Order by
	a.enrolid;


*** summarize the diagnosis from both OP+IP data ***;
****************************************************;

*** prepare the data for AE;
*** get all the inpatient and outpatient data from the matched IDs and the variables needed to run DS in Analytics Engine;
PROC SQL;
Create Table trash401 as select 
	a.enrolid 														as patient_id,
	'F' 															as fac_prof,
	'I'||strip(put(a.seqnum,15.)) 									as record_identifier,
	a.age 															as age,
	case a.sex when '1' then 'M' when '2' then 'F' else ' ' end 	as sex,
	a.proc1 														as icd_proc1,
	'9' 															as icd_flag,
	a.dx1 															as dx1,
	a.dx2 															as dx2,
	a.dx3 															as dx3,
	a.dx4 															as dx4,
	'I' 															as rec_type,
	' ' 															as std_place,
	admtyp															as custom1,
	svcscat 														as custom2,
	svcdate															as custom3
From 
	arch&year..ccaes&MSversion.			as a,
	temp.SamplewClassification	as b
Where
	a.enrolid=b.enrolid
Order by
	patient_id,
	record_identifier;
;

Create Table trash402 as select 
	a.enrolid 														as patient_id,
	a.facprof														as fac_prof,
	'O'||strip(put(a.seqnum,15.)) 									as record_identifier,
	a.age 															as age,
	case a.sex when '1' then 'M' when '2' then 'F' else ' ' end 	as sex,
	a.proc1 														as icd_proc1,
	'9' 															as icd_flag,
	a.dx1 															as dx1,
	a.dx2 															as dx2,
	a.dx3 															as dx3,
	a.dx4 															as dx4,
	'O' 															as rec_type,
	' ' 															as std_place,
	' '																as custom1,
	svcscat 														as custom2,
	svcdate															as custom3
From 
	arch&year..ccaeo&MSversion.			as a,
	temp.SamplewClassification	as b
Where
	a.enrolid=b.enrolid
Order by
	patient_id,
	record_identifier;
;

*** put together inp and outpatient data and sort and dedup (for DS we need unique patient/eventIDs;
data temp.IPandOPforAE; set trash401 trash402; by patient_id record_identifier; run;
proc sort data=temp.IPandOPforAE nodupkey; by patient_id record_identifier; run;

*** export data into csv;
proc export 
	data=temp.IPandOPforAE 
	outfile="&AEoutpath./&version..csv" 
	replace;
run;

*** setup the Configfile.properties for AE;
filename AEconfig "&AEoutpath./popclass_prototype_rerun_config.txt";
data _null_;
file AEconfig;
put "-m:DiseaseStaging";
put "-f:/applications/analyticsengine/8_2_0/u071439/&version..csv";
put "-o:/applications/analyticsengine/8_2_0/u071439/";
run;
