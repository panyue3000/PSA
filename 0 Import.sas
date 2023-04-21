
/*proc import out=whims*/

/*from Nick*/
/*  datafile = "C:\Users\n.nogueira\Desktop\Research\WHIMS\WHIMS Data Clean\whims_comb_03.31.23 - NA blank.xlsx"*/
/*from Pan*/
/*  datafile = "C:\Users\panyue\Box\WHIMS Data (From Alejandro, added 2.16.22)\WHIMS merge\whims_comb.csv"*/
/*  dbms = csv replace;*/
/*run;*/

data whims_clean;
set whims_comb_nona;

record_ID=strip(record_ID);

*CHANGE REDCAP 12 MONTH TIME POINT WORDING;
if redcap_event_name="12_month_followup_arm_1" or redcap_event_name="12_month_followuo_arm_1" then redcap_event_name="12_month_followup_arm_1";

*AMSEL CHECK;
amsel_score=0;
if discharge_lab=1 then amsel_score+1;
if clue_cell_lab=1 then amsel_score+1;
if whiff_lab=1 then amsel_score+1;
if ph_lab=2 then amsel_score+1;

*CREATING BV DIAGNOSIS VARIABLE;
length BV $ 30;
if amsel_lab=. and nugent_lab=. then BV="";
else if amsel_lab=1 and nugent_lab>=7 then BV="Clinical and Lab Confirmed";
else if amsel_lab=1 and nugent_lab<7 then BV="Clinical Confirmed";
else if amsel_lab=0 and nugent_lab>=7 then BV="Lab Confirmed";
else BV="Absent";

if BV="" then BV_combined=.;
*PER PROTOCOL ONLY PEOPLE MEETING AMSEL CRITERIA WERE BV POSITIVE (CLINICAL CRITERIA);
else if BV="Clinical Confirmed" OR BV="Clinical and Lab Confirmed" then BV_combined=1;

*AS OF 03/01/2022 PEOPLE MEETING NUGENT CRITERIA OF 7 AND ABOVE (LABORATORY CRITERIA) WHILE AMSEL NEGATIVE WERE ALSO BV POSITIVE;
else if BV="Lab Confirmed" and phys_date>=22705 then BV_combined=1;
else BV_combined=0;

*ENROLLMENT CODING: WHIMS STOPPED ENROLLING TRICH PATIENTS ON 09/10/2019 AND RESTARTED ON 08/04/2020;
*IF THEY ARE DIAGNOSED WITH STI, THEY WERE ENROLLED UP UNTIL 09/10/2019;
length enrolled $ 30;
if BV_combined=0 and redcap_event_name="baseline_arm_1"
	then enrolled="Screen Failure";
else if BV_combined=1 and (chlamydia_lab=1 or gonorrhea_lab=1 or trichomonas_lab=1) and phys_date>21802 and phys_date<22131 and redcap_event_name="baseline_arm_1"
	then enrolled="Screen Failure"; *IF CHLAMYDIA, GONORRHEA, TRICH + AFTER 09/10/2019 AND BEFORE 08/04/2020 THEN NOT ENROLLED;
else if BV_combined=1 and  (chlamydia_lab=1 or gonorrhea_lab=1) and phys_date>22131 and redcap_event_name="baseline_arm_1" 
	then enrolled="Screen Failure"; *IF CHLAMYDIA, GONORRHEA + AFTER 08/04/2020 THEN NOT ENROLLED;
else if BV_combined=1 and redcap_event_name="baseline_arm_1" 
	then enrolled="Enrolled - BV";

*ENROLLMENT CONTINUED;
if 	(redcap_event_name="1_month_followup_arm_1" or redcap_event_name="6_month_followup_arm_1" or redcap_event_name="supplemental_arm_1" 
	or redcap_event_name="12_month_followup_arm_1" or redcap_event_name="12_month_followuo_arm_1") and phys_date~=.
	then enrolled="Enrolled - BV";
if control_group~=. then do;
	if control_group=1 then enrolled="Enrolled - Control";
end;

*CODE SAMPLE COLLECTION BASED ON COMPLETION OF IN-PERSON VISIT;
if phys_date~=. then sample=1;
else sample=0;

*RECODE STIs;
if chlamydia_lab~=. then do;
if chlamydia_lab=1 then chlamydia_num=1;
else if chlamydia_lab=0 then chlamydia_num=0;
end;

if trichomonas_lab~=. then do;
if trichomonas_lab=1 then trichomonas_num=1;
else if trichomonas_lab=0 then trichomonas_num=0;
end;

if gonorrhea_lab~=. then do;
if gonorrhea_lab=1 then gonorrhea_num=1;
else if gonorrhea_lab=2 then gonorrhea_num=0;
else if gonorrhea_lab=3 then gonorrhea_num=.;
end;

*******************
***SPECIAL CASES***
*******************
;
if record_ID="WHIMS0393" then enrolled="Screen Failure"; *AMSEL NEGATIVE, NUGENT=7 AFTER 03/01/2022 BUT DID NOT RETURN FOR SAMPLE COLLECTION. SF.;
if record_ID="WHIMS0397" then enrolled="Screen Failure"; *AMSEL POSITIVE, NUGENT=9 BUT REFUSED SAMPLE COLLECTION. SF.;
if record_ID="WHIMS0200" and redcap_event_name="supplemental_arm_1" then DELETE; *THIS SUPPLEMENTAL VISIT SHOULD NOT HAVE BEEN COMPLETED PER PROTOCOL;
if record_ID="WHIMS0128 B" and redcap_event_name="baseline_arm_1" then DELETE; *THIS IS A BLANK BASELINE RECORD FOR 128B, PARTICIPANT COMPLETED PART OF T1 WHEN THE PART 2 PROJECT WAS IMPLEMENTED;
if record_ID="WHIMS0128 B" and redcap_event_name="1_month_followup_arm_1" then record_ID="WHIMS0128"; *RENAMING OF T1 128B TO 128 TO MERGE BOTH RECORD IDS;
if record_ID in("WHIMS0180","WHIMS0324") and redcap_event_name="baseline_arm_1" then sample=0; *PARTICIPANTS DID NOT COMPLETE SAMPLE COLLECTION DUE TO SPECIAL CIRCUMSTANCE;
if record_ID in("WHIMS0180","WHIMS0324") and redcap_event_name="baseline_arm_1" then enrolled="Screen Failure"; *PARTICIPANTS DID NOT COMPLETE SAMPLE COLLECTION DUE TO SPECIAL CIRCUMSTANCE;
if record_ID in ("WHIMS0115","WHIMS0256","WHIMS0281","WHIMS0373","WHIMS0375","WHIMS0388","WHIMS0396") and redcap_event_name="baseline_arm_1" then enrolled="Screen Failure";
	*BASELINES THAT NEVER COMPLETED SCREENING AND SAMPLE COLLECTION DUE (1) MENSTRUATION, (2) UNABLE TO PROVIDE URINE FOR TESTING, (3) PREGNANCY,
	(4) FRIABLE CERVIX, (5) NEVER RETURNED FOR SECOND PART;
if record_ID="WHIMS0033" and redcap_event_name="baseline_arm_1" and A=231 then DELETE; *DELETE BLANK BASELINE RECORD FROM WHIMS0033 IN PART 2;
if record_ID="WHIMS0339" and redcap_event_name="baseline_arm_1" then enrolled="Enrolled - BV"; *AMSEL NEG AND ORIGINAL NUGENT WAS 8 AND REVISED NUGENT WAS 4; 
if record_ID="WHIMS0430" and redcap_event_name="baseline_arm_1" then enrolled="Screen Failure"; *AMSEL NEG AND NUGENT WAS 9 BUT NEVER RETURNED; 


*T1 QUESTIONNAIRE - QUESTIONNAIRE SENT OUT BY ACCIDENT AND PEOPLE COMPLETED THEM;
*SCREEN FAILURES - NO T1s;
if record_ID in ("WHIMS0137","WHIMS0148","WHIMS0182","WHIMS0199","WHIMS0208","WHIMS0214","WHIMS0216","WHIMS0220","WHIMS0223",
				"WHIMS0225","WHIMS0228","WHIMS0229","WHIMS0232","WHIMS0243","WHIMS0268","WHIMS0281","WHIMS0289","WHIMS0290",
				"WHIMS0301") and redcap_event_name="1_month_followup_arm_1" then DELETE;
*CONTROLS - NO T1s;
if record_ID in ("WHIMS0137","WHIMS0184","WHIMS0257","WHIMS0260","WHIMS0271","WHIMS0272","WHIMS0378")
				and redcap_event_name="1_month_followup_arm_1" then DELETE;
*BV GROUP - NO T1s YET;
if record_ID in ("WHIMS0128")
				and redcap_event_name="1_month_followup_arm_1" then DELETE;
/*
"WHIMS0206","WHIMS0267","*WHIMS0330","*WHIMS0342" THESE IDS HAVE COMPLETED T1 QUESTIONNAIRES BUT NO-SHOWED FOR T1 IN-PERSON. KEEP DATA.
*/
*SCREENING PENDING - NO T1s YET;
if record_ID in ("WHIMS0397")
				and redcap_event_name="1_month_followup_arm_1" then DELETE;

run;

data whims_clean_v2;
set whims_clean;

