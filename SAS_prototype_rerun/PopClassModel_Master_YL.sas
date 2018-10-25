
/*** connect to the nike server - trvlapp1465.tsh.thomson.com ***/

%include '/opt/SAS94/SASFoundation/9.4/autoexec.sas';

Options obs=max mprint mlogic;

%Let Prevyear=2013;
%Let     year=2014;
%Let Nextyear=2015;
%Let MSversionPrev=133;
%Let MSversion    =143;
%Let MSversionNext=152;
%Let StartDate='31DEC2014'd; /* always choose the end of month */
%let version=31DEC2014_10242018;
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


* Beginning of Ujwal's modification;
* Import a list of 2000 enrolid;
PROC IMPORT
    DATAFILE='/rpscan/u071439/data/enrolids_2000.csv'
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
	hlo='O';							/* for DxCats that are not in the map from Janet, just map them to '99'-Other */
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

