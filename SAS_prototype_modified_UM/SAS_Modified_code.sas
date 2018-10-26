/*** connect to the nike server - trvlapp1465.tsh.thomson.com ***
rsubmit;
*/

%include '/opt/SAS94/SASFoundation/9.4/autoexec.sas';

Options obs=max mprint;

*** Modified ;
%Let StartDate='31DEC2015'd; /* always choose the end of month */

*** Modified ;
%let version=31DEC2015MarketScanSample;

*** Modified ;
%Let AEoutpath=/rpscan/u071366/POPSTRATIFICATION/AEout/&version.;
%Let outpath=/rpscan/u071366/POPSTRATIFICATION/output/&version.;
%Let username=u071366;

*** Modified ;
x "mkdir -p /rpscan/u071366/POPSTRATIFICATION/temp/&version.";
x "mkdir -p /rpscan/u071366/POPSTRATIFICATION/AEout/&version.";
x "mkdir -p /rpscan/u071366/POPSTRATIFICATION/output/&version.";

*** Modified ;
libname temp "/rpscan/u071366/POPSTRATIFICATION/temp/&version.";

*** Modified ;
PROC IMPORT
	DATAFILE="/rpscan/u071366/enrolids_2000.csv"
	OUT= enrolids
	DBMS=CSV
	REPLACE;
GETNAMES=YES;
GUESSINGROWS=MAX;
RUN;

*** Modified ;
data  ccaea;
    infile '/rpscan/u071366/fedex_data_2015/ccaea.csv' delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;

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
		'PLNTYP12'n
		;

run;

*** Modified ;
data  ccaei;
    infile '/rpscan/u071366/fedex_data_2015/ccaei.csv' delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;

    informat 'ENROLID'n BEST32.;
    informat 'PDXCAT'n $5.;
    informat 'ADMDATE'n MMDDYY10.;
    informat 'DISDATE'n MMDDYY10.;
    informat 'DRG'n BEST32.;
    informat 'ADMTYP'n $1.;
    informat 'TOTPAY'n BEST32.;
    informat 'DSTATUS'n $2.;
    format 'ENROLID'n BEST12.;
    format 'PDXCAT'n $5.;
    format 'ADMDATE'n MMDDYY10.;
    format 'DISDATE'n MMDDYY10.;
    format 'DRG'n BEST12.;
    format 'ADMTYP'n $1.;
    format 'TOTPAY'n BEST12.;
    format 'DSTATUS'n $2.;
    label 'ENROLID'n = 'ENROLID';
    label 'PDXCAT'n = 'PDXCAT';
    label 'ADMDATE'n = 'ADMDATE';
    label 'DISDATE'n = 'DISDATE';
    label 'DRG'n = 'DRG';
    label 'ADMTYP'n = 'ADMTYP';
    label 'TOTPAY'n = 'TOTPAY';
    label 'DSTATUS'n = 'DSTATUS';
    input    'ENROLID'n
        'PDXCAT'n $
        'ADMDATE'n
        'DISDATE'n
        'DRG'n
        'ADMTYP'n $
        'TOTPAY'n
        'DSTATUS'n $
        ;
run;

*** Modified ;
data  ccaed;
    infile '/rpscan/u071366/fedex_data_2015/ccaed.csv' delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
	informat 'ENROLID'n BEST32.;
	informat 'SVCDATE'n MMDDYY10.;
	informat 'DAYSUPP'n BEST32.;
	informat 'NDCNUM'n $11.;
	informat 'GENERID'n BEST32.;
	informat 'THERCLS'n BEST32.;
	informat 'PAY'n BEST32.;
	format 'ENROLID'n BEST12.;
	format 'SVCDATE'n MMDDYY10.;
	format 'DAYSUPP'n BEST12.;
	format 'NDCNUM'n $11.;
	format 'GENERID'n BEST12.;
	format 'THERCLS'n BEST12.;
	format 'PAY'n BEST12.;
	label 'ENROLID'n = 'ENROLID';
	label 'SVCDATE'n = 'SVCDATE';
	label 'DAYSUPP'n = 'DAYSUPP';
	label 'NDCNUM'n = 'NDCNUM';
	label 'GENERID'n = 'GENERID';
	label 'THERCLS'n = 'THERCLS';
	label 'PAY'n = 'PAY';
	input    'ENROLID'n
	'SVCDATE'n
	'DAYSUPP'n
	'NDCNUM'n $
	'GENERID'n
	'THERCLS'n
	'PAY'n
	;
run;

*** Modified ;
data  ccaes;
    infile '/rpscan/u071366/fedex_data_2015/ccaes.csv' delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
	informat 'ENROLID'n BEST32.;
	informat 'SEQNUM'n BEST32.;
	informat 'AGE'n BEST32.;
	informat 'SEX'n $1.;
	informat 'PROC1'n $7.;
	informat 'DXVER'n $1.;
	informat 'DX1'n $7.;
	informat 'DX2'n $7.;
	informat 'DX3'n $7.;
	informat 'DX4'n $7.;
	informat 'ADMTYP'n $1.;
	informat 'SVCSCAT'n $5.;
	informat 'SVCDATE'n MMDDYY10.;
	format 'ENROLID'n BEST12.;
	format 'SEQNUM'n BEST12.;
	format 'AGE'n BEST12.;
	format 'SEX'n $1.;
	format 'PROC1'n $7.;
	format 'DXVER'n $1.;
	format 'DX1'n $7.;
	format 'DX2'n $7.;
	format 'DX3'n $7.;
	format 'DX4'n $7.;
	format 'ADMTYP'n $1.;
	format 'SVCSCAT'n $5.;
	format 'SVCDATE'n MMDDYY10.;
	label 'ENROLID'n = 'ENROLID';
	label 'SEQNUM'n = 'SEQNUM';
	label 'AGE'n = 'AGE';
	label 'SEX'n = 'SEX';
	label 'PROC1'n = 'PROC1';
	label 'DXVER'n = 'DXVER';
	label 'DX1'n = 'DX1';
	label 'DX2'n = 'DX2';
	label 'DX3'n = 'DX3';
	label 'DX4'n = 'DX4';
	label 'ADMTYP'n = $1.;
	label 'SVCSCAT'n = $5.;
	label 'SVCDATE'n = 'SVCDATE';
	input    'ENROLID'n
		'SEQNUM'n
		'AGE'n
		'SEX'n $
		'PROC1'n $
		'DXVER'n
		'DX1'n $
		'DX2'n $
		'DX3'n $
		'DX4'n $
		'ADMTYP'n $
		'SVCSCAT'n $
		'SVCDATE'n
		;
run;