*DATA RECODE;
%macro ynf_1yes2no(var=);
if &var=. then &var._new=.;
else if &var=1 then &var._new=1;
else if &var=2 then &var._new=0;
drop &var;
rename &var._new=&var;
%mend;

%ynf_1yes2no(var=risk13);
%ynf_1yes2no(var=medgyn2_v2);
%ynf_1yes2no(var=medgyn3_v2);
%ynf_1yes2no(var=medgyn3_a_v2);
%ynf_1yes2no(var=medgyn17_v2);
%ynf_1yes2no(var=medgyn19_v2);
%ynf_1yes2no(var=medgyn20_v2);
%ynf_1yes2no(var=medgyn22_v2);
%ynf_1yes2no(var=medgyn28_v2);
%ynf_1yes2no(var=medgyn30_v2);
%ynf_1yes2no(var=risk8_v2);
%ynf_1yes2no(var=risk9_v2);
%ynf_1yes2no(var=risk10_v2);
%ynf_1yes2no(var=risk13_v2);
%ynf_1yes2no(var=vp1_v2);
%ynf_1yes2no(var=vp10_v2);
%ynf_1yes2no(var=vp15_v2);
%ynf_1yes2no(var=vp19_v2);
%ynf_1yes2no(var=vp23_v2);
%ynf_1yes2no(var=vp30_v2);
%ynf_1yes2no(var=vp34_v2);
%ynf_1yes2no(var=vp39_v2);
%ynf_1yes2no(var=vp43_v2);
%ynf_1yes2no(var=dem9_v2);
%ynf_1yes2no(var=medgyn2_v3);
%ynf_1yes2no(var=medgyn3_v3);
%ynf_1yes2no(var=medgyn3_a_v3);
%ynf_1yes2no(var=medgyn5_v3);
%ynf_1yes2no(var=medgyn7_v3);
%ynf_1yes2no(var=medgyn17_v3);
%ynf_1yes2no(var=medgyn19_v3);
%ynf_1yes2no(var=medgyn20_v3);
%ynf_1yes2no(var=medgyn22_v3);
%ynf_1yes2no(var=medgyn23_a_v3);
%ynf_1yes2no(var=medgyn28_v3);
%ynf_1yes2no(var=medgyn29_v3);
%ynf_1yes2no(var=risk8_v3);
%ynf_1yes2no(var=risk9_v3);
%ynf_1yes2no(var=risk10_v3);
%ynf_1yes2no(var=risk13_v3);
%ynf_1yes2no(var=risk12_v3);
%ynf_1yes2no(var=risk14_v3);
%ynf_1yes2no(var=risk15_v3);
%ynf_1yes2no(var=risk16_v3);
%ynf_1yes2no(var=vp1_v3);
%ynf_1yes2no(var=vp10_v3);
%ynf_1yes2no(var=vp15_v3);
%ynf_1yes2no(var=vp19_v3);
%ynf_1yes2no(var=vp23_v3);
%ynf_1yes2no(var=vp30_v3);
%ynf_1yes2no(var=vp34_v3);
%ynf_1yes2no(var=vp39_v3);
%ynf_1yes2no(var=vp43_v3);

%ynf_1yes2no(var=covid_3);
%ynf_1yes2no(var=covid_4);
%ynf_1yes2no(var=covid_6);
%ynf_1yes2no(var=covid_8);
%ynf_1yes2no(var=covid_19);
%ynf_1yes2no(var=covid_21);
%ynf_1yes2no(var=covid_24);
%ynf_1yes2no(var=covid_25);
%ynf_1yes2no(var=covid_28);
%ynf_1yes2no(var=covid_29);
%ynf_1yes2no(var=covid_32);
%ynf_1yes2no(var=covid_33);
%ynf_1yes2no(var=covid_36);
%ynf_1yes2no(var=covid_37);
%ynf_1yes2no(var=covid_40);
%ynf_1yes2no(var=covid_41);
%ynf_1yes2no(var=covid_44);
%ynf_1yes2no(var=covid_45);
%ynf_1yes2no(var=covid_48);
%ynf_1yes2no(var=covid_49);
%ynf_1yes2no(var=covid_52);
%ynf_1yes2no(var=covid_53);
%ynf_1yes2no(var=covid_56);
%ynf_1yes2no(var=covid_57);
%ynf_1yes2no(var=covid_60);
%ynf_1yes2no(var=covid_61);
%ynf_1yes2no(var=covid_64);
%ynf_1yes2no(var=covid_65);
%ynf_1yes2no(var=covid_68);
%ynf_1yes2no(var=covid_69);
%ynf_1yes2no(var=covid_72);
%ynf_1yes2no(var=covid_73);
%ynf_1yes2no(var=covid_76);
%ynf_1yes2no(var=covid_77);
%ynf_1yes2no(var=covid_80);
%ynf_1yes2no(var=covid_81);
%ynf_1yes2no(var=covid_84);
%ynf_1yes2no(var=covid_86);
%ynf_1yes2no(var=covid_3_6mo);
%ynf_1yes2no(var=covid_19_6mo);
%ynf_1yes2no(var=covid_21_6mo);
%ynf_1yes2no(var=covid_24_6mo);
%ynf_1yes2no(var=covid_25_6mo);
%ynf_1yes2no(var=covid_28_6mo);
%ynf_1yes2no(var=covid_29_6mo);
%ynf_1yes2no(var=covid_32_6mo);
%ynf_1yes2no(var=covid_33_6mo);
%ynf_1yes2no(var=covid_36_6mo);
%ynf_1yes2no(var=covid_37_6mo);
%ynf_1yes2no(var=covid_40_6mo);
%ynf_1yes2no(var=covid_41_6mo);
%ynf_1yes2no(var=covid_44_6mo);
%ynf_1yes2no(var=covid_45_6mo);
%ynf_1yes2no(var=covid_48_6mo);
%ynf_1yes2no(var=covid_49_6mo);
%ynf_1yes2no(var=covid_52_6mo);
%ynf_1yes2no(var=covid_53_6mo);
%ynf_1yes2no(var=covid_56_6mo);
%ynf_1yes2no(var=covid_57_6mo);
%ynf_1yes2no(var=covid_60_6mo);
%ynf_1yes2no(var=covid_61_6mo);
%ynf_1yes2no(var=covid_64_6mo);
%ynf_1yes2no(var=covid_65_6mo);
%ynf_1yes2no(var=covid_68_6mo);
%ynf_1yes2no(var=covid_69_6mo);
%ynf_1yes2no(var=covid_72_6mo);
%ynf_1yes2no(var=covid_73_6mo);
%ynf_1yes2no(var=covid_76_6mo);
%ynf_1yes2no(var=covid_77_6mo);
%ynf_1yes2no(var=covid_80_6mo);
%ynf_1yes2no(var=covid_81_6mo);
%ynf_1yes2no(var=covid_84_6mo);
%ynf_1yes2no(var=covid_86_6mo);

%macro ynf_1yes2no3dk(var=);
if &var=. then &var._new=.;
else if &var=1 then &var._new=1;
else if &var=2 then &var._new=0;
else if &var=3 then &var._new=.;
drop &var;
rename &var._new=&var;
%mend;

%ynf_1yes2no3dk(var=medgyn16);

%macro ynf_1yes2no3nd(var=);
if &var=. then &var._new=.;
else if &var=1 then &var._new=1;
else if &var=2 then &var._new=0;
else if &var=3 then &var._new=.;
drop &var;
rename &var._new=&var;
%mend;

%ynf_1yes2no3nd(var=phys1);
%ynf_1yes2no3nd(var=phys3);
%ynf_1yes2no3nd(var=phys4);
%ynf_1yes2no3nd(var=phys9);
%ynf_1yes2no3nd(var=phys10);
%ynf_1yes2no3nd(var=gonorrhea_lab);

%macro ynf_1yes0no3dk(var=);
if &var=. then &var._new=.;
else if &var=1 then &var._new=1;
else if &var=0 then &var._new=0;
else if &var=3 then &var._new=2;
drop &var;
rename &var._new=&var;
%mend;

%ynf_1yes0no3dk(var=covid_155);
%ynf_1yes0no3dk(var=covid_155_6mo);

*RECODE;
%macro num(var=);
if &var="" then &var._new=.;
else if &var~="" then &var._new=&var;
drop &var;
rename &var._new=&var;
%mend;

%num(var=vp35_v2);
%num(var=vp35_v3);
%num(var=vp44_v2);
%num(var=vp44_v3);
%num(var=vp36_v3);
%num(var=vp37_v3);
%num(var=vp45_v3);
%num(var=vp46_v3);
%num(var=covid_20_6mo);
%num(var=covid_22_6mo);
%num(var=covid_23_6mo);
%num(var=covid_38_6mo);
%num(var=covid_39_6mo);
%num(var=covid_78_6mo);
%num(var=covid_79_6mo);
%num(var=covid_82_6mo);
%num(var=covid_83_6mo);
%num(var=covid_87_6mo);
%num(var=covid_88_6mo);
%num(var=covid_122_6mo);
%num(var=covid_128_6mo);
%num(var=covid_134_6mo);
%num(var=covid_140_6mo);
%num(var=covid_146_6mo);
%num(var=covid_153_6mo);
%num(var=covid_204_6mo);
%num(var=covid_205_6mo);

