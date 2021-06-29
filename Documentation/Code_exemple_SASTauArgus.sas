/************************************************************************************************/
/*									Chemins utilisés											*/
/************************************************************************************************/
/* LA VALEUR DE CES VARIABLES EST A MODIFIER */
%let path_exe_tau_argus = Y:\Logiciels\TauArgus\TauArgus4.2.0b5\TauArgus.exe; /* chemin d'accès à l'exécutable du logiciel Tau-Argus */
%let folder_macro_ta = C:\Chemin vers le depot\SASTauArgus; /* répertoire où se trouve la macro %Tau_Argus */
%let folder_macro_ta_negatives = &folder_macro_ta.; /* répertoire où se trouve la macro %Tau_Argus_Negatives */
%let folder_bdd = C:\Chemin vers le depot\SASTauArgus\Documentation; /* répertoire où se trouve la base de données de tests legumes.sas7bdat */


/************************************************************************************************/
/*							Chargement de la macro sous sas										*/
/************************************************************************************************/
option mprint;
filename tauargus "&folder_macro_ta.";
%include tauargus (Macro_Tau_Argus);
filename tauneg  "&folder_macro_ta_negatives.";
%include tauneg (Macro_Tau_Argus_negatives);

/************************************************************************************************/
/*					Le cas simple : appliquer le secret sur un tableau simple					*/
/************************************************************************************************/
%Tau_Argus (
TauArgus_exe			=	&path_exe_tau_argus.,
method					=	modular,
tabsas					=	legumes,
library					=	&folder_bdd.,
tabulation_1			=	a21 pays tomates);

/************************************************************************************************/
/*					Le cas simple : appliquer des règles de secret primaire différentes			*/
/************************************************************************************************/
%Tau_Argus (
TauArgus_exe			=	&path_exe_tau_argus.,
method					=	modular /*ou optimal*/,
tabsas					=	legumes,
library					=	&folder_bdd.,
tabulation_1			=	a21 pays tomates,
primary_secret_rules	=	DOM P FREQ,
dom_k					=	80,
p_p						=	20,
frequency				=	11);
	
/************************************************************************************************/
/*					Le cas simple : appliquer le secret sur un tableau de comptage				*/
/************************************************************************************************/
%Tau_Argus (
TauArgus_exe		=	&path_exe_tau_argus.,
method				=	modular,
tabsas				=	legumes,
library				=	&folder_bdd.,
tabulation_1		=	a21 pays freq);

/************************************************************************************************/
/*					Le cas simple : appliquer le secret sur deux tableaux liés					*/
/************************************************************************************************/
%Tau_Argus (
TauArgus_exe		=	&path_exe_tau_argus.,
/*pour cet exemple, Modular ne fonctionne pas. On se contentera du solver hypercube (pas besoin de le
préciser dans les paramètres, il y est par défaut*/
tabsas				=	legumes,
library				=	&folder_bdd.,
tabulation_1		=	a21 pays tomates,
tabulation_2		=	a21 cj tomates);

/************************************************************************************************/
/*	Le cas simple : appliquer le secret sur un tableau ventilant une variable "hiérarchique"	*/
/************************************************************************************************/
%Tau_Argus (
TauArgus_exe		=	&path_exe_tau_argus.,
method				=	modular,
tabsas				=	legumes,
library				=	&folder_bdd.,
tabulation_1		=	a88 tomates,
hierarchy_1			=	a10 a21 a88,
hierarchical_var	=	a88);

/************************************************************************************************/
/*		Le cas complexe : appliquer le secret à un tableau contenant des cases négatives		*/
/************************************************************************************************/

%Tau_Argus_Negatives (
TauArgus_exe		=	&path_exe_tau_argus.,
library				=	&folder_bdd.,
tabsas				=	legumes,
tabulation_1		=	nuts3 type_distrib pizzas,
tabulation_2		=	a88 nuts0 pizzas) ;

/************************************************************************************************/
/* Le cas complexe : appliquer le secret à des tableaux liés par une variable mais pas au même 	*/
/* niveaux d'agrégation																			*/
/************************************************************************************************/
libname legumes "&folder_bdd.";