*** Modified ;
data  ccaeo;
    infile '/rpscan/u071366/fedex_data_2015/ccaeo.csv' delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
	informat 'ENROLID'n BEST32.;
	informat 'FACPROF'n $1.;
	informat 'SEQNUM'n BEST32.;
	informat 'AGE'n BEST32.;
	informat 'SEX'n $1.;
	informat 'PROC1'n $7.;
	informat 'DX1'n $7.;
	informat 'DX2'n $7.;
	informat 'DX3'n $7.;
	informat 'DX4'n $7.;
	informat 'DXVER'n $1.;
	informat 'SVCSCAT'n $5.;
	informat 'SVCDATE'n MMDDYY10.;
	informat 'MSCLMID'n BEST32.;
	informat 'FACHDID'n BEST32.;
	informat 'PROCGRP'n BEST32.;
	informat 'DXCAT'n $5.;
	informat 'STDPROV'n BEST32.;
	informat 'PAY'n BEST32.;
	format 'ENROLID'n BEST12.;
	format 'FACPROF'n $1.;
	format 'SEQNUM'n BEST12.;
	format 'AGE'n BEST12.;
	format 'SEX'n $1.;
	format 'PROC1'n $7.;
	format 'DX1'n $7.;
	format 'DX2'n $7.;
	format 'DX3'n $7.;
	format 'DX4'n $7.;
	format 'DXVER'n $1.;
	format 'SVCSCAT'n $5.;
	format 'SVCDATE'n MMDDYY10.;
	format 'MSCLMID'n BEST12.;
	format 'FACHDID'n BEST12.;
	format 'PROCGRP'n BEST12.;
	format 'DXCAT'n $5.;
	format 'STDPROV'n BEST12.;
	format 'PAY'n BEST12.;
	label 'ENROLID'n = 'ENROLID';
	label 'FACPROF'n = 'FACPROF';
	label 'SEQNUM'n = 'SEQNUM';
	label 'AGE'n = 'AGE';
	label 'SEX'n = 'SEX';
	label 'PROC1'n = 'PROC1';
	label 'DX1'n = 'DX1';
	label 'DX2'n = 'DX2';
	label 'DX3'n = 'DX3';
	label 'DX4'n = 'DX4';
	label 'DXVER'n = 'DXVER';
	label 'SVCSCAT'n = 'SVCSCAT';
	label 'SVCDATE'n = 'SVCDATE';
	label 'MSCLMID'n = 'MSCLMID';
	label 'FACHDID'n = 'FACHDID';
	label 'PROCGRP'n = 'PROCGRP';
	label 'DXCAT'n = 'DXCAT';
	label 'STDPROV'n = 'STDPROV';
	label 'PAY'n = 'PAY';
	input    'ENROLID'n
		'FACPROF'n $
		'SEQNUM'n
		'AGE'n
		'SEX'n $
		'PROC1'n $
		'DX1'n $
		'DX2'n $
		'DX3'n $
		'DX4'n $
		'DXVER'n $
		'SVCSCAT'n $
		'SVCDATE'n
		'MSCLMID'n
		'FACHDID'n
		'PROCGRP'n
		'DXCAT'n $
		'STDPROV'n
		'PAY'n
		;
run;

*** Modified ;
data  ccaef;
    infile '/rpscan/u071366/fedex_data_2015/ccaef.csv' delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;
	informat 'ENROLID'n BEST32.;
	informat 'SVCDATE'n MMDDYY10.;
	informat 'TSVCDAT'n MMDDYY10.;
	informat 'DAYS'n BEST32.;
	informat 'FACHDID'n BEST32.;
	informat 'CASEID'n BEST32.;
	format 'ENROLID'n BEST12.;
	format 'SVCDATE'n MMDDYY10.;
	format 'TSVCDAT'n MMDDYY10.;
	format 'DAYS'n BEST12.;
	format 'FACHDID'n BEST12.;
	format 'CASEID'n BEST12.;
	label 'ENROLID'n = 'ENROLID';
	label 'SVCDATE'n = 'SVCDATE';
	label 'TSVCDAT'n = 'TSVCDAT';
	label 'DAYS'n = 'DAYS';
	label 'FACHDID'n = 'FACHDID';
	label 'CASEID'n = 'CASEID';
	input    'ENROLID'n
	'SVCDATE'n
	'TSVCDAT'n
	'DAYS'n
	'FACHDID'n
	'CASEID'n
	;
run;



*** Modified ;
%Let lastmonth=%sysfunc(month(&StartDate.),2.);
proc sql; 
Create Table temp.SamplewClassification as select a.enrolid,
	' ' as AssignmentFinal
from ccaea a
inner join enrolids e  On e.enrolid = a.enrolid
where a.enrind&lastmonth.=1;
quit;


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

*** Modified ;
*** %let ConditionProcGRP='0090','0095','2370','1045','4580','4585';
%let ConditionProcGRP=0090,0095,2370,1045,4580,4585; /* converted it to numeric */

*** NeoNates;
%let NeonatesDRGList=790,791,792,793,794,795;

*** importing the MetaData;
%macro ImportMeta(inputdata,sasoutput);
PROC IMPORT 
	datafile="/rpscan/u0086308/POPSTRATIFICATION/data/&inputdata."
	out=temp.&sasoutput.
	replace;
getnames=YES;
guessingrows=MAX;
run;
%mend ImportMeta;



*** Modified ;
*** sample of 100 patients with classification;
*** %ImportMeta(AllClientSample&version..csv,SamplewClassification); /* skip this if we create directly the sample file in SAS */

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


*** Modified ;
*** Import the list of PROCGRP for specific active cancer for Surveillance logic;
*** %ImportMeta(JanetMetadata_SurveillanceSpecificActiveCancer.csv,SurvSpecificActiveCancer);
*** line 144 - Q2043;
data  temp.SurvSpecificActiveCancer;
    infile '/rpscan/u071366/JanetMetadata_SurveillanceSpecificActiveCancer.csv' delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;

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
		'stage'n
		;
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

*** Modified ;
*** Import the list of DxCat for Rebalance, new ICD9;
*** %ImportMeta(JanetMetadata_RebalanceNewDx.csv,RebalanceNewDx);
data  temp.RebalanceNewDx;
    infile '/rpscan/u0086308/POPSTRATIFICATION/data/JanetMetadata_RebalanceNewDx.csv' delimiter=',' MISSOVER DSD firstobs=2 LRECL=32760;

	informat 'ICD'n $4.;
	informat 'Description'n $13.;
	format 'ICD'n $4.;
	format 'Description'n $13.;
	label 'ICD'n = 'ICD';
	label 'Description'n = 'Description';
	input    'ICD'n $
		'Description'n $
		;
run;


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

*** Modified ;
*** creating a format for list of ProcGRP (based on Px conditions) for Surveillance - Active Cancer definition;
data trash(keep=start label fmtname); 
set temp.SurvGeneralActiveCancerPROCGRP end=end;
start=PROCGRP;
label='Y';
*** fmtname='$SurvActiveCancerPROCGRP';
fmtname='SurvActiveCancerPROCGRP';
run;
proc format cntlin=trash; run;


*** summarize the inpatient data ***;
************************************;

*** Modified ;
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
	ccaei as a,
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
Create table work.trash202 as
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
Create table work.trash203 as
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
Create table work.trash204 as
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
Create table work.trash205 as
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
Create table work.trash206 as
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
Create table work.trash207 as
		Select
			enrolid,
			&StartDate. - max(admdate) as DaysAnyAdm
		From
			temp.SampleInp1
		Group By
			enrolid;

*** Days to the last chronic admission(admdate) in the past year;
Create table work.trash208 as
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
Create table work.trash209 as
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
Create table work.trash210 as
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
Create table work.trash211 as
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
Create table work.trash212 as
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

*** Modified ;
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
	ccaed as a,
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


*** PROC PRINT DATA=temp.Rx(OBS=40);RUN;

*** summarize the diagnosis from both OP+IP data ***;
****************************************************;

*** Modified ;
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
	ccaes as a,
	temp.SamplewClassification	as b
Where
	a.enrolid=b.enrolid
Order by
	patient_id,
	record_identifier;
;

*** Modified ;
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
	ccaeo as a,
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
filename AEconfig "&AEoutpath./Configfile.properties";
data _null_;
file AEconfig;
put "-m:DiseaseStaging";
put "-f:&AEoutpath./&version..csv";
put "-o:&AEoutpath.";
run;


/* import AE back into the data */
data temp.SampleIPOPwDS1;
	infile "&AEoutpath./&username._DISEASESTAGING6.34_&version._Dsoutput.csv"
	delimiter = ',' 
	MISSOVER 
	DSD 
	lrecl=32767
	firstobs=2;
input
                  enrolid
                  fac_prof :$1.
                  eventid :$16.
                  age
                  sex :$1.
                  proc1 :$7.
                  icd_flag :$1.
                  dx1 :$7.
                  dx2 :$7.
                  dx3 :$7.
                  dx4 :$7.
                  rec_type :$1.
                  std_place :$1.
				  admtyp :$1.
				  svcscat :$5.
				  svcdate :mmddyy10.
                  dxcat1 :$5.
                  dxcat2 :$5.
                  dxcat3 :$5.
                  dxcat4 :$5.
                  dxstage1
                  dxstage2
                  dxstage3
                  dxstage4
;
format svcdate mmddyy10.; 
run;