run;

data whims_clean_v3;
set whims_clean_v2;

%macro merge_three(baseline_var=, month_1_var=, month_supp_6_12_var=);

if redcap_event_name="baseline_arm_1" then do;
&baseline_var._new=&baseline_var;
end;

if redcap_event_name="1_month_followup_arm_1" then do;
&baseline_var._new=&month_1_var;
end;

if redcap_event_name="6_month_followup_arm_1" or redcap_event_name="supplemental_arm_1" or 
redcap_event_name="12_month_followup_arm_1" then do;
&baseline_var._new=&month_supp_6_12_var;
end;

drop &baseline_var &month_1_var &month_supp_6_12_var; 
rename &baseline_var._new=&baseline_var;

%mend;

%merge_three(baseline_var=medgyn3, month_1_var=medgyn3_v2, month_supp_6_12_var=medgyn3_v3);
%merge_three(baseline_var=medgyn3_a, month_1_var=medgyn3_a_v2, month_supp_6_12_var=medgyn3_a_v3);
%merge_three(baseline_var=medgyn3_b, month_1_var=medgyn3_b_v2, month_supp_6_12_var=medgyn3_b_v3);
%merge_three(baseline_var=medgyn2, month_1_var=medgyn2_v2, month_supp_6_12_var=medgyn2_v3);
%merge_three(baseline_var=medgyn4, month_1_var=medgyn4_v2, month_supp_6_12_var=medgyn4_v3);
%merge_three(baseline_var=medgyn6, month_1_var=medgyn6_v2, month_supp_6_12_var=medgyn6_v3);
%merge_three(baseline_var=medgyn17, month_1_var=medgyn17_v2, month_supp_6_12_var=medgyn17_v3);
%merge_three(baseline_var=medgyn18, month_1_var=medgyn18_v2, month_supp_6_12_var=medgyn18_v3);
%merge_three(baseline_var=medgyn19, month_1_var=medgyn19_v2, month_supp_6_12_var=medgyn19_v3);
%merge_three(baseline_var=medgyn20, month_1_var=medgyn20_v2, month_supp_6_12_var=medgyn20_v3);
%merge_three(baseline_var=medgyn22, month_1_var=medgyn22_v2, month_supp_6_12_var=medgyn22_v3);
%merge_three(baseline_var=risk3, month_1_var=risk3_v2, month_supp_6_12_var=risk3_v3);
%merge_three(baseline_var=risk4, month_1_var=risk4_v2, month_supp_6_12_var=risk4_v3);
%merge_three(baseline_var=risk5, month_1_var=risk5_v2, month_supp_6_12_var=risk5_v3);
%merge_three(baseline_var=risk6, month_1_var=risk6_v2, month_supp_6_12_var=risk6_v3);
%merge_three(baseline_var=risk7, month_1_var=risk7_v2, month_supp_6_12_var=risk7_v3);
%merge_three(baseline_var=risk8, month_1_var=risk8_v2, month_supp_6_12_var=risk8_v3);
%merge_three(baseline_var=risk9, month_1_var=risk9_v2, month_supp_6_12_var=risk9_v3);
%merge_three(baseline_var=risk10, month_1_var=risk10_v2, month_supp_6_12_var=risk10_v3);
%merge_three(baseline_var=risk13, month_1_var=risk13_v2, month_supp_6_12_var=risk13_v3);
%merge_three(baseline_var=risk13_a___1, month_1_var=risk13_a_v2___1, month_supp_6_12_var=risk13_a_v3___1);
%merge_three(baseline_var=risk13_a___2, month_1_var=risk13_a_v2___2, month_supp_6_12_var=risk13_a_v3___2);
%merge_three(baseline_var=risk13_a___3, month_1_var=risk13_a_v2___3, month_supp_6_12_var=risk13_a_v3___3);
%merge_three(baseline_var=risk13_a___4, month_1_var=risk13_a_v2___4, month_supp_6_12_var=risk13_a_v3___4);
%merge_three(baseline_var=risk13_a___5, month_1_var=risk13_a_v2___5, month_supp_6_12_var=risk13_a_v3___5);
%merge_three(baseline_var=risk13_a___6, month_1_var=risk13_a_v2___6, month_supp_6_12_var=risk13_a_v3___6);
%merge_three(baseline_var=risk13_a___7, month_1_var=risk13_a_v2___7, month_supp_6_12_var=risk13_a_v3___7);
%merge_three(baseline_var=risk13_a___8, month_1_var=risk13_a_v2___8, month_supp_6_12_var=risk13_a_v3___8);
%merge_three(baseline_var=risk13_specify, month_1_var=risk13_specify_v2, month_supp_6_12_var=risk13_specify_v3);
%merge_three(baseline_var=prox_cannabis, month_1_var=prox_cannabis_v2, month_supp_6_12_var=prox_cannabis_v3);
%merge_three(baseline_var=prox_coke, month_1_var=prox_coke_v2, month_supp_6_12_var=prox_coke_v3);
%merge_three(baseline_var=prox_crack, month_1_var=prox_crack_v2, month_supp_6_12_var=prox_crack_v3);
%merge_three(baseline_var=prox_heroin, month_1_var=prox_heroin_v2, month_supp_6_12_var=prox_heroin_v3);
%merge_three(baseline_var=prox_meth, month_1_var=prox_meth_v2, month_supp_6_12_var=prox_meth_v3);
%merge_three(baseline_var=prox_hallu, month_1_var=prox_hallu_v2, month_supp_6_12_var=prox_hallu_v3);
%merge_three(baseline_var=prox_club, month_1_var=prox_club_v2, month_supp_6_12_var=prox_club_v3);
%merge_three(baseline_var=prox_club, month_1_var=prox_club_v2, month_supp_6_12_var=prox_club_v3);
%merge_three(baseline_var=prox_other, month_1_var=prox_other_v2, month_supp_6_12_var=prox_other_v3);
%merge_three(baseline_var=vp1, month_1_var=vp1_v2, month_supp_6_12_var=vp1_v3);
%merge_three(baseline_var=vp1, month_1_var=vp1_v2, month_supp_6_12_var=vp1_v3);
%merge_three(baseline_var=vp2, month_1_var=vp2_v2, month_supp_6_12_var=vp2_v3);
%merge_three(baseline_var=vp3___1, month_1_var=vp3_v2___1, month_supp_6_12_var=vp3_v3___1);
%merge_three(baseline_var=vp3___2, month_1_var=vp3_v2___2, month_supp_6_12_var=vp3_v3___2);
%merge_three(baseline_var=vp3___3, month_1_var=vp3_v2___3, month_supp_6_12_var=vp3_v3___3);
%merge_three(baseline_var=vp3___4, month_1_var=vp3_v2___4, month_supp_6_12_var=vp3_v3___4);
%merge_three(baseline_var=vp3___5, month_1_var=vp3_v2___5, month_supp_6_12_var=vp3_v3___5);
%merge_three(baseline_var=vp3___6, month_1_var=vp3_v2___6, month_supp_6_12_var=vp3_v3___6);
%merge_three(baseline_var=vp3___7, month_1_var=vp3_v2___7, month_supp_6_12_var=vp3_v3___7);
%merge_three(baseline_var=vp3___8, month_1_var=vp3_v2___8, month_supp_6_12_var=vp3_v3___8);
%merge_three(baseline_var=vp3___9, month_1_var=vp3_v2___9, month_supp_6_12_var=vp3_v3___9);
%merge_three(baseline_var=vp3_specify, month_1_var=vp3_specify_v2, month_supp_6_12_var=vp3_specify_v3);
%merge_three(baseline_var=vp4, month_1_var=vp4_v2, month_supp_6_12_var=vp4_v3);
%merge_three(baseline_var=vp10, month_1_var=vp10_v2, month_supp_6_12_var=vp10_v3);
%merge_three(baseline_var=vp11, month_1_var=vp11_v2, month_supp_6_12_var=vp11_v3);
%merge_three(baseline_var=vp15, month_1_var=vp15_v2, month_supp_6_12_var=vp15_v3);
%merge_three(baseline_var=vp16, month_1_var=vp16_v2, month_supp_6_12_var=vp16_v3);
%merge_three(baseline_var=vp19, month_1_var=vp19_v2, month_supp_6_12_var=vp19_v3);
%merge_three(baseline_var=vp20, month_1_var=vp20_v2, month_supp_6_12_var=vp20_v3);
%merge_three(baseline_var=vp23, month_1_var=vp23_v2, month_supp_6_12_var=vp23_v3);
%merge_three(baseline_var=vp24, month_1_var=vp24_v2, month_supp_6_12_var=vp24_v3);
%merge_three(baseline_var=vp30, month_1_var=vp30_v2, month_supp_6_12_var=vp30_v3);
%merge_three(baseline_var=vp31, month_1_var=vp31_v2, month_supp_6_12_var=vp31_v3);
%merge_three(baseline_var=vp34, month_1_var=vp34_v2, month_supp_6_12_var=vp34_v3);
%merge_three(baseline_var=vp35, month_1_var=vp35_v2, month_supp_6_12_var=vp35_v3);
%merge_three(baseline_var=vp35, month_1_var=vp35_v2, month_supp_6_12_var=vp35_v3);
%merge_three(baseline_var=vp39, month_1_var=vp39_v2, month_supp_6_12_var=vp39_v3);
%merge_three(baseline_var=vp39, month_1_var=vp39_v2, month_supp_6_12_var=vp39_v3);
%merge_three(baseline_var=vp40, month_1_var=vp40_v2, month_supp_6_12_var=vp40_v3);
%merge_three(baseline_var=vp43, month_1_var=vp43_v2, month_supp_6_12_var=vp43_v3);
%merge_three(baseline_var=vp44, month_1_var=vp44_v2, month_supp_6_12_var=vp44_v3);
%merge_three(baseline_var=vp44, month_1_var=vp44_v2, month_supp_6_12_var=vp44_v3);
%merge_three(baseline_var=vp53, month_1_var=vp53_v2, month_supp_6_12_var=vp53_v3);

