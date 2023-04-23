


/*1. PSA VS IVP_3D*/

PROC FREQ DATA=WHIMS_PSA(where=(risk5=3));
TABLES 

/*risk5*/
/*SEX_3D SEX_1D*/


PSA_LAB*IVP_3D
SEX_3D*IVP_3D
SEX_1D*IVP_3D

PSA_LAB*(SEX_3D SEX_1D vp3___1-vp3___9)


vp3___1-vp3___9

IVP_3D*(vp3___1-vp3___9)

/CHISQ
;
RUN;

proc sort data=whims_psa;
by Bin_nugent_lab;
run;
PROC FREQ DATA=WHIMS_PSA;
TABLES 
/*risk5*/
/*SEX_3D SEX_1D*/
/**/
/*PSA_LAB*IVP_3D*/
/*SEX_3D*IVP_3D*/
/*SEX_1D*IVP_3D*/


/*risk5**/
/*PSA_LAB*(SEX_3D SEX_1D vp3___1-vp3___9)*/
/**/
/**/
/*vp3___1-vp3___9*/

/*Bin_nugent_lab*IVP_1D*(*/
/*discharge_lab*/
/*clue_cell_lab*/
/*whiff_lab*/
/*ph_lab)*/
/**/
/**/
/*amsel_lab*/
/*nugent_lab*/
/*Bin_nugent_lab*/
/**/
/*amsel_lab*Bin_nugent_lab*/


Cat_Nugent_Amsel
IVP_3D*Cat_Nugent_Amsel

Bin_BV_CLconfim*(ivp_3d)


/CHISQ
;
RUN;




PROC FREQ DATA=WHIMS_PSA(where=(Bin_nugent_lab=1 or amsel_lab=1));
TABLES 
/*risk5*/
/*SEX_3D SEX_1D*/
/**/
/*PSA_LAB*IVP_3D*/
/*SEX_3D*IVP_3D*/
/*SEX_1D*IVP_3D*/


/*risk5**/
/*PSA_LAB*(SEX_3D SEX_1D vp3___1-vp3___9)*/
/**/
/**/
/*vp3___1-vp3___9*/

/*Bin_nugent_lab*IVP_1D*(*/
/*discharge_lab*/
/*clue_cell_lab*/
/*whiff_lab*/
/*ph_lab)*/
/**/
/**/
/*amsel_lab*/
/*nugent_lab*/
/*Bin_nugent_lab*/
/**/
/*amsel_lab*Bin_nugent_lab*/


Cat_Nugent_Amsel
IVP_3D*Cat_Nugent_Amsel

Bin_BV_CLconfim*(ivp_3d)


/CHISQ
;
RUN;




/**for paper results*/

ods rtf file="C:\Users\panyue\Box\WHIMS Data (From Alejandro, added 2.16.22)\WHIMS Data - Papers\PSA and GYN Measures\Results\freq.rtf";


title"for women who never use condom with male partners, compare the following ivp occus after or same day of condomeless sex across (1) PSA positive vs. Negative, (2) self-report positive vs. Negative, and 3) the four PSA/self-report categories";
PROC FREQ DATA=WHIMS_PSA(where=(risk5=3)) ;
TABLES 

PSA_LAB
SEX_3D 
SEX_1D
vp3___1-vp3___9

PSA_LAB*Bin_Sex_ivp
SEX_3D*Bin_Sex_ivp
SEX_1D*Bin_Sex_ivp
Cat_PSA_sex3d*Bin_Sex_ivp
Cat_PSA_sex1d*Bin_Sex_ivp

Bin_Sex_ivp*(vp3___1-vp3___9)

/CHISQ;

label Bin_Sex_ivp = "ivp occus after or same day of condomeless sex"
	  sex_3d="condomless sex within 3 days of PSA"
	  sex_1d="condomless sex within 1 days of PSA"
	  Cat_PSA_sex3d="PSA and condomless sex within 3 days category"
	  Cat_PSA_sex1d="PSA and condomless sex within 1 days category"


	vp3___1 ="Vaginal douches (commercial douches- from the store)"
	vp3___2	="Water alone"
	vp3___3	="Fingers"
	vp3___4	="Soap or soap with water"
	vp3___5	="A cloth or a rag or wipes"
	vp3___6 ="Vinegar"
	vp3___7 ="Yogurt"
	vp3___8	="Herbs or traditional medicines from another country"
	vp3___9	="Other product"

;
RUN;




title"For Nugent+or Amsel+ Sample Only (N=216), comparing IVP in the past 3 days (IVP in the past 3 days)";
PROC FREQ DATA=WHIMS_PSA(where=(Bin_nugent_lab=1 or amsel_lab=1));
TABLES 

Bin_nugent_lab
amsel_lab
Cat_Nugent_Amsel
Bin_BV_AMSEL_concord
discharge_lab
clue_cell_lab
whiff_lab
ph_lab

ivp_3d*(Bin_nugent_lab
amsel_lab
Cat_Nugent_Amsel
Bin_BV_AMSEL_concord
discharge_lab
clue_cell_lab
whiff_lab
ph_lab)

Bin_BV_AMSEL_concord*(ivp_3d vp3___1-vp3___9)

/CHISQ
;

label Bin_Sex_ivp = "ivp occus after or same day of condomeless sex"
	  sex_3d="condomless sex within 3 days of PSA"
	  sex_1d="condomless sex within 1 days of PSA"
	  Cat_PSA_sex3d="PSA and condomless sex within 3 days category"
	  Cat_PSA_sex1d="PSA and condomless sex within 1 days category"
	vp3___1 ="Vaginal douches (commercial douches- from the store)"
	vp3___2	="Water alone"
	vp3___3	="Fingers"
	vp3___4	="Soap or soap with water"
	vp3___5	="A cloth or a rag or wipes"
	vp3___6 ="Vinegar"
	vp3___7 ="Yogurt"
	vp3___8	="Herbs or traditional medicines from another country"
	vp3___9	="Other product"

	Bin_nugent_lab="BV lab (if nugent_lab>=7)"
	amsel_lab="AMSEL"
	Cat_Nugent_Amsel="Categories of BV_AMSEL agreement"
	Bin_BV_AMSEL_concord="BV_AMSEL agreement"
	discharge_lab="Was a discharge present?"
	clue_cell_lab="Presence of clue cells"
	whiff_lab="Whiff test result"
	ph_lab="pH Level 1:<4.5; 2:> 4.5"
;
RUN;

ods rtf close;