*** flag the patients with MHSA and maternity history;
proc sql;
create view trash501 as select
	enrolid,
	max(
				(admtyp='4'	 				or 
				dxcat1 in (&SvcCatMHSA.)	or
				dxcat2 in (&SvcCatMHSA.)	or
				dxcat3 in (&SvcCatMHSA.)	or
				dxcat4 in (&SvcCatMHSA.))
		)												as flag12mMHSA,
	max(		
				(svcdate > &StartDate.-90)		and
				(dxcat1 in (&SvcCatGYN.)	or
				 dxcat2 in (&SvcCatGYN.)	or
				 dxcat3 in (&SvcCatGYN.)	or
				 dxcat4 in (&SvcCatGYN.))
		)												as flag3mGYN
from
	temp.SampleIPOPwDS1
group by
	enrolid;

*** create the flags for all the DxCats that satisfy the conditions for Acute/Chrnic/Stage>3/HighSignificance;
data trash502(keep=
				enrolid 
				svcdate flag3mStage3
				dxcat flag3mAcuteStage3 flag3mChronicStage3 flag6mChronicStage3 flag3mAcuteSign flag3mChronicSign flag6mChronicSign flag12mChronicSign flag3mAcute flag6mAcute flag3mChronic flag12mChronic
				body flag3mBody flag3mBodySign
				flagNew3mChronicSign flagNew12mChronicSign);
set temp.SampleIPOPwDS1;
length dxcat $5. body $2.;
array dxarray dxcat1-dxcat4;
array dxstage dxstage1-dxstage4;
	do i=1 to 4;
		dxcat=' '; body=' ';
/* flags for days with Stage3 */
		if svcdate > &StartDate.-90  and dxstage[i] ge 3 and
			^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.))) 
		then do; dxcat=dxarray[i]; flag3mStage3=1;   end;
/* flags for DxCat counts */
		if svcdate > &StartDate.-90  and put(dxarray[i],$DxCatAssign.)='Acute' and dxstage[i] ge 3 and
			^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.))) 
		then do; dxcat=dxarray[i]; flag3mAcuteStage3=1; end;
		if svcdate > &StartDate.-90  and put(dxarray[i],$DxCatAssign.)='Chronic' and dxstage[i] ge 3 and
		   	^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flag3mChronicStage3=1; end;
		if svcdate > &StartDate.-180 and put(dxarray[i],$DxCatAssign.)='Chronic' and dxstage[i] ge 3 and
		   	^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flag6mChronicStage3=1; end;
		if svcdate > &StartDate.-90  and put(dxarray[i],$DxCatAssign.)='Acute'   and put(dxarray[i],$DxCatHigh.)='High' and 
			^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flag3mAcuteSign=1;   end;
		if svcdate > &StartDate.-90  and put(dxarray[i],$DxCatAssign.)='Chronic' and put(dxarray[i],$DxCatHigh.)='High' and
			^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flag3mChronicSign=1; end;
		if svcdate > &StartDate.-180 and put(dxarray[i],$DxCatAssign.)='Chronic' and put(dxarray[i],$DxCatHigh.)='High' and 
			^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flag6mChronicSign=1; end;
		if svcdate > &StartDate.-366 and put(dxarray[i],$DxCatAssign.)='Chronic' and put(dxarray[i],$DxCatHigh.)='High' and 
			^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flag12mChronicSign=1; end;
		if svcdate > &StartDate.-90  and put(dxarray[i],$DxCatAssign.)='Acute' and
			^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flag3mAcute=1;   end;
		if svcdate > &StartDate.-180 and put(dxarray[i],$DxCatAssign.)='Acute'  and
			^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flag6mAcute=1;   end;
		if svcdate > &StartDate.-90  and put(dxarray[i],$DxCatAssign.)='Chronic' and 
			^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flag3mChronic=1; end;
		if svcdate > &StartDate.-366 and put(dxarray[i],$DxCatAssign.)='Chronic' and
			^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flag12mChronic=1; end;
/* flags for body counts */
		if svcdate > &StartDate.-90 and missing(dxarray[i])=0 				then do; body=put(dxarray[i],$DxCatBody.); flag3mBody=1; dxcat=dxarray[i]; end;
		if svcdate > &StartDate.-90 and put(dxarray[i],$DxCatHigh.)='High' 	then do; body=put(dxarray[i],$DxCatBody.); flag3mBodySign=1; end;
/* flags for new chronic significant condition */
		if svcdate > &StartDate.-90  and put(dxarray[i],$DxCatAssign.)='Chronic' and put(dxarray[i],$DxCatHigh.)='High' and 
		   ^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flagNew3mChronicSign=1; end;
		if &StartDate.-366 < svcdate <= &StartDate.-90  and put(dxarray[i],$DxCatAssign.)='Chronic' and put(dxarray[i],$DxCatHigh.)='High' and 
		   ^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do; dxcat=dxarray[i]; flagNew12mChronicSign=1; end;
		if missing(dxcat)=0 or missing(body)=0 then output;
	end;
run;

*** count the unique DxCats for different combinations of Acute/Chronic/Sign/3m/6m/each, it's using the flags defined in the previous step;
proc sql;
create view trash503 as select
	enrolid,
	count(distinct dxcat) as Count3mAcuteStage3
from trash502
where flag3mAcuteStage3=1
group by enrolid;

create view trash504 as select
	enrolid,
	count(distinct dxcat) as Count3mChronicStage3
from trash502
where flag3mChronicStage3=1
group by enrolid;

create view trash505 as select
	enrolid,
	count(distinct dxcat) as Count6mChronicStage3
from trash502
where flag6mChronicStage3=1
group by enrolid;

create view trash506 as select
	enrolid,
	count(distinct dxcat) as Count3mAcuteSign
from trash502
where flag3mAcuteSign=1
group by enrolid;

create view trash507 as select
	enrolid,
	count(distinct dxcat) as Count3mChronicSign
from trash502
where flag3mChronicSign=1
group by enrolid;

create view trash508 as select
	enrolid,
	count(distinct dxcat) as Count6mChronicSign
from trash502
where flag6mChronicSign=1
group by enrolid;

create view trash508_1 as select
	enrolid,
	count(distinct dxcat) as Count12mChronicSign
from trash502
where flag12mChronicSign=1
group by enrolid;

create view trash509 as select
	enrolid,
	count(distinct dxcat) as Count3mAcute
from trash502
where flag3mAcute=1
group by enrolid;

create view trash510 as select
	enrolid,
	count(distinct dxcat) as Count6mAcute
from trash502
where flag6mAcute=1
group by enrolid;

create view trash511 as select
	enrolid,
	count(distinct dxcat) as Count3mChronic
from trash502
where flag3mChronic=1
group by enrolid;

create view trash512 as select
	enrolid,
	count(distinct dxcat) as Count12mChronic
from trash502
where flag12mChronic=1
group by enrolid;

*** count the unique Body systems;
create view trash513 as select
	enrolid,
	count(distinct body) as Count3mBody
from trash502
where flag3mBody=1
group by enrolid;

create view trash514 as select
	enrolid,
	count(distinct body) as Count3mBodySign
from trash502
where flag3mBodySign=1
group by enrolid;

*** create flag for new significant chronic condition;
proc sql;
create view trash515 as select distinct
	a.enrolid,
	1 as flag3mNewChronicSign
from 
	trash502(where=(flagNew3mChronicSign=1)) as a
left join
	trash502(where=(flagNew12mChronicSign=1)) as b
on
	a.enrolid=b.enrolid and a.dxcat=b.dxcat
where 
	a.dxcat ne b.dxcat;

*** create flag for number of days with Stage3 within last 3m; 
proc sql;
create view trash516 as select
	enrolid,
	count(distinct svcdate) as Days3mStage3
from trash502
where flag3mStage3=1
group by enrolid;

*** put all the DxCat related variables from IP and OP claims together;
DATA
	trash531;