data legumes.legumes2;
	set legumes.legumes ;
	radis_round = round(radis,1);
run;

%Tau_Argus (
TauArgus_exe		=	&path_exe_tau_argus.,
library				=	&folder_bdd.,
tabsas				=	legumes2,
tabulation_1		=	nuts3 type_distrib radis_round,
tabulation_2		=	nuts2 a88 radis_round,
hierarchical_var	=	nuts2 nuts3,
hierarchy_1			=	nuts0 nuts1 nuts2 nuts3,
hierarchy_2			=	nuts0 nuts1 nuts2 ,
method				=	,
outputtype			=	5) ;

/* NB - Lors de la première exécution de l'étape précédente, l'output est parfois incomplet : il manque parfois un fichier ".rda" accompagnant la tabulation_2 dans le répertoire TEMPORARY FILES MACRO. Si tel est le cas, alors il faut refaire tourner cette étape. */

%macro change_rda (library, tabulation,vardep, vararr);
	/* cette étape data permet de convertir la tabulation (ici "nuts2 a88 radis") en une version qui correspond au
	nom de la table sas associée, sans espace entre les variables ("nuts2_a88_radis").*/
	data _null_ ; 
		call symput ("output_name",compress(tranwrd(tranwrd(trim(tranwrd("&tabulation","_","*"))," ","_"),"*",""))) ; 
	run ; 
	proc import datafile	=	"&library.\TEMPORARY FILES MACRO\&output_name..rda" 
				out			=	rda
				dbms		=	dlm replace; 
				delimiter	=	'**'; 
				getnames	=	no; 
	RUN;

	data rda ;
		set rda ;
		if var1	=	"&vardep" then var1	=	"&vararr";
	run;

	data _null_ ; 
		call symput ("output_name2",tranwrd("&output_name","&vardep","&vararr")) ; 
	run ; 

	data _null_ ;
		File "&library.\TEMPORARY FILES MACRO\&output_name2..rda" dlm="" lrecl=200;
		set rda;
		Put (_all_)(+0);
	run;
 
	option noxwait xsync;
	X copy "&library.\TEMPORARY FILES MACRO\&output_name..tab"	"&library.\TEMPORARY FILES MACRO\&output_name2..tab";
%mend;
%change_rda (	
library		=	&folder_bdd.,
tabulation	=	nuts2 a88 radis_round,
vardep		=	nuts2,
vararr		=	nuts3);

%Tau_Argus (
TauArgus_exe		=	&path_exe_tau_argus.,
method				=	modular,
library				=	&folder_bdd.,
input				=	tabledata,
tabulation_1		=	nuts3 type_distrib radis_round,
tabulation_2		=	nuts2 a88 radis_round) ;


/************************************************************************************************/
/* Le cas complexe : des tabulations liées non par les variables de ventilation mais par les 	*/
/* variables de réponse.																		*/
/************************************************************************************************/

/* solution 1 - on fait le secret sur un tableau, on appliquera le masque ainsi récupéré aux trois tableaux. */
%Tau_Argus (
TauArgus_exe		=	&path_exe_tau_argus.,
method				=	optimal,
tabsas				=	legumes, 
library				=	&folder_bdd.,
tabulation_1		=	a88 cj legumes_rouges,
apriori_creation	=	yes);

/* solution 2 - on transforme les trois tableaux en un seul avec une variable supplémentaire pour renseigner sur le type de légume. */
libname legumes "&folder_bdd.";

data legumes.legumes2 ;
	set legumes.legumes (in	=	leg_r	rename	=	(legumes_rouges	=	quantite))
		legumes.legumes (in	=	salad	rename	=	(salades	=	quantite));
	if leg_r	=	1 then type_leg	=	"legumes_rouges";
	if salad	=	1 then type_leg	=	"salades";
run;

proc sort 	data	=	legumes.legumes2 ; by ident ; run;

%Tau_Argus (
TauArgus_exe		=	&path_exe_tau_argus.,
method				=	optimal,
tabsas				=	legumes2, 
library				=	&folder_bdd.,
tabulation_1		=	a88 cj type_leg quantite,
holding_var			=	ident );