%macro merge_two(baseline_var=, month_supp_6_12_var=);

if redcap_event_name="baseline_arm_1" then do;
&baseline_var._new=&baseline_var;
end;

if redcap_event_name="6_month_followup_arm_1" or redcap_event_name="supplemental_arm_1" or 
redcap_event_name="12_month_followup_arm_1" then do;
&baseline_var._new=&month_supp_6_12_var;
end;

drop &baseline_var &month_supp_6_12_var; 
rename &baseline_var._new=&baseline_var;

%mend;

%merge_two(baseline_var=medgyn1, month_supp_6_12_var=medgyn1_v3);
%merge_two(baseline_var=medgyn5, month_supp_6_12_var=medgyn5_v3);
%merge_two(baseline_var=medgyn1, month_supp_6_12_var=medgyn1_v3);	
%merge_two(baseline_var=medgyn5, month_supp_6_12_var=medgyn5_v3);	
%merge_two(baseline_var=medgyn7, month_supp_6_12_var=medgyn7_v3);	
%merge_two(baseline_var=medgyn8, month_supp_6_12_var=medgyn8_v3);	
%merge_two(baseline_var=medgyn23___1, month_supp_6_12_var=medgyn23_v3___1);	
%merge_two(baseline_var=medgyn23___2, month_supp_6_12_var=medgyn23_v3___2);	
%merge_two(baseline_var=medgyn23___3, month_supp_6_12_var=medgyn23_v3___3);	
%merge_two(baseline_var=medgyn23___4, month_supp_6_12_var=medgyn23_v3___4);	
%merge_two(baseline_var=medgyn23___5, month_supp_6_12_var=medgyn23_v3___5);	
%merge_two(baseline_var=medgyn23___6, month_supp_6_12_var=medgyn23_v3___6);	
%merge_two(baseline_var=medgyn23___7, month_supp_6_12_var=medgyn23_v3___7);	
%merge_two(baseline_var=medgyn23___8, month_supp_6_12_var=medgyn23_v3___8);	
%merge_two(baseline_var=medgyn23___9, month_supp_6_12_var=medgyn23_v3___9);	
%merge_two(baseline_var=medgyn23___10, month_supp_6_12_var=medgyn23_v3___10);	
%merge_two(baseline_var=risk12, month_supp_6_12_var=risk12_v3);	
%merge_two(baseline_var=risk14, month_supp_6_12_var=risk14_v3);	
%merge_two(baseline_var=risk15, month_supp_6_12_var=risk15_v3);	
%merge_two(baseline_var=risk16, month_supp_6_12_var=risk16_v3);	
%merge_two(baseline_var=risk17, month_supp_6_12_var=risk17_v3);	
%merge_two(baseline_var=risk18, month_supp_6_12_var=risk18_v3);	
%merge_two(baseline_var=vp12, month_supp_6_12_var=vp12_v3);	
%merge_two(baseline_var=vp13, month_supp_6_12_var=vp13_v3);	
%merge_two(baseline_var=vp14, month_supp_6_12_var=vp14_v3);	
%merge_two(baseline_var=vp17, month_supp_6_12_var=vp17_v3);	
%merge_two(baseline_var=vp18, month_supp_6_12_var=vp18_v3);	
%merge_two(baseline_var=vp21, month_supp_6_12_var=vp21_v3);	
%merge_two(baseline_var=vp22, month_supp_6_12_var=vp22_v3);	
%merge_two(baseline_var=vp25, month_supp_6_12_var=vp25_v3);	
%merge_two(baseline_var=vp26, month_supp_6_12_var=vp26_v3);	
%merge_two(baseline_var=vp32, month_supp_6_12_var=vp32_v3);	
%merge_two(baseline_var=vp33, month_supp_6_12_var=vp33_v3);	
%merge_two(baseline_var=vp36, month_supp_6_12_var=vp36_v3);	
%merge_two(baseline_var=vp37, month_supp_6_12_var=vp37_v3);	
%merge_two(baseline_var=vp38, month_supp_6_12_var=vp38_v3);	
%merge_two(baseline_var=vp41, month_supp_6_12_var=vp41_v3);	
%merge_two(baseline_var=vp42, month_supp_6_12_var=vp42_v3);	
%merge_two(baseline_var=vp45, month_supp_6_12_var=vp45_v3);	
%merge_two(baseline_var=vp46, month_supp_6_12_var=vp46_v3);	
%merge_two(baseline_var=vp50___1, month_supp_6_12_var=vp50_v3___1);	
%merge_two(baseline_var=vp50___2, month_supp_6_12_var=vp50_v3___2);	
%merge_two(baseline_var=vp50___3, month_supp_6_12_var=vp50_v3___3);	
%merge_two(baseline_var=vp50___4, month_supp_6_12_var=vp50_v3___4);	
%merge_two(baseline_var=vp50___5, month_supp_6_12_var=vp50_v3___5);	
%merge_two(baseline_var=vp50___6, month_supp_6_12_var=vp50_v3___6);	
%merge_two(baseline_var=vp51, month_supp_6_12_var=vp51_v3);	
%merge_two(baseline_var=vp52, month_supp_6_12_var=vp52_v3);	
%merge_two(baseline_var=vp53_specify, month_supp_6_12_var=vp53_specify_v3);	
%merge_two(baseline_var=interviewer_name, month_supp_6_12_var=interviewer_name_v2);	
%merge_two(baseline_var=date_today, month_supp_6_12_var=date_today_v2);	
%merge_two(baseline_var=dem8, month_supp_6_12_var=dem8_v2);	
%merge_two(baseline_var=dem9, month_supp_6_12_var=dem9_v2);	
%merge_two(baseline_var=dem10, month_supp_6_12_var=dem10_v2);