Merge
	trash501(in=a)
	trash503(in=b)
	trash504(in=c)
	trash505(in=d)
	trash506(in=e)
	trash507(in=f)
	trash508(in=g)
	trash508_1(in=g_1)
	trash509(in=h)
	trash510(in=i)
	trash511(in=j)
	trash512(in=k)
	trash513(in=l)
	trash514(in=m)
	trash515(in=n)
	trash516(in=o);
By 
	enrolid;
If
	a or b or c or d or e or f or g or g_1 or h or i or j or k or l or m or n or o;
run;

*** Merge with the original Sample and use counts of zero when no admissions;
PROC SQL;
Create Table temp.IPandOP as
Select
	a.enrolid,
	max(0,b.flag12mMHSA) as flag12mMHSA,
	max(0,b.flag3mGYN) as flag3mGYN,
	max(0,b.Count3mAcuteStage3) as Count3mAcuteStage3,
	max(0,b.Count3mChronicStage3) as Count3mChronicStage3,
	max(0,b.Count6mChronicStage3) as Count6mChronicStage3,
	max(0,b.Count3mAcuteSign) as Count3mAcuteSign,
	max(0,b.Count3mChronicSign) as Count3mChronicSign,
	max(0,b.Count6mChronicSign) as Count6mChronicSign,
	max(0,b.Count12mChronicSign) as Count12mChronicSign,
	max(0,b.Count3mAcute) as Count3mAcute,
	max(0,b.Count6mAcute) as Count6mAcute,
	max(0,b.Count3mChronic) as Count3mChronic,
	max(0,b.Count12mChronic) as Count12mChronic,
	max(0,b.Count3mBody) as Count3mBody,
	max(0,b.Count3mBodySign) as Count3mBodySign,
	max(0,b.flag3mNewChronicSign) as flag3mNewChronicSign,
	max(0,b.Days3mStage3) as Days3mStage3
From
	(Select distinct enrolid from temp.SamplewClassification) as a
Left Join
	work.trash531 as b
On
	a.enrolid=b.enrolid
Order by
	a.enrolid;
quit;





*** summarize the outpatient data ***;
************************************;

*** Modified ;
PROC SQL;
*** get all the outpatient data from the matched IDs;
Create View trash001 as select distinct
	a.enrolid,
	a.msclmid,
	a.facprof,
	a.fachdid,
	a.proc1,
	a.procgrp,
	a.dxcat,
	a.svcscat,
	a.stdprov,
	a.svcdate,
	a.pay
from 
	ccaeo as a,
	temp.SamplewClassification	as b	
where
	a.enrolid=b.enrolid
order by
	a.enrolid,
	a.svcdate;

*** map the principal DxCat from the outpatient claim to chronic/acute; 
Create View trash002 as select
	a.*,
	b.category
from
	trash001					as a
left join
	temp.GeneralAssignments		as b
on
	a.dxcat=b.dxcat;

*** link to ATG from OPEG Lookup;
Create View trash003 as select
	a.*,
	b.ATG
from
	trash002 		as a
left join
	temp.OPEGLookup		as b
on
	a.proc1=b.hcpcs;

*** link to Significant Conditions based on ProcGrp map;
Create View trash004 as select
	a.*,
	b.Significance
from
	trash003 		as a
left join
	temp.SignificantConditions		as b
on
	a.dxcat=b.dxcat;

*** link to facility header table to get the inpatient flag based on CASEID being present;
Create Table temp.SampleOtp1 as select distinct
	a.*,
	b.caseid
from
	trash004			as a
left join
	ccaef as b
on
	a.enrolid=b.enrolid and
	a.fachdid=b.fachdid;
Quit;


/*** check some counts of patients/claims in the data selected above;
proc sql;
select count (distinct enrolid) from temp.SampleOtp1;
select enrolid format=15.0, count(distinct svcdate) as count_claims from temp.SampleOtp1 group by enrolid;
quit;*/

PROC SQL;
*** counting 3/12 months office visits to any provider for any conditions by service date;
Create View work.trash001_1 as
select
	enrolid,
	count(distinct msclmid) as Count3mOV
from 
	temp.SampleOtp1 
where
	svcdate > &StartDate. - 90							and		/*3 months*/
	substr(svcscat,4,2)="25"							and		/*office visits*/
	^(proc1 in (&ProcExclusionList.))							/*exclusion based on procedures*/
group by
	enrolid
;
Create View work.trash001_2 as
select
	enrolid,
	count(distinct msclmid) as Count12mOV
from 
	temp.SampleOtp1 
where
	svcdate > &StartDate. - 366							and		/*12 months*/
	substr(svcscat,4,2)="25"							and		/*office visits*/
	^(proc1 in (&ProcExclusionList.))							/*exclusion based on procedures*/
group by
	enrolid
;

*** counting 3/6 months office visits to any provider for Chronic conditions by service date;
Create View work.trash002_1 as
select
	enrolid,
	count(distinct msclmid) as Count3mOVChronic
from 
	temp.SampleOtp1 
where
	category='Chronic'									and		/*Chronic*/
	svcdate > &StartDate. - 90 							and		/*3 months*/
	substr(svcscat,4,2)="25"							and		/*office visits*/
	^(proc1 in (&ProcExclusionList.))							/*exclusion based on procedures*/
group by
	enrolid
;
Create View work.trash002_2 as
select
	enrolid,
	count(distinct msclmid) as Count6mOVChronic
from 
	temp.SampleOtp1 
where
	category='Chronic'									and		/*Chronic*/
	svcdate > &StartDate. - 180							and		/*6 months*/
	substr(svcscat,4,2)="25"							and		/*office visits*/
	^(proc1 in (&ProcExclusionList.))							/*exclusion based on procedures*/
group by
	enrolid
;

*** counting 3/6 months office visits to specialists for Chronic conditions by service date;
Create View work.trash003_1 as
select
	enrolid,
	count(distinct msclmid) as Count3mOVChronicSpecialist
from 
	temp.SampleOtp1 
where
	category='Chronic'							and		/*Chronic*/
	svcdate > &StartDate. - 90 					and		/*3 months*/
	substr(svcscat,4,2)="25"					and		/*office visits*/
	stdprov between 100 and 799					and		/*specialists*/
	^(stdprov in (&SpecExclusionList.))			and		/*exclusions from specialists*/
	^(proc1 in (&ProcExclusionList.))					/*exclusion based on procedures*/
group by
	enrolid
;
Create View work.trash003_2 as
select
	enrolid,
	count(distinct msclmid) as Count6mOVChronicSpecialist
from 
	temp.SampleOtp1 
where
	category='Chronic'							and		/*Chronic*/
	svcdate > &StartDate. - 180 				and		/*6 months*/
	substr(svcscat,4,2)="25"					and		/*office visits*/
	stdprov between 100 and 799					and		/*specialists*/
	^(stdprov in (&SpecExclusionList))			and		/*exclusions from specialists*/
	^(proc1 in (&ProcExclusionList.))					/*exclusion based on procedures*/
group by
	enrolid
;

*** counting 3 months unique specialties for office visits;
Create View work.trash004 as
select
	enrolid,
	count(distinct stdprov) as Count3mOVSpecialties
from 
	temp.SampleOtp1 
where
	svcdate > &StartDate. - 90					and		/*3 months*/
	stdprov between 100 and 799					and		/*specialists*/
	^(stdprov in (&SpecExclusionList))			and		/*exclusions from specialists*/
	^(proc1 in (&ProcExclusionList.))			and		/*exclusion based on procedures*/
	substr(svcscat,4,2)="25"							/*office visits*/
group by
	enrolid
;

*** counting 3 months unique specialties for office visits Chronic;
Create View work.trash005 as
select
	enrolid,
	count(distinct stdprov) as Count3mOVChronicSpecialties
from 
	temp.SampleOtp1 
where
	svcdate > &StartDate. - 90					and		/*3 months*/
	stdprov between 100 and 799					and		/*specialists*/
	^(stdprov in (&SpecExclusionList))			and		/*exclusions from specialists*/
	^(proc1 in (&ProcExclusionList.))			and		/*exclusion based on procedures*/
	substr(svcscat,4,2)="25"					and		/*office visits*/
	category='Chronic'									/*Chronic*/
