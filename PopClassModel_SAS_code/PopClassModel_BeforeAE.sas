
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
		q;
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
filename AEconfig "&AEoutpath./Configfile.properties";
data _null_;
file AEconfig;
put "-m:DiseaseStaging";
put "-f:&AEoutpath./&version..csv";
put "-o:&AEoutpath.";
run;