%merge_two(baseline_var=covid_1,  month_supp_6_12_var=covid_1_6mo);	
%merge_two(baseline_var=covid_2,  month_supp_6_12_var=covid_2_6mo);	
%merge_two(baseline_var=covid_4___1,  month_supp_6_12_var=covid_4_6mo___1);	
%merge_two(baseline_var=covid_4___2,  month_supp_6_12_var=covid_4_6mo___2);	
%merge_two(baseline_var=covid_4___3,  month_supp_6_12_var=covid_4_6mo___3);	
%merge_two(baseline_var=covid_4___4,  month_supp_6_12_var=covid_4_6mo___4);	
%merge_two(baseline_var=covid_4___5,  month_supp_6_12_var=covid_4_6mo___5);	
%merge_two(baseline_var=covid_4___6,  month_supp_6_12_var=covid_4_6mo___6);	
%merge_two(baseline_var=covid_5___1,  month_supp_6_12_var=covid_5_6mo___1);	
%merge_two(baseline_var=covid_5___2,  month_supp_6_12_var=covid_5_6mo___2);	
%merge_two(baseline_var=covid_5___3,  month_supp_6_12_var=covid_5_6mo___3);	
%merge_two(baseline_var=covid_5___4,  month_supp_6_12_var=covid_5_6mo___4);	
%merge_two(baseline_var=covid_5___5,  month_supp_6_12_var=covid_5_6mo___5);	
%merge_two(baseline_var=covid_5___6,  month_supp_6_12_var=covid_5_6mo___6);	
%merge_two(baseline_var=covid_12,  month_supp_6_12_var=covid_12_6mo);	
%merge_two(baseline_var=covid_13,  month_supp_6_12_var=covid_13_6mo);	
%merge_two(baseline_var=covid_14,  month_supp_6_12_var=covid_14_6mo);	
%merge_two(baseline_var=covid_15,  month_supp_6_12_var=covid_15_6mo);	
%merge_two(baseline_var=covid_16,  month_supp_6_12_var=covid_16_6mo);	
%merge_two(baseline_var=covid_17,  month_supp_6_12_var=covid_17_6mo);	
%merge_two(baseline_var=covid_19,  month_supp_6_12_var=covid_19_6mo);
%merge_two(baseline_var=covid_20,  month_supp_6_12_var=covid_20_6mo);	
%merge_two(baseline_var=covid_21,  month_supp_6_12_var=covid_21_6mo);
%merge_two(baseline_var=covid_22,  month_supp_6_12_var=covid_22_6mo);
%merge_two(baseline_var=covid_23,  month_supp_6_12_var=covid_23_6mo);
%merge_two(baseline_var=covid_24,  month_supp_6_12_var=covid_24_6mo);	
%merge_two(baseline_var=covid_25,  month_supp_6_12_var=covid_25_6mo);	
%merge_two(baseline_var=covid_26,  month_supp_6_12_var=covid_26_6mo);	
%merge_two(baseline_var=covid_27,  month_supp_6_12_var=covid_27_6mo);	
%merge_two(baseline_var=covid_28,  month_supp_6_12_var=covid_28_6mo);	
%merge_two(baseline_var=covid_29,  month_supp_6_12_var=covid_29_6mo);	
%merge_two(baseline_var=covid_30,  month_supp_6_12_var=covid_30_6mo);	
%merge_two(baseline_var=covid_31,  month_supp_6_12_var=covid_31_6mo);	
%merge_two(baseline_var=covid_32,  month_supp_6_12_var=covid_32_6mo);	
%merge_two(baseline_var=covid_33,  month_supp_6_12_var=covid_33_6mo);	
%merge_two(baseline_var=covid_34,  month_supp_6_12_var=covid_34_6mo);	
%merge_two(baseline_var=covid_35,  month_supp_6_12_var=covid_35_6mo);	
%merge_two(baseline_var=covid_36,  month_supp_6_12_var=covid_36_6mo);	
%merge_two(baseline_var=covid_37,  month_supp_6_12_var=covid_37_6mo);	
%merge_two(baseline_var=covid_38,  month_supp_6_12_var=covid_38_6mo);	
%merge_two(baseline_var=covid_39,  month_supp_6_12_var=covid_39_6mo);	
%merge_two(baseline_var=covid_40,  month_supp_6_12_var=covid_40_6mo);	
%merge_two(baseline_var=covid_41,  month_supp_6_12_var=covid_41_6mo);	
%merge_two(baseline_var=covid_42,  month_supp_6_12_var=covid_42_6mo);	
%merge_two(baseline_var=covid_43,  month_supp_6_12_var=covid_43_6mo);	
%merge_two(baseline_var=covid_44,  month_supp_6_12_var=covid_44_6mo);	
%merge_two(baseline_var=covid_45,  month_supp_6_12_var=covid_45_6mo);	
%merge_two(baseline_var=covid_46,  month_supp_6_12_var=covid_46_6mo);	
%merge_two(baseline_var=covid_47,  month_supp_6_12_var=covid_47_6mo);	
%merge_two(baseline_var=covid_48,  month_supp_6_12_var=covid_48_6mo);	
%merge_two(baseline_var=covid_49,  month_supp_6_12_var=covid_49_6mo);	
%merge_two(baseline_var=covid_50,  month_supp_6_12_var=covid_50_6mo);	
%merge_two(baseline_var=covid_51,  month_supp_6_12_var=covid_51_6mo);	
%merge_two(baseline_var=covid_52,  month_supp_6_12_var=covid_52_6mo);	
%merge_two(baseline_var=covid_53,  month_supp_6_12_var=covid_53_6mo);	
%merge_two(baseline_var=covid_54,  month_supp_6_12_var=covid_54_6mo);	
%merge_two(baseline_var=covid_55,  month_supp_6_12_var=covid_55_6mo);	
%merge_two(baseline_var=covid_56,  month_supp_6_12_var=covid_56_6mo);	
%merge_two(baseline_var=covid_57,  month_supp_6_12_var=covid_57_6mo);
%merge_two(baseline_var=covid_58,  month_supp_6_12_var=covid_58_6mo);	
%merge_two(baseline_var=covid_59,  month_supp_6_12_var=covid_59_6mo);	
%merge_two(baseline_var=covid_60,  month_supp_6_12_var=covid_60_6mo);	
%merge_two(baseline_var=covid_61,  month_supp_6_12_var=covid_61_6mo);	
%merge_two(baseline_var=covid_62,  month_supp_6_12_var=covid_62_6mo);	
%merge_two(baseline_var=covid_63,  month_supp_6_12_var=covid_63_6mo);	
%merge_two(baseline_var=covid_64,  month_supp_6_12_var=covid_64_6mo);	
%merge_two(baseline_var=covid_65,  month_supp_6_12_var=covid_65_6mo);	
%merge_two(baseline_var=covid_66,  month_supp_6_12_var=covid_66_6mo);	
%merge_two(baseline_var=covid_67,  month_supp_6_12_var=covid_67_6mo);	
%merge_two(baseline_var=covid_68,  month_supp_6_12_var=covid_68_6mo);	
%merge_two(baseline_var=covid_69,  month_supp_6_12_var=covid_69_6mo);	
%merge_two(baseline_var=covid_70,  month_supp_6_12_var=covid_70_6mo);	
%merge_two(baseline_var=covid_71,  month_supp_6_12_var=covid_71_6mo);	
%merge_two(baseline_var=covid_72,  month_supp_6_12_var=covid_72_6mo);	
%merge_two(baseline_var=covid_73,  month_supp_6_12_var=covid_73_6mo);	
%merge_two(baseline_var=covid_74,  month_supp_6_12_var=covid_74_6mo);	
%merge_two(baseline_var=covid_75,  month_supp_6_12_var=covid_75_6mo);	
%merge_two(baseline_var=covid_76,  month_supp_6_12_var=covid_76_6mo);	
%merge_two(baseline_var=covid_77,  month_supp_6_12_var=covid_77_6mo);	
%merge_two(baseline_var=covid_78,  month_supp_6_12_var=covid_78_6mo);	
%merge_two(baseline_var=covid_79,  month_supp_6_12_var=covid_79_6mo);	
%merge_two(baseline_var=covid_80,  month_supp_6_12_var=covid_80_6mo);	
%merge_two(baseline_var=covid_81,  month_supp_6_12_var=covid_81_6mo);	
%merge_two(baseline_var=covid_82,  month_supp_6_12_var=covid_82_6mo);
%merge_two(baseline_var=covid_83,  month_supp_6_12_var=covid_83_6mo);	
%merge_two(baseline_var=covid_84,  month_supp_6_12_var=covid_84_6mo);	
%merge_two(baseline_var=covid_85,  month_supp_6_12_var=covid_85_6mo);	
%merge_two(baseline_var=covid_86,  month_supp_6_12_var=covid_86_6mo);	
%merge_two(baseline_var=covid_87,  month_supp_6_12_var=covid_87_6mo);
%merge_two(baseline_var=covid_88,  month_supp_6_12_var=covid_88_6mo);	
%merge_two(baseline_var=covid_89,  month_supp_6_12_var=covid_89_6mo);	
%merge_two(baseline_var=covid_90,  month_supp_6_12_var=covid_90_6mo);	
%merge_two(baseline_var=covid_91,  month_supp_6_12_var=covid_91_6mo);	
%merge_two(baseline_var=covid_92,  month_supp_6_12_var=covid_92_6mo);	
%merge_two(baseline_var=covid_93,  month_supp_6_12_var=covid_93_6mo);	
%merge_two(baseline_var=covid_94,  month_supp_6_12_var=covid_94_6mo);	
%merge_two(baseline_var=covid_95,  month_supp_6_12_var=covid_95_6mo);	
%merge_two(baseline_var=covid_96,  month_supp_6_12_var=covid_96_6mo);	
%merge_two(baseline_var=covid_97,  month_supp_6_12_var=covid_97_6mo);	
%merge_two(baseline_var=covid_98,  month_supp_6_12_var=covid_98_6mo);	
%merge_two(baseline_var=covid_99,  month_supp_6_12_var=covid_99_6mo);
%merge_two(baseline_var=covid_100,  month_supp_6_12_var=covid_100_6mo);	
%merge_two(baseline_var=covid_101,  month_supp_6_12_var=covid_101_6mo);	
%merge_two(baseline_var=covid_102,  month_supp_6_12_var=covid_102_6mo);	
%merge_two(baseline_var=covid_103,  month_supp_6_12_var=covid_103_6mo);	
%merge_two(baseline_var=covid_104,  month_supp_6_12_var=covid_104_6mo);	
%merge_two(baseline_var=covid_106,  month_supp_6_12_var=covid_106_6mo);	
%merge_two(baseline_var=covid_107,  month_supp_6_12_var=covid_107_6mo);	
%merge_two(baseline_var=covid_108,  month_supp_6_12_var=covid_108_6mo);	
%merge_two(baseline_var=covid_109,  month_supp_6_12_var=covid_109_6mo);	
%merge_two(baseline_var=covid_110,  month_supp_6_12_var=covid_110_6mo);	
%merge_two(baseline_var=covid_111,  month_supp_6_12_var=covid_111_6mo);	
%merge_two(baseline_var=covid_112,  month_supp_6_12_var=covid_112_6mo);	
%merge_two(baseline_var=covid_113,  month_supp_6_12_var=covid_113_6mo);	
%merge_two(baseline_var=covid_115,  month_supp_6_12_var=covid_115_6mo);	
%merge_two(baseline_var=covid_116,  month_supp_6_12_var=covid_116_6mo);	
%merge_two(baseline_var=covid_117,  month_supp_6_12_var=covid_117_6mo);	
%merge_two(baseline_var=covid_118,  month_supp_6_12_var=covid_118_6mo);	
%merge_two(baseline_var=covid_119,  month_supp_6_12_var=covid_119_6mo);	
%merge_two(baseline_var=covid_120,  month_supp_6_12_var=covid_120_6mo);
%merge_two(baseline_var=covid_121,  month_supp_6_12_var=covid_121_6mo);	
%merge_two(baseline_var=covid_122,  month_supp_6_12_var=covid_122_6mo);	
%merge_two(baseline_var=covid_123,  month_supp_6_12_var=covid_123_6mo);	
%merge_two(baseline_var=covid_124,  month_supp_6_12_var=covid_124_6mo);	
%merge_two(baseline_var=covid_125,  month_supp_6_12_var=covid_125_6mo);	
%merge_two(baseline_var=covid_126,  month_supp_6_12_var=covid_126_6mo);	
%merge_two(baseline_var=covid_127,  month_supp_6_12_var=covid_127_6mo);	
%merge_two(baseline_var=covid_128,  month_supp_6_12_var=covid_128_6mo);	
%merge_two(baseline_var=covid_129,  month_supp_6_12_var=covid_129_6mo);	
%merge_two(baseline_var=covid_130,  month_supp_6_12_var=covid_130_6mo);	
%merge_two(baseline_var=covid_131,  month_supp_6_12_var=covid_131_6mo);	
%merge_two(baseline_var=covid_132,  month_supp_6_12_var=covid_132_6mo);	
%merge_two(baseline_var=covid_133,  month_supp_6_12_var=covid_133_6mo);	
%merge_two(baseline_var=covid_134,  month_supp_6_12_var=covid_134_6mo);	
%merge_two(baseline_var=covid_135,  month_supp_6_12_var=covid_135_6mo);	
%merge_two(baseline_var=covid_136,  month_supp_6_12_var=covid_136_6mo);	
%merge_two(baseline_var=covid_137,  month_supp_6_12_var=covid_137_6mo);	
%merge_two(baseline_var=covid_138,  month_supp_6_12_var=covid_138_6mo);	
%merge_two(baseline_var=covid_139,  month_supp_6_12_var=covid_139_6mo);	
%merge_two(baseline_var=covid_140,  month_supp_6_12_var=covid_140_6mo);	
%merge_two(baseline_var=covid_141,  month_supp_6_12_var=covid_141_6mo);	
%merge_two(baseline_var=covid_142,  month_supp_6_12_var=covid_142_6mo);	
%merge_two(baseline_var=covid_143,  month_supp_6_12_var=covid_143_6mo);	
%merge_two(baseline_var=covid_144,  month_supp_6_12_var=covid_144_6mo);	
%merge_two(baseline_var=covid_145,  month_supp_6_12_var=covid_145_6mo);	
%merge_two(baseline_var=covid_146,  month_supp_6_12_var=covid_146_6mo);	
%merge_two(baseline_var=covid_147,  month_supp_6_12_var=covid_147_6mo);	
%merge_two(baseline_var=covid_148,  month_supp_6_12_var=covid_148_6mo);	
%merge_two(baseline_var=covid_149,  month_supp_6_12_var=covid_149_6mo);	
%merge_two(baseline_var=covid_150,  month_supp_6_12_var=covid_150_6mo);	
%merge_two(baseline_var=covid_151,  month_supp_6_12_var=covid_151_6mo);	
%merge_two(baseline_var=covid_152,  month_supp_6_12_var=covid_152_6mo);	
%merge_two(baseline_var=covid_153,  month_supp_6_12_var=covid_153_6mo);	
%merge_two(baseline_var=covid_154,  month_supp_6_12_var=covid_154_6mo);	
%merge_two(baseline_var=covid_155,  month_supp_6_12_var=covid_155_6mo);	
%merge_two(baseline_var=covid_156,  month_supp_6_12_var=covid_156_6mo);	
%merge_two(baseline_var=covid_157,  month_supp_6_12_var=covid_157_6mo);	
%merge_two(baseline_var=covid_158,  month_supp_6_12_var=covid_158_6mo);	
%merge_two(baseline_var=covid_159,  month_supp_6_12_var=covid_159_6mo);	
%merge_two(baseline_var=covid_160,  month_supp_6_12_var=covid_160_6mo);	
%merge_two(baseline_var=covid_161,  month_supp_6_12_var=covid_161_6mo);	
%merge_two(baseline_var=covid_162,  month_supp_6_12_var=covid_162_6mo);	
%merge_two(baseline_var=covid_163,  month_supp_6_12_var=covid_163_6mo);	
%merge_two(baseline_var=covid_164,  month_supp_6_12_var=covid_164_6mo);	
%merge_two(baseline_var=covid_165,  month_supp_6_12_var=covid_165_6mo);	
%merge_two(baseline_var=covid_166,  month_supp_6_12_var=covid_166_6mo);	
%merge_two(baseline_var=covid_167,  month_supp_6_12_var=covid_167_6mo);	
%merge_two(baseline_var=covid_168,  month_supp_6_12_var=covid_168_6mo);	
%merge_two(baseline_var=covid_169,  month_supp_6_12_var=covid_169_6mo);	
%merge_two(baseline_var=covid_170,  month_supp_6_12_var=covid_170_6mo);	
%merge_two(baseline_var=covid_171,  month_supp_6_12_var=covid_171_6mo);	
%merge_two(baseline_var=covid_172,  month_supp_6_12_var=covid_172_6mo);	
%merge_two(baseline_var=covid_173,  month_supp_6_12_var=covid_173_6mo);	
%merge_two(baseline_var=covid_174,  month_supp_6_12_var=covid_174_6mo);	
%merge_two(baseline_var=covid_175,  month_supp_6_12_var=covid_175_6mo);	
%merge_two(baseline_var=covid_176,  month_supp_6_12_var=covid_176_6mo);	
%merge_two(baseline_var=covid_177,  month_supp_6_12_var=covid_177_6mo);	
%merge_two(baseline_var=covid_179,  month_supp_6_12_var=covid_179_6mo);	
%merge_two(baseline_var=covid_180,  month_supp_6_12_var=covid_180_6mo);	
%merge_two(baseline_var=covid_181,  month_supp_6_12_var=covid_181_6mo);	
%merge_two(baseline_var=covid_182,  month_supp_6_12_var=covid_182_6mo);	
%merge_two(baseline_var=covid_183,  month_supp_6_12_var=covid_183_6mo);	
%merge_two(baseline_var=covid_184,  month_supp_6_12_var=covid_184_6mo);	
%merge_two(baseline_var=covid_185,  month_supp_6_12_var=covid_185_6mo);	
%merge_two(baseline_var=covid_186,  month_supp_6_12_var=covid_186_6mo);	
%merge_two(baseline_var=covid_187,  month_supp_6_12_var=covid_187_6mo);	
%merge_two(baseline_var=covid_189,  month_supp_6_12_var=covid_189_6mo);	
%merge_two(baseline_var=covid_192,  month_supp_6_12_var=covid_192_6mo);	
%merge_two(baseline_var=covid_193,  month_supp_6_12_var=covid_193_6mo);	
%merge_two(baseline_var=covid_194,  month_supp_6_12_var=covid_194_6mo);	
%merge_two(baseline_var=covid_195,  month_supp_6_12_var=covid_195_6mo);	
%merge_two(baseline_var=covid_196,  month_supp_6_12_var=covid_196_6mo);	
%merge_two(baseline_var=covid_197,  month_supp_6_12_var=covid_197_6mo);	
%merge_two(baseline_var=covid_198,  month_supp_6_12_var=covid_198_6mo);	
%merge_two(baseline_var=covid_199,  month_supp_6_12_var=covid_199_6mo);	
%merge_two(baseline_var=covid_200,  month_supp_6_12_var=covid_200_6mo);	
%merge_two(baseline_var=covid_203,  month_supp_6_12_var=covid_203_6mo);	
%merge_two(baseline_var=covid_204,  month_supp_6_12_var=covid_204_6mo);	
%merge_two(baseline_var=covid_205,  month_supp_6_12_var=covid_205_6mo);	
%merge_two(baseline_var=covid_206,  month_supp_6_12_var=covid_206_6mo);	
%merge_two(baseline_var=covid_207,  month_supp_6_12_var=covid_207_6mo);	
%merge_two(baseline_var=covid_208,  month_supp_6_12_var=covid_208_6mo);	
%merge_two(baseline_var=covid_209,  month_supp_6_12_var=covid_209_6mo);	
%merge_two(baseline_var=covid_210,  month_supp_6_12_var=covid_210_6mo);	
%merge_two(baseline_var=covid_211,  month_supp_6_12_var=covid_211_6mo);	
%merge_two(baseline_var=covid_212,  month_supp_6_12_var=covid_212_6mo);	
%merge_two(baseline_var=covid_213,  month_supp_6_12_var=covid_213_6mo);	
%merge_two(baseline_var=covid_214,  month_supp_6_12_var=covid_214_6mo);	
%merge_two(baseline_var=covid_215,  month_supp_6_12_var=covid_215_6mo);	
%merge_two(baseline_var=covid_216,  month_supp_6_12_var=covid_216_6mo);	
%merge_two(baseline_var=covid_217,  month_supp_6_12_var=covid_217_6mo);	
%merge_two(baseline_var=covid_218,  month_supp_6_12_var=covid_218_6mo);	
%merge_two(baseline_var=covid_219,  month_supp_6_12_var=covid_219_6mo);	
%merge_two(baseline_var=covid_220,  month_supp_6_12_var=covid_220_6mo);	
%merge_two(baseline_var=covid_221,  month_supp_6_12_var=covid_221_6mo);	
%merge_two(baseline_var=covid_222,  month_supp_6_12_var=covid_222_6mo);	
%merge_two(baseline_var=covid_223,  month_supp_6_12_var=covid_223_6mo);	
%merge_two(baseline_var=covid_224,  month_supp_6_12_var=covid_224_6mo);	
%merge_two(baseline_var=covid_225,  month_supp_6_12_var=covid_225_6mo);	
%merge_two(baseline_var=covid_226,  month_supp_6_12_var=covid_226_6mo);	
%merge_two(baseline_var=covid_227,  month_supp_6_12_var=covid_227_6mo);	
%merge_two(baseline_var=covid_228,  month_supp_6_12_var=covid_228_6mo);	
%merge_two(baseline_var=covid_229,  month_supp_6_12_var=covid_229_6mo);	
%merge_two(baseline_var=covid_230,  month_supp_6_12_var=covid_230_6mo);	
%merge_two(baseline_var=covid_231,  month_supp_6_12_var=covid_231_6mo);	
%merge_two(baseline_var=covid_232,  month_supp_6_12_var=covid_232_6mo);	
%merge_two(baseline_var=covid_233,  month_supp_6_12_var=covid_233_6mo);	
%merge_two(baseline_var=covid_234,  month_supp_6_12_var=covid_234_6mo);	
%merge_two(baseline_var=covid_235,  month_supp_6_12_var=covid_235_6mo);	
%merge_two(baseline_var=covid_236,  month_supp_6_12_var=covid_236_6mo);	
%merge_two(baseline_var=covid_238,  month_supp_6_12_var=covid_238_6mo);	
%merge_two(baseline_var=covid_239,  month_supp_6_12_var=covid_239_6mo);	
%merge_two(baseline_var=covid_240,  month_supp_6_12_var=covid_240_6mo);	
%merge_two(baseline_var=covid_241,  month_supp_6_12_var=covid_241_6mo);	
%merge_two(baseline_var=covid_242,  month_supp_6_12_var=covid_242_6mo);	
%merge_two(baseline_var=covid_243,  month_supp_6_12_var=covid_243_6mo);	
%merge_two(baseline_var=covid_244,  month_supp_6_12_var=covid_244_6mo);	
%merge_two(baseline_var=covid_245,  month_supp_6_12_var=covid_245_6mo);	
%merge_two(baseline_var=covid_246,  month_supp_6_12_var=covid_246_6mo);	
%merge_two(baseline_var=covid_247,  month_supp_6_12_var=covid_247_6mo);	
%merge_two(baseline_var=covid_248,  month_supp_6_12_var=covid_248_6mo);	
%merge_two(baseline_var=covid_249,  month_supp_6_12_var=covid_249_6mo);	
%merge_two(baseline_var=covid_250,  month_supp_6_12_var=covid_250_6mo);	
%merge_two(baseline_var=covid_251,  month_supp_6_12_var=covid_251_6mo);	
%merge_two(baseline_var=covid_252,  month_supp_6_12_var=covid_252_6mo);	
%merge_two(baseline_var=covid_253,  month_supp_6_12_var=covid_253_6mo);	
%merge_two(baseline_var=covid_254,  month_supp_6_12_var=covid_254_6mo);	
%merge_two(baseline_var=covid_255,  month_supp_6_12_var=covid_255_6mo);	
%merge_two(baseline_var=covid_256,  month_supp_6_12_var=covid_256_6mo);	
%merge_two(baseline_var=covid_257,  month_supp_6_12_var=covid_257_6mo);	
%merge_two(baseline_var=covid_258,  month_supp_6_12_var=covid_258_6mo);	
%merge_two(baseline_var=covid_259,  month_supp_6_12_var=covid_259_6mo);	
%merge_two(baseline_var=covid_260,  month_supp_6_12_var=covid_260_6mo);	
%merge_two(baseline_var=covid_261,  month_supp_6_12_var=covid_261_6mo);	
%merge_two(baseline_var=covid_262,  month_supp_6_12_var=covid_262_6mo);	
%merge_two(baseline_var=covid_263,  month_supp_6_12_var=covid_263_6mo);	
%merge_two(baseline_var=covid_264,  month_supp_6_12_var=covid_264_6mo);	
%merge_two(baseline_var=covid_265,  month_supp_6_12_var=covid_265_6mo);	
%merge_two(baseline_var=covid_266,  month_supp_6_12_var=covid_266_6mo);	
%merge_two(baseline_var=covid_267,  month_supp_6_12_var=covid_267_6mo);	
%merge_two(baseline_var=covid_268,  month_supp_6_12_var=covid_268_6mo);	