group by
	enrolid
;

*** counting 3/6 months ER visits for any conditions by claim id;
Create View work.trash006_1 as
select
	enrolid,
	count(distinct msclmid) as Count3mER
from 
	temp.SampleOtp1 
where
	svcdate > &StartDate. - 90					and		/*3 months*/
	facprof='F'									and		/*Facility claim*/
	substr(svcscat,4,2)="20"					and		/*ER visits*/
	missing(caseid)=1							and 	/*no inpatient*/
	^(proc1 in (&ProcExclusionList.))					/*exclusion based on procedures*/
group by
	enrolid
;

Create View work.trash006_2 as
select
	enrolid,
	count(distinct msclmid) as Count12mER
from 
	temp.SampleOtp1 
where
	svcdate > &StartDate. - 366					and		/*12 months*/
	facprof='F'									and		/*Facility claim*/
	substr(svcscat,4,2)="20"					and		/*ER visits*/
	missing(caseid)=1							and 	/*no inpatient*/
	^(proc1 in (&ProcExclusionList.))					/*exclusion based on procedures*/
group by
	enrolid
;

*** counting 3/6 months ER visits for Chronic conditions by claim id;
Create View work.trash007_1 as
select
	enrolid,
	count(distinct msclmid) as Count3mERChronic
from 
	temp.SampleOtp1 
where
	category='Chronic'							and		/*Chronic*/
	svcdate > &StartDate. - 90					and		/*3 months*/
	facprof='F'									and		/*Facility claim*/
	substr(svcscat,4,2)="20"					and		/*ER visits*/
	missing(caseid)=1							and 	/*no inpatient*/
	^(proc1 in (&ProcExclusionList.))					/*exclusion based on procedures*/
group by
	enrolid
;

Create View work.trash007_2 as
select
	enrolid,
	count(distinct msclmid) as Count6mERChronic
from 
	temp.SampleOtp1 
where
	category='Chronic'							and		/*Chronic*/
	svcdate > &StartDate. - 180					and		/*6 months*/
	facprof='F'									and		/*Facility claim*/
	substr(svcscat,4,2)="20"					and		/*ER visits*/
	missing(caseid)=1							and 	/*no inpatient*/
	^(proc1 in (&ProcExclusionList.))					/*exclusion based on procedures*/
group by
	enrolid
;

*** days since any ER;
Create View work.trash008 as
select
	enrolid,
	&StartDate.-max(svcdate) 	as DaysER
from 
	temp.SampleOtp1 
where
	facprof='F'									and		/*Facility claim*/
	substr(svcscat,4,2)="20"					and		/*ER visits*/
	missing(caseid)=1							and 	/*no inpatient*/
	^(proc1 in (&ProcExclusionList.))					/*exclusion based on procedures*/
group by
	enrolid
;

*** days since Major ER;
*** from DS output transpose the dxcat and stage, one per row and dedup, so that can be merged into OP data;
data work.trash0091(keep=enrolid svcdate dxcat dxstage);
set temp.SampleIPOPwDS1;
array listcat[4] dxcat1-dxcat4;
array liststage[4] dxstage1-dxstage4;
do i=1 to 4; 
	dxcat=listcat[i];
	dxstage=liststage[i];
	if dxstage >= 3 then output;
end;
run;
proc sort data=work.trash0091 nodupkey; by enrolid svcdate dxcat; run;
*** Merge the Stage from DS;
proc sql;
Create View work.trash0092 as 
Select
	a.*,
	b.dxstage
From
	temp.SampleOtp1 as a
Left Join
	work.trash0091 as b
On
	a.enrolid=b.enrolid and
	a.svcdate=b.svcdate and
	a.dxcat=b.dxcat;
*** count the days using all the criteria including DS stage;
Create View work.trash009 as 
Select
	enrolid,
	&StartDate.-max(svcdate) 	as DaysMajorER
from 
	work.trash0092
where
	facprof='F'									and		/*Facility claim*/
	substr(svcscat,4,2)="20"					and		/*ER visits*/
	missing(caseid)=1							and 	/*no inpatient*/
	^(proc1 in (&ProcExclusionList.))			and		/*exclusion based on procedures*/
	(Significance="High" or dxstage>=3)					/*must be significant or stage higher than 3*/
group by
	enrolid
;

*** days since home health;
Create View work.trash010 as
select
	enrolid,
	&StartDate.-max(svcdate) 	as DaysHH
from 
	temp.SampleOtp1 
where
	substr(svcscat,4,2)="33"					and		/*Home Health claim*/
	missing(caseid)=1							and 	/*no inpatient*/
	^(proc1 in (&ProcExclusionList.))					/*exclusion based on procedures*/
group by
	enrolid
;

*** days since Major Surgery;
Create View work.trash011 as
select
	enrolid,
	&StartDate.-max(svcdate) 	as DaysMajorSurg
from 
	temp.SampleOtp1 
where
	missing(caseid)=1							and 	/*no inpatient*/
	ATG="SURG MAJOR"
group by
	enrolid
;

*** days since Oxygen treatment;
Create View work.trash012 as
select
	enrolid,
	&StartDate.-max(svcdate) 	as DaysOxygen
from 
	temp.SampleOtp1 
where
	missing(caseid)=1							and 	/*no inpatient*/
	proc1 in (&OxygenCPTList.)
group by
	enrolid
;

*** Days in LTC and Flag for LTC in the last 90 days (LTC defined based on svcscat = 102xx);
Create View work.trash013 as 
select 
	a.enrolid,
	a.fachdid,
	a.svcscat,
	b.svcdate as header_date,
	b.tsvcdat as header_last,
	b.days 
from 
	temp.SampleOTP1(where=
					(substr(svcscat,1,3)='102' and svcdate > &StartDate. - 90)
					) as a, 
	ccaef as b
where
	a.enrolid=b.enrolid and
	a.fachdid=b.fachdid
order by 
	enrolid,
	header_date;
;
Quit;

data work.trash013_1(keep=enrolid Days3mLTC flag3mLTC);
	set work.trash013;
	by enrolid;
	retain first last Days3mLTC 0;
	if first.enrolid then do;
		first=header_date;
		last=header_last;
		Days3mLTC=0;
	end;
	if header_date <= last then 
		last=max(last,header_last);
	else do;
		Days3mLTC=Days3mLTC + last-first;
		first=header_date;
		last=header_last;
	end;
	if last.enrolid then do;
		Days3mLTC=Days3mLTC + last-first;
		flag3mLTC=1;
		output;
	end;
run;

*** put the all the outpatient related variables together;
DATA
	work.trash101;
merge
	trash001_1(in=a) 
	trash001_2(in=b)
	trash002_1(in=c)
	trash002_2(in=d)
	trash003_1(in=e)
	trash003_2(in=f)
	trash004 (in=g)
	trash005 (in=h)
	trash006_1(in=i)
	trash006_2(in=j)
	trash007_1(in=k)
	trash007_2(in=l)
	trash008  (in=m)
	trash009  (in=n)
	trash010  (in=o)
	trash011  (in=p)
	trash012  (in=q)
	trash013_1(in=r)
;
by 
	enrolid;
if
	a or b or c or d or e or f or g or h or i or j or k or l or m or n or o or p or q or r;
run;

