
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


/*** create the sample file if needed ***/
/*import MCC cohort*/
data temp.SamplewClassification;
	set arch&year..ccaea&MSversion.;
	keep enrolid;
	where client=450 and enrind12=1;
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
*** Import the list of PROCGRP for specific active cancer for Surveillance logic;
%ImportMeta(JanetMetadata_SurveillanceSpecificActiveCancer.csv,SurvSpecificActiveCancer);
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
fmtname='$SurvActiveCancerPROCGRP';
run;
proc format cntlin=trash_1; run;

********************************************************************************;
*%include '/rpscan/u071439/script/PopClassModel_BeforeAE_YL.sas';

********** run AE for DS using above configuration file-AE not working on nike;
****************x "&AEpath./AnalyticsEngine.sh &AEpath./Configfile.properties"; 

******************************************************************************;
%include '/rpscan/u071439/script/PopClassModel_AfterAE_YL.sas';