%macro merge_two_v2(month_1_var=, month_supp_6_12_var=);

if redcap_event_name="1_month_followup_arm_1" then do;
&month_1_var._new=&month_1_var;
end;

if redcap_event_name="6_month_followup_arm_1" or redcap_event_name="supplemental_arm_1" or 
redcap_event_name="12_month_followup_arm_1" then do;
&month_1_var._new=&month_supp_6_12_var;
end;

drop &month_1_var &month_supp_6_12_var; 
rename &month_1_var._new=&month_1_var;

%mend;

%merge_two_v2(month_1_var=medgyn30_v2, month_supp_6_12_var=medgyn29_v3);
%merge_two_v2(month_1_var=medgyn30_specify_v2, month_supp_6_12_var=medgyn29_v3_specify);

run;

****;

proc sort data=whims_clean_v3;
by record_ID redcap_event_name phys_date;
run;

***********************
***CODING RECURRENCE***
***********************
;

%macro dataset(var=);
data w_&var;
set whims_clean_v3 (rename=(BV_combined=BV_&var phys_date=Date_&var chlamydia_num=CH_&var gonorrhea_num=GO_&var trichomonas_num=TR_&var));
if redcap_event_name~="&var" then DELETE;

if (CH_&var=1 or GO_&var=1 or TR_&var=1) and Date_&var>21802 and Date_&var<22131
	then EOS_&var="END OF STUDY"; *IF CHLAMYDIA, GONORRHEA, TRICH + AFTER 09/10/2019 AND BEFORE 08/04/2020 THEN NOT ENROLLED;