*** Merge with the original Sample and use counts of zero when no admissions;
PROC SQL;
Create Table temp.OP as
select
	a.enrolid,
	max(0,b.Count3mOV)							as Count3mOV,
	max(0,b.Count12mOV)							as Count12mOV,
	max(0,b.Count3mOVChronic)					as Count3mOVChronic,
	max(0,b.Count6mOVChronic)					as Count6mOVChronic,
	max(0,b.Count3mOVChronicSpecialist)			as Count3mOVChronicSpecialist,
	max(0,b.Count6mOVChronicSpecialist)			as Count6mOVChronicSpecialist,
	max(0,b.Count3mOVSpecialties)				as Count3mOVSpecialties,
	max(0,b.Count3mOVChronicSpecialties)		as Count3mOVChronicSpecialties,
	max(0,b.Count3mEr)							as Count3mER,
	max(0,b.Count12mER)							as Count12mER,
	max(0,b.Count3mERChronic)					as Count3mERChronic,
	max(0,b.Count6mERChronic)					as Count6mERChronic,
	min(365,b.DaysER)							as DaysER,
	min(365,b.DaysMajorER)						as DaysMajorER,
	min(365,b.DaysHH)							as DaysHH,
	min(365,b.DaysMajorSurg)					as DaysMajorSurg,
	min(365,b.DaysOxygen)						as DaysOxygen,
	max(0,b.Days3mLTC)							as Days3mLTC,
	max(0,b.flag3mLTC)							as flag3mLTC
from
	(Select distinct enrolid from temp.SamplewClassification) as a
left join
	work.trash101 as b
on
	a.enrolid=b.enrolid
Order by
	a.enrolid;


*************************************************************;
*** Merge all the variables from all claims OP/IP/Rx together;                                
data temp.AllModelInputs;
merge
	temp.SamplewClassification(in=orig)
	temp.OP		(in=a)
	temp.IP		(in=b)
	temp.Rx		(in=c)
	temp.IPandOP(in=d);
if orig or a or b or c or d;
by enrolid;
run;
proc export 
	data=temp.AllModelInputs
	outfile="&outpath./ModelInputs&version..csv" 
	replace;
run;

/*** RUN SPSS and get the Decision Tree model ***/
/*** Implement the Decision Tree Model from SPSS ***/									*************** <<<<<<<<---------- Put all model+rules together;
data temp.DTModel
/*	(keep=	
			enrolid
			AssignmentFinal
			Count6mChronicStage3 
			CountDaysSuppOpiates3m 
			Count12mChronicSign 
			Count12mOV 
			CountDaysSupp3m 
			DaysAnyAdm 
			DaysMajorER 
			CountTherClassChronic6m 
			CountAdm3mAll 
			Count6mERChronic
			Count12mER /* not used in the model but we'll use it for validation analysis *
			Count3mER  /* not used in the model but we'll use it for validation analysis *
			PopClass
			Rule)*/;
set temp.AllModelInputs (drop=AssignmentFinal);
if Count6mChronicStage3 <= 0 then do;  
	if	CountDaysSuppOpiates3m <= 50 then do; 
		if	Count12mChronicSign <= 0 then do; 
			if Count12mOV <= 0 then do; 
				if CountDaysSupp3m <= 37 then do; PopClass=1; Rule=1; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end; 
				else do; PopClass=2; Rule=2; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end;
			end; 
			else do; 
				if DaysAnyAdm <= 32 then do; PopClass=7; Rule=3; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end;
				else do; PopClass=2; Rule=4; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end;
			end;
		end;
		else do;
			if DaysAnyAdm <= 38 then do; PopClass=7; Rule=5; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end;
			else do; 
				if Count12mChronicSign <= 4 then do;
					if DaysMajorER <= 255 then do; PopClass=6; Rule=6; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end; 
					else do;  
						if CountTherClassChronic6m <= 6 then do; PopClass=3; Rule=7; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end;
						else do; PopClass=5; Rule=8; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end;
					end;
				end;
				else do; PopClass=5; Rule=9; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end;
			end;
		end;
	end;
	else do; PopClass=6; Rule=10; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end;
end;
else do;
	if CountAdm3mAll <= 0 then do; PopClass=6; Rule=11; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end; 
	else do;
		if Count6mERChronic <= 0 then do; PopClass=10; Rule=12; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end;
		else do; PopClass=7; Rule=13; RuleConfidence=input(put(Rule,RuleConfidence.),best5.3); end;
	end;
end;
run;
proc export 
	data=temp.DTModel
	outfile="&outpath./DTModel&version..csv" 
	replace;
run;

*** TREATMENT NAVIGATION ***;
*** transpose the DxCat;
data trash517_1(/*keep=enrolid svcdate DxCat DxStage*/ drop=dxcat1-dxcat4 dxstage1-dxstage4 dx1-dx4 i);
	set temp.SampleIPOPwDS1;	
	array c[4] dxcat1  -dxcat4;
	array s[4] dxstage1-dxstage4;
	do i=1 to 4;
		if 
			missing(c[i])=0 and 
			^(rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.)))
		then do;
			DxCat=c[i];
			DxStage=s[i];
			output;
		end;
	end;
run;

*** Select patient who qualify as Treatment Navigation in the past 30 days;
proc sql;

create table trash517_2 as select distinct
	a.enrolid,
	a.Dxcat,
	b.condition
from 
	trash517_1 as a
inner join
	temp.TreatmentNavigation as b
on
	a.DxCat=b.DxCat and
	a.DxStage=b.stage
where
	svcdate > &StartDate. - 30;

*** find the previous conditions for same dxcat and stage in the past year (366 days);
create table trash517_3 as select distinct
	a.enrolid,
	b.condition
from 
	trash517_1 as a
inner join
	temp.TreatmentNavigation as b
on
	a.DxCat=b.DxCat and
	a.DxStage=b.stage
where
	&StartDate. - 30 >= svcdate > &StartDate. - 366;

*** join with the new patients found previously;
create table trash517_4 as select
	a.*,
	1-missing(b.condition) as FlagPriorTrNav
from
	trash517_2 as a
left join
	trash517_3 as b
on
	a.enrolid=b.enrolid and
	a.condition=b.condition
order by
	a.enrolid,
	a.DxCat;

*** find the higher stages for any dxcat in the past 366 days;
create table trash517_5 as select distinct
	a.enrolid,
	b.condition,
	b.max_TrNavStage
from 
	trash517_1 as a
inner join
	(select distinct dxcat, condition, max(stage) as max_TrNavStage from temp.TreatmentNavigation group by dxcat) as b
on
	a.DxCat=b.DxCat and
	a.DxStage>b.max_TrNavStage
where
	svcdate > &StartDate. - 366;

*** join with the new patients found previously									*************** <<<<<<<<---------- Put all model+rules together;
create table temp.TrNav as select distinct
	a.enrolid,
	1 as FlagTrNav,
	4 as PopClass,
	a.FlagPriorTrNav,
	1-missing(b.max_TrNavStage) as FlagHigherStage
from
	trash517_4 as a
left join
	trash517_5 as b
on
	a.enrolid=b.enrolid and
	a.condition=b.condition
where 
	a.FlagPriorTrNav=0 and missing(b.max_TrNavStage)=1
order by
	a.enrolid;
quit;

proc export 
	data=temp.TrNav
	outfile="&outpath./TreatmentNavigation&version..csv" 
	replace;
run;


*** SURVEILLANCE ***;
*** transpose the Dxcat + Stage to have one per record, also apply the exclusion criteria;
data trash518_1(keep=enrolid svcdate rec_type svcscat proc1 DxCat DxStage);
	set temp.SampleIPOPwDS1;
	where svcdate > &StartDate. - 90;	
	array c[4] dxcat1  -dxcat4;
	array s[4] dxstage1-dxstage4;
	do i=1 to 4;
		if (rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.))) then c[i]=' ';
		if 
			(missing(c[i])=0 or missing(proc1)=0)
		then do;
			DxCat=c[i];
			DxStage=s[i];
			output;
		end;
	end;
run;

*** join the IP+OP data with HCPCxWalkPROCGRP to bring the PROCGRP codes;
proc sql;
create table trash518_2 as select
	a.enrolid,
	a.svcdate,
	a.dxcat,
	a.dxstage,
	a.proc1,
	a.svcscat,
	a.rec_type,
	b.ProcGRP
from
	trash518_1 as a
left join
	temp.HcpcXwalkGRP as b
on
	a.proc1=b.hcpc
order by
	a.enrolid;
quit;




/* data trash518_2;
set trash518_2;
ProcGRP = put(ProcGRP,$6.);
run; */


