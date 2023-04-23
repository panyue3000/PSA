


/*1. PSA VS IVP_3D*/
ods rtf file="C:\Users\panyue\Box\WHIMS Data (From Alejandro, added 2.16.22)\WHIMS Data - Papers\PSA and GYN Measures\Results\freq.rtf";

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

ods rtf close;



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