else if (CH_&var=1 or GO_&var=1) and Date_&var>22131 
	then EOS_&var="END OF STUDY"; *IF CHLAMYDIA, GONORRHEA + AFTER 08/04/2020 THEN NOT ENROLLED;
else EOS_&var="COMPLETED";

keep record_ID BV_&var Date_&var CH_&var GO_&var TR_&var EOS_&var;
run;

proc sort data=w_&var;
by record_ID;
run;
%mend;

%dataset(var=1_month_followup_arm_1);
%dataset(var=supplemental_arm_1);
%dataset(var=6_month_followup_arm_1);
%dataset(var=12_month_followup_arm_1);

data w_baseline_arm_1;
set whims_clean_v3 (rename=(BV_combined=BV_baseline_arm_1 phys_date=Date_baseline_arm_1 
chlamydia_num=CH_baseline_arm_1 gonorrhea_num=GO_baseline_arm_1 trichomonas_num=TR_baseline_arm_1));
if redcap_event_name~="baseline_arm_1" then DELETE;

if (CH_baseline_arm_1=1 or GO_baseline_arm_1=1 or TR_baseline_arm_1=1) and Date_baseline_arm_1>21802 and Date_baseline_arm_1<22131
	then EOS_baseline_arm_1="END OF STUDY"; *IF CHLAMYDIA, GONORRHEA, TRICH + AFTER 09/10/2019 AND BEFORE 08/04/2020 THEN NOT ENROLLED;
else if (CH_baseline_arm_1=1 or GO_baseline_arm_1=1) and Date_baseline_arm_1>22131 
	then EOS_baseline_arm_1="END OF STUDY"; *IF CHLAMYDIA, GONORRHEA + AFTER 08/04/2020 THEN NOT ENROLLED;
else EOS_baseline_arm_1="COMPLETED";

keep record_ID enrolled BV_baseline_arm_1 Date_baseline_arm_1 CH_baseline_arm_1 GO_baseline_arm_1 TR_baseline_arm_1 EOS_baseline_arm_1;
run; 
proc sort data=w_baseline_arm_1;
by record_ID;
run;

data WHIMS_wide;
merge w_baseline_arm_1 (in=a) w_1_month_followup_arm_1 w_supplemental_arm_1 w_6_month_followup_arm_1 w_12_month_followup_arm_1;
by record_ID;
if a;
run;

proc datasets library=work;
delete w_baseline_arm_1 w_1_month_followup_arm_1 w_supplemental_arm_1 w_6_month_followup_arm_1 w_12_month_followup_arm_1;
run;