*** Modified ;
*** create the flags for General Active Cancer;
data trash518_3(keep=enrolid flag_GeneralActiveCancer);
set trash518_2;	
by enrolid;
retain flag_SurvActiveCancerDxcat flag_SurvActiveCancerProcGRP 0; 
if first.enrolid then do;
	flag_SurvActiveCancerDxcat=0;
	flag_SurvActiveCancerProcGRP=0;
end;
if 
	put(dxcat,$SurvActiveCancerDxcat.)='Y' 
then 
	flag_SurvActiveCancerDxcat=1; 
if 
	put(dxcat,$SurvActiveCancerPxDxcat.)='Y'	or
	/* put(ProcGRP,SurvActiveCancerPROCGRP.)='Y' */
	put(ProcGRP,SurvActiveCancerPROCGRP.)='Y'
then
	flag_SurvActiveCancerProcGRP=1;
flag_GeneralActiveCancer=flag_SurvActiveCancerDxcat * flag_SurvActiveCancerProcGRP;
if last.enrolid and flag_SurvActiveCancerDxcat=1 and flag_SurvActiveCancerProcGRP=1 then output;
run;


*** Works so far ***;



/* data trash518_2;
set trash518_2;
ProcGRP = put(ProcGRP,$18.);
run; */

*** join with the Specific Cancer by Dxcat;
proc sql;
create table trash518_4 as select distinct
	a.enrolid,
	a.dxcat,
	b.PROCGRP as ProcGRP_Specific
from
	trash518_2 as a
inner join
	temp.SurvSpecificActiveCancer as b
on
	a.dxcat=b.dxcat and
	a.dxstage>=b.stage;

*** join with the Specific Cancer by PROCGRP;
proc sql;
create table trash518_5 as select distinct
	a.enrolid,
	a.PROCGRP
from
	trash518_2 as a
inner join
	temp.SurvSpecificActiveCancer as b
on
	a.procgrp=b.procgrp;



*** Create Flag for Specific Active Cancer (join the previous selected based on DxCat with Specific Cancer by PROCGRP);
proc sql;
create table trash518_6 as select distinct
	a.enrolid,
	1 as flag_SpecificActiveCancer
from
	trash518_4 as a
inner join
	trash518_5 as b
on
	a.enrolid=b.enrolid and
	a.ProcGRP_Specific=b.ProcGRP
order by
	a.enrolid;

*** Flag for Miscellaneous DRG;
proc sql;
create table trash518_7 as select distinct
	enrolid,
	1 as flag_Miscellaneous
from
	temp.SampleInp1 		as a
inner join
	temp.SurvMiscellaneous	as b
on
	a.DRG=b.Code and
	b.CodeType='DRG' and
	a.admdate > &StartDate. - 90
order by
	enrolid;

*** PROC CONTENTS DATA=temp.SampleRx1;RUN;

*** PROC CONTENTS DATA=temp.SurvChemoActive;RUN;

*** Modified ;
*** convert NDCNUM to character for table;
data temp.SurvChemoActive(drop=ndc_old);
set temp.SurvChemoActive(rename=(ndc=ndc_old));
ndc=put(ndc_old,z11.);
run;

*** Modified ;
*** convert NDCNUM to character for table;
data temp.SurvChemoChronic(drop=ndc_old);
set temp.SurvChemoChronic(rename=(ndc=ndc_old));
ndc=put(ndc_old,z11.);
run;



*** select from ChemoActive;
proc sql;
create table trash518_8 as select distinct
	enrolid,
	1 as flag_ChemoActive
from
	temp.SampleRx1 			as a
inner join
	temp.SurvChemoActive	as b
on
	a.ndcnum=b.ndc and
	a.svcdate > &StartDate. - 90
order by
	enrolid;

*** select from ChemoChronic;
proc sql;
create table trash518_9 as select distinct
	enrolid
from
	temp.SampleRx1 			as a
inner join
	temp.SurvChemoChronic	as b
on
	a.ndcnum=b.ndc and
	a.svcdate > &StartDate. - 90;
proc sql;
create table trash518_10 as select distinct
	enrolid
from
	temp.SampleRx1 			as a
inner join
	temp.SurvChemoChronic	as b
on
	a.ndcnum=b.ndc and
	a.svcdate <= &StartDate. - 90;
proc sql;
create table trash518_11 as select distinct
	a.enrolid,
	1 as flag_ChemoChronic
from
	trash518_9 	as a
left join
	trash518_10	as b
on
	a.enrolid=b.enrolid
where
	a.enrolid ne b.enrolid
order by
	a.enrolid;

*** put them all together for Surveillance													*************** <<<<<<<<---------- Put all model+rules together;
data temp.Surv;
merge 
	trash518_3
	trash518_6
	trash518_7
	trash518_8
	trash518_11;
by enrolid;
FlagSurv=1;
PopClass=9;
run;

proc export 
	data=temp.Surv
	outfile="&outpath./Surveillance&version..csv" 
	replace;
run;


*** REBALANCE ***;

*** transpose the Dxcat + Stage to have one per record, also apply the exclusion criteria. Similar to 518_1 and 518_2 but save ICD9 too;
data trash519_1(keep=enrolid svcdate svcscat Dx DxCat DxStage fac_prof proc1 rec_type);
	set temp.SampleIPOPwDS1;
	array d[4] dx1-dx4;
	array c[4] dxcat1  -dxcat4;
	array s[4] dxstage1-dxstage4;
	do i=1 to 4;
		if (rec_type='O' and (substr(svcscat,4,2) in (&SvcCatExclusionList.) or proc1 in (&ProcExclusionList.))) then do;
			c[i]=' ';
			d[i]=' ';
		end;
		if 
			(missing(c[i])=0 or missing(proc1)=0 or missing(d[i])=0)
		then do;
			DxCat=c[i];
			DxStage=s[i];
			Dx=d[i];
			output;
		end;
	end;
run;

*** join the IP+OP data with HCPCxWalkPROCGRP to bring the PROCGRP codes, same as 518_2;
proc sql;
create table trash519_2 as select
	a.enrolid,
	a.svcdate,
	a.dx,
	a.dxcat,
	a.dxstage,
	a.proc1,
	a.svcscat,
	a.rec_type,
	a.fac_prof,
	b.ProcGRP
from
	trash519_1 as a
left join
	temp.HcpcXwalkGRP as b
on
	a.proc1=b.hcpc
order by
	a.enrolid;
quit;


*** PROC CONTENTS DATA=trash519_2;RUN;

*** PROC CONTENTS DATA=temp.SampleInp1;RUN;

*** Rebalance based on a condition being present in the last 90 days regardless of prior claims                                    <<<------ for REBALANCE final merge;
proc sql;
create table trash519_3 as select distinct *
from 
/* based on PSY in ER or certain DxCats from both inp and otp */
	(select distinct 
		enrolid,
		1 as flag_NewCondNoHistCheck
	from trash519_2
	where
		svcdate > &StartDate. - 90																		and			
		(((DxCat in (&ConditionDxCat.) and DxStage >= &ConditionDxCatStage.) 						or
		(substr(DxCat,1,3) in (&ConditionDxCatER.) and fac_prof='F' and	substr(svcscat,4,2)="20")) 	 or
		 procGRP in (&ConditionProcGRP.)))
union 
/* based on DRG and mental admissions from inpatient data */
	(select distinct
		enrolid,
		1 as flag_Cond
	from temp.SampleInp1 
	where
		disdate >= &StartDate. - 90				and
		(put(drg,z3.) in (&ConditionDRG.)		or
		 admtyp in (&ConditionAdminType.))) 

order by 
	enrolid;
quit;


*** Rebalance based on new DxCat in the past 30 days AND there were not present before;
proc sql;

* identify all patients who match the list of new DxCat in the past 90 days, keep the first day of the encounter for future use with the exclusion of the Rx drugs;
create table trash519_4 as select
	a.enrolid,
	a.DxCat,
	min(a.svcdate) as FirstDate format=date7.
from 
	trash519_1 as a,
	temp.RebalanceNewDxCat as b
