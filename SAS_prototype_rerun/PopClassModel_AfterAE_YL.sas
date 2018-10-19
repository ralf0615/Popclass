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
	arch&year..ccaeo&MSversion.			as a,
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
	arch&year..ccaef&MSversion.	as b
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
	substr(svcscat,4,2) in ("25","24")							and		/*office visits*/
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
	substr(svcscat,4,2) in ("25","24")							and		/*office visits*/
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
	substr(svcscat,4,2) in ("25","24")							and		/*office visits*/
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
	substr(svcscat,4,2) in ("25","24")							and		/*office visits*/
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
	substr(svcscat,4,2) in ("25","24")					and		/*office visits*/
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
	substr(svcscat,4,2) in ("25","24")					and		/*office visits*/
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
	substr(svcscat,4,2) in ("25","24")							/*office visits*/
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
	substr(svcscat,4,2) in ("25","24")					and		/*office visits*/
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
	arch&year..ccaef&MSversion. as b
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
	temp.IPandOP(in=c);
if orig or a or b or c;
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
			AssignmentFinal /* not available when just scoring, it was used when testing the initial model with the manual labels *
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
set temp.AllModelInputs;
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
	put(ProcGRP,$SurvActiveCancerPROCGRP.)='Y'
then
	flag_SurvActiveCancerProcGRP=1;
flag_GeneralActiveCancer=flag_SurvActiveCancerDxcat * flag_SurvActiveCancerProcGRP;
if last.enrolid and flag_SurvActiveCancerDxcat=1 and flag_SurvActiveCancerProcGRP=1 then output;
run;

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


*** Convert a.procgroup and b.procgroup to string such that 'ERROR: The Equality operator must compare operands of the same type' does not raise
proc sql;
SELECT CONVERT(vchar(10), procgrp) FROM trash518_2;

proc sql;
SELECT CONVERT(vchar(10), procgrp) FROM temp.SurvSpecificActiveCancer;


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
		(substr(DxCat,1,3) in (&ConditionDxCatER.) and fac_prof='F' and	substr(svcscat,4,2)="20")) 	or
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
	put(a.drg,z3.)=b.drg
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
	put(a.drg,z3.)=b.drg
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