*ONLY ENROLLED + CONTROLS;
data WHIMS_wide_BV;
retain record_ID enrolled BV_baseline_arm_1 Date_baseline_arm_1 BV_supplemental_arm_1 Date_supplemental_arm_1 BV_1_month_followup_arm_1 
Date_1_month_followup_arm_1 BV_6_month_followup_arm_1 Date_6_month_followup_arm_1 BV_12_month_followup_arm_1 Date_12_month_followup_arm_1
CH_baseline_arm_1 GO_baseline_arm_1 TR_baseline_arm_1
CH_1_month_followup_arm_1 GO_1_month_followup_arm_1 TR_1_month_followup_arm_1
CH_supplemental_arm_1 GO_supplemental_arm_1 TR_supplemental_arm_1
CH_6_month_followup_arm_1 GO_6_month_followup_arm_1 TR_6_month_followup_arm_1
CH_12_month_followup_arm_1 GO_12_month_followup_arm_1 TR_12_month_followup_arm_1
EOS_baseline_arm_1 EOS_supplemental_arm_1 EOS_1_month_followup_arm_1 EOS_6_month_followup_arm_1
EOS_12_month_followup_arm_1;
set WHIMS_wide;
if enrolled="Screen Failure" then DELETE;
proc sort data=WHIMS_wide_BV;
by enrolled record_ID;
run;

*ENROLLED WHO COMPLETED T0, T1, and T2;
data WHIMS_wide_BV_COMPLETE;
retain record_ID enrolled BV_baseline_arm_1 Date_baseline_arm_1 BV_supplemental_arm_1 Date_supplemental_arm_1 BV_1_month_followup_arm_1 
Date_1_month_followup_arm_1 BV_6_month_followup_arm_1 Date_6_month_followup_arm_1 BV_12_month_followup_arm_1 Date_12_month_followup_arm_1;
set WHIMS_wide;
if BV_baseline_arm_1=. or BV_1_month_followup_arm_1=. or BV_6_month_followup_arm_1=. then DELETE;
if enrolled="Screen Failure" then DELETE;
run;

*ENROLLED WHO COMPLETED T0, T1, SP, and T2;
data WHIMS_wide_BV_wSP_COMPLETE;
retain record_ID enrolled BV_baseline_arm_1 Date_baseline_arm_1 BV_supplemental_arm_1 Date_supplemental_arm_1 BV_1_month_followup_arm_1 
Date_1_month_followup_arm_1 BV_supplemental_arm_1 Date_supplemental_arm_1 BV_6_month_followup_arm_1 Date_6_month_followup_arm_1 BV_12_month_followup_arm_1 Date_12_month_followup_arm_1;
set WHIMS_wide;
if BV_baseline_arm_1=. or BV_1_month_followup_arm_1=. or BV_supplemental_arm_1~=. or BV_6_month_followup_arm_1=. then DELETE;
if enrolled="Screen Failure" then DELETE;
run;

*CONTROL WHO COMPLETED T0 and T2;
data WHIMS_wide_CONTROL_COMPLETE;
retain record_ID enrolled BV_baseline_arm_1 Date_baseline_arm_1 BV_6_month_followup_arm_1 Date_6_month_followup_arm_1;
set WHIMS_wide;
if BV_baseline_arm_1=. or BV_6_month_followup_arm_1=. then DELETE;
if enrolled~="Enrolled - Control" then DELETE;
keep record_ID enrolled BV_baseline_arm_1 Date_baseline_arm_1 BV_6_month_followup_arm_1 Date_6_month_followup_arm_1;
run;

*ENROLLED WHO MISSED A T1 OR T2;
data WHIMS_wide_BV_DNF;
retain record_ID enrolled BV_baseline_arm_1 Date_baseline_arm_1 BV_supplemental_arm_1 Date_supplemental_arm_1 BV_1_month_followup_arm_1 
Date_1_month_followup_arm_1 BV_6_month_followup_arm_1 Date_6_month_followup_arm_1 BV_12_month_followup_arm_1 Date_12_month_followup_arm_1;
set WHIMS_wide;
if BV_1_month_followup_arm_1 in(0,1) and BV_6_month_followup_arm_1 in(0,1) then DELETE;
if enrolled~="Enrolled - BV" then DELETE;

Days_from_baseline=today()-Date_baseline_arm_1;

length Eligibility_1mo $ 30;
length Eligibility_6mo $ 30;
if Date_1_month_followup_arm_1~=. then Eligibility_1mo="COMPLETED";
else if Date_1_month_followup_arm_1=. then do;
if today()-Date_baseline_arm_1<32 then Eligibility_1mo="YES, STILL UNDER WINDOW";
else Eligibility_1mo="NO, OUT OF WINDOW";
end;

if Date_6_month_followup_arm_1~=. then Eligibility_6mo="COMPLETED";
else if Date_6_month_followup_arm_1=. then do;
if today()-Date_baseline_arm_1<210 then Eligibility_6mo="YES, STILL UNDER WINDOW";
else Eligibility_6mo="NO, OUT OF WINDOW";
end;

max_1_window=Date_baseline_arm_1+35;
max_6_window=Date_baseline_arm_1+210;

if Date_1_month_followup_arm_1>max_1_window then T1_Deviation="T1 - Deviation";
else if today()>max_1_window then T1_Deviation="T1 - Deviation";

if Date_6_month_followup_arm_1>max_6_window then T2_Deviation="T2 - Deviation";
else if today()>max_6_window then T2_Deviation="T2 - Deviation";

if Date_1_month_followup_arm_1~=. and BV_1_month_followup_arm_1=1 then max_s_window=Date_1_month_followup_arm_1+30;
if Date_supplemental_arm_1>max_s_window then S_Deviation="Supplemental Visit - Deviation";
if Date_supplemental_arm_1=. and max_s_window~=. then S_Deviation="Supplemental Visit - Deviation";

format max_1_window max_6_window max_s_window mmddyy10.;

run;

*CONTROL WHO MISSED A T2;
data WHIMS_wide_CONTROL_DNF;
retain record_ID enrolled BV_baseline_arm_1 Date_baseline_arm_1 BV_6_month_followup_arm_1 Date_6_month_followup_arm_1;
set WHIMS_wide;
if BV_6_month_followup_arm_1 in(0,1) then DELETE;
if enrolled~="Enrolled - Control" then DELETE;
Days_from_baseline=today()-Date_baseline_arm_1;
if today()-Date_baseline_arm_1<210 then ELIGIBILITY="YES, STILL UNDER WINDOW";
else ELIGIBILITY="NO, OUT OF WINDOW";

max_6_window=Date_baseline_arm_1+210;
format max_6_window mmddyy10.;
keep record_ID enrolled 
BV_baseline_arm_1 Date_baseline_arm_1 
BV_6_month_followup_arm_1 Date_6_month_followup_arm_1 Days_from_baseline ELIGIBILITY max_6_window;
run;

***END PRIOR TO HERE***;

***************
***PSA & IVP***
***************
;
data whims_psa;
set whims_clean_v3;
if redcap_event_name~="baseline_arm_1" then DELETE;
if risk3~=. and phys_date~=. then do;
if phys_date-risk3<=3 then sex_3d=1;  /*condomless sex within 3 day*/
else if phys_date-risk3>3 then sex_3d=0;

if phys_date-risk3<=1 then sex_1d=1;  /*condomless sex within 3 day*/
else if phys_date-risk3>1 then sex_1d=0;

end;

if vp2~=. and phys_date~=. then do;
if phys_date-vp2<=3 then ivp_3d=1;
else if phys_date-vp2>3 then ivp_3d=0;
end;

/*Third, Nugent (nugent_lab) coded into positive (Nugent score 7 or above) or negative. */
if nugent_lab>=7 then Bin_nugent_lab=1;
else if 0<=nugent_lab<7 then Bin_nugent_lab=0;

/*Then, can create this variable: (1) Nugent+Amsel+, (2) Nugent-Amsel-, (3) Nugent+Amsel-, (3) Nugent-Amsel+*/
Cat_Nugent_Amsel=catx("_", Bin_nugent_lab, amsel_lab);

/*1 = Clinical and Lab confirmed; 3 = Lab Confirmed; 4 = Clinical Confirmed --> 1,3,4 = BV+*/
/**/
/*Pan in SAS this is coded as BV (for clinical, lab, or both confirmed as categories). Would code a new BV variable as IF 1,3,4 then BV+*/
if Bin_nugent_lab ne . and  amsel_lab ne . then do ;
	if Bin_nugent_lab = 0 and amsel_lab=0 then Bin_BV_CLconfim=0;
    else  Bin_BV_CLconfim=1;
	end;

format vp2 risk3 mmddyy10.;
run;


proc sort data=whims_psa;
by risk5;
run;

proc freq data=whims_psa;
/*by risk5;*/
tables risk5 sex_3d sex_1d sex_3d*risk3 Cat_Nugent_Amsel Bin_BV_CLconfim ivp_3d;
/*where risk5=3;*/
run; 
/*60 women has 3 day condomless sex within 3 day and 29 within 1 day*/





*PSA 3 days: https://pubmed.ncbi.nlm.nih.gov/24237835/;

proc freq data=whims_psa;
table psa_lab /*Prostate Specific Antigen Result*/ 
risk5 /*When you had vaginal intercourse in the last month, how many times did your male partner use a male condom or any type of protection?*/
vp1
ivp_3d
sex_3d*psa_lab
ivp_3d*psa_lab medgyn0
nugent_lab
discharge_lab
clue_cell_lab
whiff_lab
ph_lab

;
run;

proc print data=whims_psa;
var risk3 phys_date sex_3d;
run;

proc print data=whims_psa;
var vp2 phys_date ivp_3d;
run;

proc logistic data = whims_psa descending;
	model 	psa_lab = sex_3d ivp_3d;
run;