where
	a.DxCat=b.DxCat 				and
	a.DxStage>=b.Stage			and
	a.svcdate > &StartDate. - 90
group by 
	a.enrolid,
	a.DxCat;
* identify all patients who match the list of new DxCat in the past year, before 90 days, in order to exclude them when matching with the new ones;
create table trash519_5 as select distinct
	a.enrolid,
	a.DxCat
from 
	trash519_1 as a,
	temp.RebalanceNewDxCat as b
where
	a.DxCat=b.DxCat 				and
	a.DxStage>=b.StageHistory		and
	a.svcdate <= &StartDate. - 90
order by 
	a.enrolid,
	a.DxCat;
* exclude the patients if they match on the the Rollup of the DxCat (first 3 characters) if they are in both recent 90 days and past 90 days;  
create table trash519_6 as select distinct
	a.enrolid
from
	trash519_4 as a
left join
	trash519_5 as b
on
	a.enrolid=b.enrolid and
	substr(a.DxCat,1,3)=substr(b.DxCat,1,3)
where
	substr(a.DxCat,1,3)^=substr(b.DxCat,1,3)
order by 
	enrolid;

* select all the claims mathcing the Rx by Therapeutic Class;
create table trash519_7 as select distinct
	a.enrolid,
	a.svcdate format=date7.,
	a.thercls,
	b.DxCat
from
	temp.SampleRx1 as a,
	temp.RebalanceNewDxCatwoRx as b
where
	a.thercls=b.thercls
order by
	a.enrolid,
	a.svcdate;
* match the drug claims with the patients identified with the new DxCats based on the Dxcat from the exlcusion Rx logic, if the drug is 90 days before the first encounter of DxCAt then flag it;
create table trash519_8 as select
	a.*,
	b.svcdate,
	b.thercls,
	case when a.FirstDate - b.svcdate > 90 then 1 else 0 end as flag_RxlogicExclude 
from
	trash519_4 as a
left join
	trash519_7 as b
on
	a.enrolid=b.enrolid and
	a.DxCat=b.DxCat
order by
	a.enrolid,
	a.DxCat,
	b.SvcDate;
* keep only the patients that need to be excluded, having at least a flag of 1;
create table trash519_9 as select
	enrolid
from
	trash519_8
group by
	enrolid
having
	max(flag_RxlogicExclude)=1;
* exclude the patients with drugs in the past year                                   <<<------ for REBALANCE final merge;                             
create table trash519_10 as select distinct                     
	a.enrolid,
	1 as flag_NewCondDxCat
from
	trash519_6 as a
left join
	trash519_9 as b
on
	a.enrolid=b.enrolid
where
	a.enrolid^=b.enrolid
order by 
	enrolid;
quit;

*** Modified ;
* Rebalance based on new DRG in the past 30 days and no prior history;
proc sql;
* select all members with matching of rebalance new DRG in the past 90 days;
create table trash519_11 as select distinct
	a.enrolid,
	b.description
from
	temp.SampleInp1 as a
inner join
	temp.RebalanceNewDRG as b
on
	/* put(a.drg,z3.)=b.drg */
	   a.drg = b.drg
where
	a.disdate > &StartDate. - 90
order by 
	a.enrolid;
* select all members with prior history of rebalance new DRG;
create table trash519_12 as select distinct
	a.enrolid,
	b.description
from
	temp.SampleInp1 as a
inner join
	temp.RebalanceNewDRG as b
on
	/*put(a.drg,z3.)=b.drg */
	a.drg = b.drg
where
	a.disdate <= &StartDate. - 90
order by 
	a.enrolid;
* exclude the patients with DRG in the past                                   <<<------ for REBALANCE final merge;                             
create table trash519_13 as select distinct                     
	a.enrolid,
	1 as flag_NewCondDRG
from
	trash519_11 as a
left join
	trash519_12 as b
on
	a.enrolid=b.enrolid and
	a.description=b.description
where
	a.enrolid^=b.enrolid
order by 
	enrolid;
quit;


*** PROC CONTENTS DATA=trash519_1;RUN;
*** PROC PRINT DATA=trash519_1(OBS=40);RUN;
*** PROC CONTENTS DATA=temp.RebalanceNewDx;RUN;
*** PROC PRINT DATA=temp.RebalanceNewDx(OBS=40);RUN;



* Rebalance based on new Dx in the past 30 days and no prior history;
proc sql;
* select all members with matching of rebalance new Dx in the past 90 days;
create table trash519_14 as select distinct
	a.enrolid,
	b.description
from
	trash519_1 as a
inner join
	temp.RebalanceNewDx as b
on
	substr(a.dx,1,4)=b.icd
where
	a.svcdate > &StartDate. - 90
order by 
	a.enrolid;
* select all members with prior history of rebalance new Dx;
create table trash519_15 as select distinct
	a.enrolid,
	b.description
from
	trash519_1 as a
inner join
	temp.RebalanceNewDx as b
on
	substr(a.dx,1,4)=b.icd
where
	a.svcdate <= &StartDate. - 90
order by 
	a.enrolid;
* exclude the patients with DRG in the past                                   <<<------ for REBALANCE final merge;                             
create table trash519_16 as select distinct                     
	a.enrolid,
	1 as flag_NewCondDx
from
	trash519_14 as a
left join
	trash519_15 as b
on
	a.enrolid=b.enrolid and
	a.description=b.description
where
	a.enrolid^=b.enrolid
order by 
	enrolid;

*** put all REBALANCE pieces together													*************** <<<<<<<<---------- Put all model+rules together;
data temp.Rebalance;
merge 
	trash519_3
	trash519_10
	trash519_13
	trash519_16;
by enrolid;
FlagRebalance=1;
PopClass=8;
run;

proc export 
	data=temp.Rebalance
	outfile="&outpath./Rebalance&version..csv" 
	replace;
run;


*** Newborn in the past month by default in Engagement DRG 790 - 795;					*************** <<<<<<<<---------- Put all model+rules together;
proc sql;
* select all members with matching of rebalance new DRG in the past 90 days;
create table temp.Neonates as select distinct
	enrolid,
	DRG,
	1 as FlagNeoNate,
	2 as PopCLass
from
	temp.SampleInp1 as a
where
	admdate > &StartDate. - 30 and 
	drg in (&NeonatesDRGList.) 
order by 
	enrolid;

*** Newborn in the past month by default in Engagement DRG 790 - 795;					*************** <<<<<<<<---------- Put all model+rules together;
proc sql;
* select all members with matching of rebalance new DRG in the past 90 days;
create table temp.Neonates as select distinct
	enrolid,
	DRG,
	1 as FlagNeoNate,
	2 as PopCLass
from
	temp.SampleInp1 as a
where
	admdate > &StartDate. - 30 and 
	drg in (&NeonatesDRGList.) 
order by 
	enrolid;

proc export 
	data=temp.NeoNates
	outfile="&outpath./Neonates&version..csv" 
	replace;
run;



/*********************/
/*** FINAL OUTPUT ***/
/*********************/
*** MERGE All the RULES from SPSS Modela and Janet's logic rules together ***;
proc sql;
create table temp.AllRules as select
	a.*,
	put(a.PopClass,categories.) as PopClassDTModelDescription,
	max(a.PopClass,b.PopClass) as PopClassFinal,
	put(calculated PopClassFinal,categories.) as PopClassFinalDescription,
	case when b.PopClass > a.PopCLass then 1 else 0 end as FlagOverwrite
from
	temp.DTModel as a
left join
	(select 
		enrolid,
		max(PopClass) as PopClass
	from
		(select enrolid, PopClass from temp.TrNav union
		 select enrolid, PopClass from temp.Surv union
		 select enrolid, PopClass from temp.Rebalance union
		 select enrolid, PopClass from temp.Neonates)
	group by enrolid) as b
on
	a.enrolid=b.enrolid
order by enrolid; 
quit;
proc export 
	data=temp.AllRules
	outfile="&outpath./AllRules&version..csv" 
	replace;
run;








