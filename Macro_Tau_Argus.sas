/* Macro %Tau_Argus			                                                     									*/
/********************************************************************************************************************/
/* Cette macro permet de lancer Tau-Argus sans sortir de l'environnement SAS. 										*/
/* Deux formats d'entr�es sont possibles : microdonn�es (une table sas), ou des donn�es tabul�es, au format fichiers*/
/* plats correspondant aux besoins du logiciel (donn�es tabul�es : .tab, m�tadonn�es correspondantes : .rda).		*/
/* Les sorties disponibles sont des tables sas, d'un format similaire � une proc summary (chaque ligne repr�sente 	*/
/* une case de la tabulation), avec une variable "FLAG" dont les modalit�s signifient :								*/
/* A	=	case sous secret primaire de fr�quence																	*/
/* B	=	case sous secret primaire de dominance																	*/
/* F	=	case sous secret primaire li�s au P%																	*/
/* D	=	case sous secret secondaire																				*/
/* V	=	case diffusable																							*/
/* Les fichiers g�n�r�s lors de l'appel de la macro sont plac�s dans deux r�pertoires, cr��s dans la racine du 		*/
/* r�pertoire de travail (param�tre '&library') :																	*/
/* RESULTS : on y trouvera les masques de secret sous format excel et sas											*/
/* TEMPORARY FILES MACRO : on y trouvera les fichiers plats et les sorties utilis�s par Tau-Argus.					*/
/********************************************************************************************************************/
/* Auteurs : Julien LEMASSON, Maxime BEAUTE	            								                            */
/********************************************************************************************************************/
/* Version : cf. CHANGELOG.md            	            								                            */
/********************************************************************************************************************/
/* Param�tres de la macro                                                                							*/
/********************************************************************************************************************/
/*library				=	R�pertoire de travail. S'y trouve la table sas en entr�e, les �ventuels fichiers plats  */
/*							d�crivant les hi�rarchies des variables hi�rarchiques (.hrc), et les �ventuels fichiers */
/*							d'a priori (.hst). Doit �tre renseign�.													*/
/*								(vide) : par d�faut																	*/
/*tabsas				=	Nom de la table sas de microdonn�es. Doit �tre renseign� si '&input'='microdata'.		*/
/*								(vide) : par d�faut																	*/
/*batch_name			=	Nom du fichier batch g�n�r� lors de l'appel de la macro.								*/
/*								batch_sas.arb : par d�faut															*/
/*input					=	Sp�cifie le type de donn�es en entr�e.													*/
/*								microdata : (par d�faut) n�cessite une table sas en entr�e							*/
/*								tabledata : n�cessite des donn�es tabul�es au format ad�quat (.tab et .rda). Ces 	*/
/*											tabulations peuvent	�tre g�n�r�es en utilisant la macro, et en 			*/
/*											sp�cifiant les param�tres et les valeurs suivants : '&OutputType'='5',	*/
/*											'&ext'='tab'															*/
/*weight_var			=	Nom de la variable de poids le cas �ch�ant. Il ne peut n'y en avoir qu'une par appel de */
/*							macro.																					*/
/*								(vide) : par d�faut																	*/
/*holding_var			=	Nom de la variable de holding le cas �ch�ant. Il s'agit d'un num�ro identifiant type 	*/
/*							SIREN. Il ne peut n'y en avoir qu'une par appel de macro.								*/
/*								(vide) : par d�faut																	*/
/*hierarchical_var		=	Liste des variables hi�rarchiques, s�par�es par un espace. � chaque variable doit �tre	*/
/*							associ�e un fichier plat (.hrc) d�crivant la hi�rarchie de la variable. IL est possible	*/
/*							de g�n�rer des fichiers de hi�rarchie en utilisant le param�tre '&hierarchy_x'.			*/
/*								(vide) : par d�faut																	*/
/*tabulation_1			=	Liste des variables (s�par�es d'un espace) d�crivant la premi�re tabulation. On placera	*/
/*							les variables de ventilation (caract�re) en premier, pour finir par la variable de 	    */
/*							r�ponse (num�rique). Si la tabulation est un tableau de comptage, la variable de r�ponse*/
/*							devra �tre "FREQ", la macro n'appliquera alors pas la r�gle de dominance.				*/
/*								(vide) : par d�faut																	*/
/*tabulation_10			=	Idem, pour la deuxi�me... jusqu'� la 10�me tabulation.									*/
/*								(vide) : par d�faut																	*/
/*output_name_1			=	Nom des tables en sortie (sas et excel) correspondants aux tabulations. Par d�faut, 	*/
/*							prend le nom de la tabulation correspondante. Utile notamment quand la tabulation fait 	*/
/*							plus de 32 caract�res.																	*/
/*								(vide) : par d�faut																	*/
/* ...output_name_10	=	Idem, pour la deuxi�me... jusqu'� la 10�me tabulation.									*/
/*								(vide) : par d�faut																	*/
/*hierarchy_1			=	Permet de g�n�rer le fichier plat .hrc correspondant � l'une des variables hi�rarchiques*/
/*							� partir des variables correspondant aux diff�rents niveaux agr�g�s (par exemple, pour 	*/
/*							la commune, il faut disposer des variables DEP et REG). Un fichier d'extension .hrc sera*/
/*							g�n�r� dans le r�pertoire de travail et prendra le nom de la variable fine (ici COM). 	*/
/*							ATTENTION, si un fichier de m�me nom existait, il sera �cras�. Cette option permet de 	*/
/*							g�n�rer des hi�rarchies simples, compl�tes et sym�triques. Il est �galement imp�ratif   */
/*							que toutes les modalit�s d'une m�me variable impliqu�e soient de m�me longueur (�viter 	*/
/*							les dep=01,02,...,971,972... ; pr�f�rez dep=001,002...971,972.							*/
/*								(vide) : par d�faut																	*/
/*								liste des variables espac�es, de la plus agr�g�e, � la plus d�taill�e (qui devra 	*/
/*								 correspondre � la variable de r�ponse d'une des tabulations (exemple : REG DEP COM)*/
/*...hierarchy_10			Idem pour les 9 variables suivantes. 													*/
/*								(vide) : par d�faut																	*/
/*primary_secret_rules	=	Sp�cifie les r�gles de secret primaire. Si la variable de r�ponse de la tabulation		*/
/*							est "FREQ", alors seule la r�gle de fr�quence sera appliqu�e. Les r�gles de secret 		*/
/*							primaire peuvent �tre �galement affect�es par les param�tres '&weight_var' et 			*/
/*							'&holding_var'. Ce param�tre est compl�t� par d'autres param�tres ('&dom_k' '&dom_n' 	*/
/*							'&dom_khold' '&dom_nhold' '&p_q' '&p_n' '&p_p' '&p_qhold' '&p_nhold' '&p_phold' 		*/
/*							'&frequency' '&frequencyrange' '&frequencyhold' '&frequencyrangehold') qui sp�cifient 	*/
/*							 les valeurs des r�glages des diff�rentes r�gles. 										*/
/*								DOM : r�gle de dominance uniquement													*/
/*								DOM P : r�gle de dominance et du P%													*/
/*								DOM FREQ : r�gle de dominance et de fr�quence (par d�faut)							*/
/*								DOM P FREQ : r�gle de dominance, du P% et de fr�quence								*/
/*								P FREQ : r�gle du P% et de fr�quence												*/
/*								P : r�gle du P% uniquement															*/
/*								FREQ : r�gle de fr�quence uniquement												*/
/*								NORULES : 	pas de r�gle de secret primaire (utile lorsque l'on importe le secret 	*/
/*											primaire via un fichier d'a priori (.hst) ). Lorsque ce param�tre est 	*/
/*											utilis� avec un fichier de donn�es tabul�es en entr�e 					*/
/*											("input = tabledata"), cela signifie que Tau-Argus utilisera l'option  	*/
/*											"use given status" � la place.											*/
/*primary_secret_rules_1=	Idem, mais sp�cifiquement pour la tabulation_1.											*/
/*								(vide) : par d�faut	prend la valeur de '&primary_secret_rules'						*/
/*...primary_secret_rules_10=Idem, pour la deuxi�me... jusqu'� la 10�me tabulation.									*/
/*								(vide) : par d�faut	prend la valeur de '&primary_secret_rules'						*/
/*dom_k					=	Seuil pour la r�gle de dominance. Les n (param�tre '&dom_n') premiers contributeurs 	*/
/*							d'une case de la tabulation ne doivent pas exc�der k% de la case.						*/
/*								85 : (par d�faut)																	*/
/*dom_n					=	Nombre de contributeurs pris en compte pour la r�gle de dominance.						*/
/*								1 : (par d�faut)																	*/
/*dom_khold				=	Idem '&dom_k', avec prise en compte de l'option "holding".								*/
/*								85 : (par d�faut)																	*/
/*dom_nhold				=	Idem '&dom_n', avec prise en compte de l'option "holding".								*/
/*								1 : (par d�faut)																	*/
/*p_p					=	Seuil pour la r�gle du P%. Les n (param�tre '&p_n') contributeurs suivant le premier 	*/
/*							d'une case de la tabulation ne doivent pas pouvoir estimer � moins de p% la valeur du 	*/
/*							premier contributeur.																	*/
/*								10 : (par d�faut)																	*/	
/*p_n					=	Nombre de contributeurs pris en compte pour la r�gle du P%.								*/
/*								1 : (par d�faut)																	*/
/*p_phold				=	Idem P_P, avec prise en compte de l'option "holding".									*/
/*								10 : (par d�faut)																	*/
/*p_nhold				=	Idem P_N, avec prise en compte de l'option "holding".									*/
/*								1 : (par d�faut)																	*/
/*frequency				=	Seuil pour la r�gle de fr�quence. Une case doit contenir au moins x individus.			*/
/*								3 : (par d�faut)																	*/
/*frequencyrange		=	Valeur � partir de laquelle sera d�finie l'intervalle de s�curit� pour la r�gle de 		*/
/*							fr�quence minimale. Il s'agit habituellement d'une petite valeur positive et est 		*/
/*							n�cessaire pour permettre le calcul du secret secondaire. 								*/
/*								10 : (par d�faut)																	*/
/*frequencyhold				Idem frequency, avec prise en compte de l'option "holding".								*/
/*								3 : (par d�faut)																	*/
/*frequencyrangehold		Idem frequencyrrange, avec prise en compte de l'option "holding".						*/
/*								10 : (par d�faut)																	*/
/*zero_unsafe			=	D�termine la r�gle concernant le secret appliqu� aux cases dont la valeur est nulle.	*/ 
/*							Cette option ne modifie pas le secret en cas de secret de fr�quence.					*/
/*								(vide) : (par d�faut) Une case nulle n'est pas cach�e								*/
/*								(une valeur entre 0 et 100) : l'option "zero_unsafe" est appliqu�e, la valeur 		*/
/*							correspondant � l'intervalle de s�curit� pour les cases concern�es.						*/
/*manual_safety_range	=	Lorsque le statut d'une cellule est d�fini manuellement comme unsafe (avec par exemple	*/
/*							un fichier d'a priori), Tau-Argus ne peut pas calculer lui-m�me les intervalles de 		*/
/*							protection. Par cons�quent, l'utilisateur doit fournir un pourcentage de protection 	*/
/*							� la main, qui sera appliqu� lors de la suppression secondaire.							*/
/*								10 : (par d�faut)																	*/
/*shadow_var			=	Variable � partir de laquelle le secret primaire sera effectivement d�fini. Par d�faut	*/
/*							il s'agit de la variable de r�ponse. S'applique par d�faut � toutes les tabulations.	*/
/*								(vide) : par d�faut																	*/
/*shadow_var_1			=	Idem, mais sp�cifiquement pour la tabulation_1.											*/
/*								(vide) : par d�faut	prend la valeur de '&shadow_var'								*/
/*...shadow_var_10		=	Idem, pour la deuxi�me... jusqu'� la 10�me tabulation.									*/
/*								(vide) : par d�faut	prend la valeur de '&shadow_var'								*/
/*cost_var				=	Variable qui sera utilis�e comme variable de co�t pour le secret secondaire. Par d�faut	*/
/*							il s'agit de la variable de r�ponse. S'applique par d�faut � toutes les tabulations		*/
/*								(vide) : par d�faut																	*/
/*cost_var_1			=	Idem, mais sp�cifiquement pour la tabulation_1.											*/
/*								(vide) : par d�faut	prend la valeur de '&cost_var'									*/
/*...cost_var_10		=	Idem, pour la deuxi�me... jusqu'� la 10�me tabulation.									*/
/*								(vide) : par d�faut	prend la valeur de '&cost_var'									*/
/*bounds				=	Valeur correspondant � l'option "External a priori bounds on the cell value" lors de 	*/
/*							l'utilisation de la m�thode hypercube.													*/
/*								100 : (par d�faut)																	*/
/*modelsize				=	Valeur correspondant � l'option "Model size" lors de l'utilisation de la m�thode 		*/
/*							hypercube. 																				*/
/*								0 : normal  (par d�faut)															*/
/*								1 : indicates the large model.														*/
/*lp_solver				=	Sp�cifie le solveur � utiliser pour traiter le secret secondaire.						*/
/*								free : solveur gratuit (par d�faut)													*/
/*								xpress	: n�cessite la licence XPress de FICO.										*/
/*								cplex : n�cessite la licence CPlex d'IBM.											*/
/*								(vide) : solveur non-sp�cifi�.														*/
/*method				=	Sp�cifie la m�thode utilis�e pour traiter le secret secondaire.							*/
/*								hypercube : (par d�faut)															*/
/*								modular																				*/
/*								optimal : ne fonctionne pas pour des tableaux li�s.									*/
/*method_1				=	Idem, mais sp�cifiquement pour la tabulation_1.											*/
/*								(vide) : par d�faut	prend la valeur de '&method'									*/
/*...method_10			=	Idem, pour la deuxi�me... jusqu'� la 10�me tabulation.									*/
/*								(vide) : par d�faut	prend la valeur de '&method'									*/
/*solver				=	Ancien param�tre d�sormais appel� method.												*/
/*							Pour des raisons de clart�, il n'est plus possible d'utiliser ce param�tre.			    */
/*solver_1				=	Ancien param�tre d�sormais appel� method_1.												*/
/*							Pour des raisons de clart�, il n'est plus possible d'utiliser ce param�tre.			    */
/*...solver_10			=	Ancien param�tre d�sormais appel� method_10.											*/
/*							Pour des raisons de clart�, il n'est plus possible d'utiliser ce param�tre.			    */
/*MaxTimePerSubtable	=	Valeur correspondant � l'option MaxTimePerSubtable lors de l'utilisation de la m�thode 	*/
/*							optimal. Il s'agit du nombre de minute qu'on accorde au logiciel pour trouver une 		*/
/*							solution optimale.																		*/
/*								(vide) : par d�faut																	*/
/*linked_tables			=	Sp�cifie si les diff�rentes tabulations d�crites dans l'appel de la macro doivent �tre 	*/
/*							trait�es conjointement ou ind�pendamment en ce qui concerne le secret secondaire.		*/
/*								yes : (par d�faut)																	*/
/*								no																					*/
/*outputtype			=	Sp�cifie le type de sortie en aval du traitement Tau-Argus.								*/
/*								1 : CVS-file																		*/
/*								2 : CSV file for pivot table														*/
/*								3 : Code, value file																*/
/*								4 : SBS-output format (par d�faut)													*/
/*								5 : Intermediate file (correspond � la sortie sous forme de tabulation (.tab) et du */
/*									fichier plat de metadonn�e correspondant). Format pouvant �tre utilis� en       */
/*									entr�e de la macro (param�tre '&input'	=	tabledata)							*/
/*parameter				=	Valeur correspondant aux options secondaires lors de la r�cup�ration des donn�es en aval*/
/*							de Tau-Argus. Elle d�pend de l'outputtype choisi :										*/
/*								outputtype=1	Not used															*/
/*								outputtype=2	1 : AddStatus 														*/
/*												0 = not																*/
/*								outputtype=3	1 : AddStatus														*/
/*												2 : suppress empty cells											*/
/*												3 : both options													*/
/*								outputtype=4	0 : none (par d�faut)												*/
/*								outputtype=5	0 = Status only														*/
/*												1 = also Top-n scores												*/
/*TauArgus_exe			=	(OBLIGATOIRE) R�pertoire et nom de l'application Tau-Argus. 							*/
/*							Ce param�tre sp�cifie donc indirectement la version de Tau-Argus utilis�e.				*/
/*							Par exemple : Y:\Logiciels\TauArgus\TauArgus4.2.0b5\TauArgus.exe						*/
/*TauArgus_version		=	A sp�cifier lorsque l'on utilise les versions de Tau-Argus ant�rieures ou �gales � 3.5.	*/
/*								opensource : (par d�faut)															*/
/*								(vide) : pour les versions 3.5 ou moins												*/
/*synthesis				=	Permet de g�n�rer un fichier excel r�sumant le nombre de case selon le statut de chaque */
/*							masque sous format excel du r�pertoire RESULTS.											*/
/*								yes																					*/
/*								no : (par d�faut)																	*/
/*displayed_value		=	Permet que les valeurs (et le nombre d'individu participant � la case des cases sous 	*/
/*							secret soient affich�es dans les masques. 												*/	
/*								yes	: (par d�faut)																	*/
/*								no 																					*/
/*work					=	Permet de vider la biblioth�que Work de SAS en fin de programme.						*/
/*								empty : (par d�faut)																*/
/*apriori_1				=	Sp�cifie si � la tabulation_1 on associe un fichier d'a priori (.hst), qui devra porter */
/*							le nom de la tabulation_1 avec l'extension .hst, et se trouver dans le r�pertoire de 	*/
/*							travail.																				*/
/*								yes 																				*/
/*								(vide) : par d�faut																	*/
/*...apriori_10			=	Idem, pour la deuxi�me... jusqu'� la 10�me tabulation.									*/
/*								yes 																				*/
/*								(vide) : par d�faut																	*/
/*apriori_creation		=	Permet de cr�er un fichier d'a priori (format .hst) � partir de chaque tabulation. Il 	*/
/*							s'agit d'un fichier qui devra �tre charg� par Tau-Argus en aval de la sp�cification des	*/
/*							tableaux et des r�gles du secret primaire et en amont d'appliquer le secret secondaire.	*/
/*							Cela n�cessite que le param�tre '&outputtype' soit �gal � "4" (sortie au format .sbs).	*/
/*								yes : pour appliquer cette option													*/
/*								(vide) : (par d�faut)																*/
/********************************************************************************************************************/
/********************************************* AJOUT le 12/12/2017***************************************************/
/********************************************************************************************************************/
/*compute_missing_totals=	Permet d'utiliser l'option du m�me nom lorsque l'on a en entr�e une ou des tabulations.	*/
/*							Cela signifie que l'on autorise Tau-Argus � recalculer les marges � partir des cases 	*/
/*							internes de la tabulation. 																*/
/*								yes : pour appliquer cette option													*/
/*								(vide) : (par d�faut)																*/
/********************************************************************************************************************/



/*
------------------------------------------------------------------------------------
				CONSEILS EN AMONT DE L'UTILISATION DE LA MACRO
------------------------------------------------------------------------------------
- Faire en sorte qu'il n'y ait pas de valeur manquante (par exemple, effectif = .) pour les variables de r�ponse (num�riques). Ces unit�s ne 
participant pas aux cases de la tabulation ne doivent pas �tre comptabilis�es, elles sont hors champ.

- Si pour certaines unit�s on dispose d'autorisations sp�ciales de diffusion (comme pour La Poste, largement dominant dans son secteur d'activit�, 
pour les diffusions ESANE par exemple), il conviendra de pr�parer un fichier d'a priori (.hst) pour chaque tabulation, avec le statut que l'on d�sire 
appliquer aux cases concern�es par la pr�sence des unit�s en question.

- La table sas correspondant au param�tre '&tabsas' ne doit comporter que les unit�s participant aux tabulations demand�es. Elle pourra n�anmoins 
comporter des variables ne servant pas � la pose du secret, mais plus elle sera volumineuse, plus le traitement sera long.

- Pr�f�rer les noms de variable courts, pour �viter d'avoir des TABULATIONS d�passant les 32 caract�res.

- Si on doit secr�tiser un nombre important de tabulations, a fortiori si les donn�es individuelles sont volumineuses, il peut �tre int�ressant 
de tester le secret primaire en amont (via une proc means par exemple), pour n'utiliser la pr�sente macro que pour les tabulations concern�es par 
du secret primaire.

- Il est possible d'utiliser les sous-macro contenues dans la macro principale, notamment :
	%ASC_RDA		=	g�n�re les fichiers plats de micronn�es (.asc) et de m�tadonn�es (.rda) au format compatible avec Tau-Argus, � partir de 
						la TABSAS.
	%HRC			=	g�n�re un fichier de hi�rarchie (.hrc), � partir de la TABSAS. Celle-ci devra comporter toutes les variables correspondant 
						aux diff�rents niveaux agr�g�s souhait�s dans sa hi�rarchie.
	%TAUARGUSEXE	=	permet de lancer un fichier batch Tau-Argus (.arb) � partir de sas.
	%FORMATING		=	g�n�re des tables sas et des fichiers excel � partir des sorties Tau-Argus au format SBS (.sbs). La pr�sentation des masques 
						de secret ressemble � un output d'un proc summary (une ligne = une case de la tabulation).
	%SYNTHESIS		=	g�n�re un fichier excel comptabilisant le nombre de cases selon leur statut, pour chaque tabulation et pour l'ensemble des 
						tabulations.

- Lorsque l'on travaille � partir de tableaux en entr�e, plut�t qu'� partir de microdonn�es (&input = tabledata), il peut �tre pr�f�rable d'arrondir 
ses variables de r�ponse � l'unit�, avant de tabuler. Tau-Argus est tr�s sensible � la non additivit� des marges (m�me s'il existe, en manuel, des 
options pour ne pas tenir compte de ce probl�me).



------------------------------------------------------------------------------------
								LES IMPERATIFS ET LIMITES
------------------------------------------------------------------------------------
- Faire en sorte que les variables hi�rarchiques aient des modalit�s fines de m�me longueurs.

- Dans le cas de variable hi�rarchique non sym�trique et complexe (par exemple, si on d�sire diffuser au niveau communal dans une r�gion, mais 
uniquement au niveau d�partemental dans les autres r�gions), il faut pr�parer le fichier de hi�rarchie en amont de l'utilisation de la macro. 

- On ne peut g�rer le secret que sur 10 tabulations par session Tau-Argus.

- Modular ne peut g�rer que 4 variables de ventilations maximum (en comptant toutes les variables des tableaux li�s).

- Hypercube ne peut g�rer que 6 variables de ventilations maximum (en comptant toutes les variables des tableaux li�s).

- Hypercube ne fonctionne pas avec des hi�rarchies avec plus de 7 niveaux (au moins dans la version 3.5 de Tau-Argus).



------------------------------------------------------------------------------------
									REMARQUES GENERALES
------------------------------------------------------------------------------------
- Dans certains cas, il n'est pas n�cessaire de g�rer la confidentialit� en d�terminant le secret primaire et en appliquant une couche de secret 
secondaire. 
Certaines variables de r�ponse peuvent �tre tellement corr�l�es � d'autres variables de r�ponses (effectif ETP et effectif au 3112 par exemple) qu'il 
est pr�f�rable de simplement appliquer le m�me masque de secret au deux variables, alors d�fini sur l'une des deux. La variable sur laquelle est 
d�termin�e le masque est appel�e variable proxy. 

- Certaines v�rifications sont parfois n�cessaires en plus de l'application de la macro ou de la gestion "� la main" du secret secondaire via 
Tau-Argus. 
Par exemple, deux variables de ventilations peuvent avoir des modalit�s �quivalentes sans pour autant que Tau-Argus ne soit capable de le savoir. Par 
exemple, la division 17 de la NAF correspond � la modalit� E35 de la Nomenclature d'activit�s �conomiques 2008 (NCE 2008). Il conviendra en aval de 
l'ex�cution de la macro, de v�rifier que les cases �quivalentes ont bien le m�me statut (notamment au niveau du secret secondaire). Si ce n'est pas 
le cas, on pourra alors g�n�rer un fichier d'a priori (.hst) pour sp�cifier le statut que doit prendre les cases concern�es.

- Dans le cas des variables hi�rarchiques, il est pr�f�rable d'�viter d'avoir des modalit�s identiques correspondant � des niveaux d'agr�gations 
diff�rents : par exemple le niveau A38 "FZ" ne correspond pas pour Tau-Argus au niveau A10 "FZ". Pr�f�rez un recodage en amont de l'appel de la 
macro (par exemple : "A38_FZ" et "A10_FZ"), pour que Tau-Argus distingue bien les deux lignes du tableau.

- Dans le cas de tableaux trop volumineux (trop de cases), ou avec des valeurs tr�s grandes (en millions/milliard) et avec beaucoup de d�cimales, il 
peut �tre envisageable de faire tourner la macro sur une version modifi�e de la variable de r�ponse. Parfois le fait d'arrondir les donn�es peut 
suffire � ce que le secret secondaire se fasse. Si cela ne suffit pas, on pourra essayer de diviser la variable par 10 par exemple.


*/

/********************************************************************************************************************/
/********************************************************************************************************************/
/* 	Code de la macro																								*/
/********************************************************************************************************************/
/********************************************************************************************************************/


/********************************************************************************************************************/
/********************************************************************************************************************/
/*											 Creation fichiers ASC + RDA											*/
/********************************************************************************************************************/
/* %ASC_RDA		=	g�n�re les fichiers plats de micronn�es (.asc) et de m�tadonn�es (.rda) au format compatible 	*/
/*					avec Tau-Argus, � partir de la TABSAS.															*/
/********************************************************************************************************************/
/********************************************************************************************************************/



%macro asc_rda (
	asc					=	microdata.asc,
	rda					=	metadata.rda,
	library_asc_rda		=	,	
	tabsas				=	,
	tabulation_1 		=	,
	tabulation_2 		=	,
	tabulation_3 		=	,
	tabulation_4 		=	,
	tabulation_5 		=	,
	tabulation_6 		=	,
	tabulation_7 		=	,
	tabulation_8 		=	,
	tabulation_9 		=	,
	tabulation_10		=	,
	weight_var			=	,
	holding_var			=	,
	hierarchical_var	=	) ; 

	X mkdir "&library_asc_rda.\TEMPORARY FILES MACRO" ; 

	%do a1	=	1 % to 10 ; 
		data _null_ ; 
			call symput ("tabulation_&a1",tranwrd("&&tabulation_&a1"," ","*")) ; 
		run ; 
	%end ; 
	/* On commence par la cr�ation du fichier de microdonn�es (.asc)													
	On cr�e les param�tres '&response_var' et '&explanatory_var' � partir des informations des diff�rentes tabulations. On agr�ge les
	variables de ventilation et on �limine les doublons, idem pour les variables de comptage, en se servant de la	
	macro %unique qui suit la macro %asc_rda.*/
	data variables ; 
	run ; 

	%do a2	=	1 % to 10 ; 
		data _null_ ; 
			call symput ("response_var_&a2",lowcase(compress(scan("&&tabulation_&a2",-1,"*")))) ; 
		run ; 

		data null ; 
			call symput("length_resp",length("*&&response_var_&a2"));
		run;

		data _null_ ; 
			call symput ("explanatory_var_&a2",reverse(substr(reverse ("&&tabulation_&a2"),&length_resp)));
		run;

		data variables ; 
			set variables ; 
			response_var_&a2 		=	 "&&response_var_&a2" ; 
			explanatory_var_&a2 		=	 "&&explanatory_var_&a2" ; 
		run ; 
	%end ; 

	data 
		response_var 	(keep	=	response_var_1 response_var_2 response_var_3 response_var_4 response_var_5 response_var_6 response_var_7 response_var_8 response_var_9 response_var_10) 
		explanatory_var (keep	=	explanatory_var_1 explanatory_var_2 explanatory_var_3 explanatory_var_4 explanatory_var_5 explanatory_var_6 explanatory_var_7 explanatory_var_8 explanatory_var_9 explanatory_var_10) ; 
		set variables ; 
	run ; 

	%unique (
		typ_var	=	response_var,
		sep		=	*) ; 

	%unique (
		typ_var	=	explanatory_var,
		sep		=	*) ; 

	data _null_ ; 
		set response_var ; 
		call symput ("response_var",strip(response_var)) ; 
	run ; 

	data _null_ ; 
		set explanatory_var ; 
		call symput ("explanatory_var",strip(explanatory_var)) ; 
	run ; 
	

	data _null_ ; 
		call symput ("explanatoryy_var",tranwrd("&explanatory_var","*"," ")) ; 
	run;
		
	data _null_;
		call symput ("test_explanatory_var",count ("&explanatoryy_var"," ")+1);
	run ; 

	%if &test_explanatory_var > 4 %then
		%do ; 
			data _null_ ; 
				put "WARNING: le nombre de variable de ventilation est de &test_explanatory_var.. La limite de variables de ventilation est de 4 maximum pour la m�thode modular et de 6 maximum pour la m�thode hypercube." ; 
			run ; 
		%end ; 

	data _null_ ; 
		call symput ("responsee_var",tranwrd("&response_var","*"," ")) ; 
	run ; 

	data _null_ ; 
		call symput ("list_varr",compbl(lowcase("&responsee_var. &explanatoryy_var. &holding_var. &weight_var"))) ; 
	run ; 

	libname tabsas "&library_asc_rda" ; 

	data temp01 ; 
		retain &list_varr ; 
		set tabsas.&tabsas ; 
		freq	=	1 ; 
		keep &list_varr ; 
	run ; 
	
	%if &syserr ne 0 %then
		%do ;
			data _null_ ; 
				put "ERROR: une erreur est survenue lors de la cr�ation de la table contenant les variables de travail" ; 
				put "WARNING: v�rifiez que les variables des tabulations, de poids et de holding sont bien identiques � celles qu'on trouve dans la table originale ('&tabsas')" ; 
			run ; 
			%abort ; 
		%end;

	data _null_ ; 
		call symput ("nb_responsee_var",count("&responsee_var"," ")+1) ; 
	run ; 	

	data _null_ ; 
		call symput ("nb_vent_var",count("&explanatoryy_var"," ")+1) ; 
	run ; 

		%do a3	=	1 %to &nb_vent_var;
			data _null_;
				call symput ("vent&a3",scan("&explanatoryy_var",&a3," ")) ;
		
			data vent_length; 
				set temp01 (keep=&&vent&a3);
				vent_length = length(&&vent&a3);
			run;

			proc sort data = vent_length ; 
				by descending vent_length ;
			run;

			data vent_length ;
				set vent_length ;
				if _n_=1;
			run;

			data _null_ ;
				set vent_length ;
				call symput ("vent_length",vent_length) ;
			run;

			data temp01 ;
				length &&vent&a3 $&vent_length. ;
				set temp01 (rename=(&&vent&a3=vent));
				&&vent&a3=left(vent);
				drop vent;
			run;	
		%end;

	/* On cr�e une table temporaire pour avec les variables de r�ponse pond�r�es, pour r�cup�rer le bon nombre de d�cimal. 
	Modular ne g�re pas les tableaux li�s lorsque que la variable de r�ponse ne prend pas en compte les d�cimales apr�s la
	pond�ration.*/
	%if "&weight_var" ne "" %then 
		%do ;
			data decimal;
				set temp01 ;
			run;

			%do a4	=	1 %to &nb_responsee_var ; 
				data _null_ ; 
					call symput ("responsee_var_&a4", scan("&responsee_var",&a4," ")) ; 
				run ; 

				data decimal testtt; 
					set decimal (rename	=	(&&responsee_var_&a4	=	var_weighted)) ; 
					&&responsee_var_&a4	=	var_weighted * &weight_var ; 
					drop var_weighted ; 
				run ; 

				proc contents 	data	=	decimal (keep	=	&&responsee_var_&a4) 
								out		=	content_decimal_resp (keep	=	type) 
								noprint;
				run;

				data _null_ ;
					set content_decimal_resp;
					call symput ("response_car",type);
				run;

				%if &response_car=1 %then 
					%do; 
						data decimal ; 
							set decimal (rename	=	(&&responsee_var_&a4	=	varnum )) ; 
							&&responsee_var_&a4	=	put(varnum,best.) ;
							drop varnum ; 
						run ; 
					%end;

			%end ; 
			proc contents 	data	=	decimal (keep	=	&weight_var) 
							out	=	content_decimal_wgt (keep	=	type) 
							noprint;
			run;
			data _null_ ;
				set content_decimal_wgt ;
				call symput ("weight_car",type);
			run;

			%if &weight_car=1 %then
				%do;					
					data decimal ; 
						set decimal (rename	=	(&weight_var	=	weight_num)) ; 
						&weight_var	=	left (put(weight_num,best.)) ; 
						drop weight_num; 
					run ; 
				%end;
		%end;



	/* On v�rifie qu'il ne manque pas de valeur sur les variables de r�ponse*/
		%do a5	=	1 %to &nb_responsee_var ; 
			data _null_ ; 
				call symput ("responsee_var_&a5", scan("&responsee_var",&a5," ")) ; 
			run ; 

			data test_value ;
				set temp01 ;
				if &&responsee_var_&a5 = . ;
			run;
			
			data _null_;
				call symput ("missing_value",0); 
			run;

			data _null_;
				set test_value END=eof;
				test_value	=	_n_;
				if eof then 
					do ;
						call symput ("missing_value",test_value); 
					end;				
			run;

			%if &missing_value > 0 %then
					%do ;
						data _null_ ; 
							put "ERROR: il manque des valeurs pour la variable de r�ponse &&responsee_var_&a5";
						data _null_ ; 
							put "WARNING: Tau-Argus a besoin que tous les individus d'une tabulation aient une valeur. Veillez � supprimer les individus concern�s ou � remplacer leur valeur par un 0 (ils seront alors pris en compte pour la r�gle de secret primaire de fr�quence)." ; 
						run ; 
						%ABORT ; 
					%end ; 
		%end ; 

	/* Mise en forme des variables conserv�es : on transforme les variables num�riques (&response_var et &weight) en
	variables caract�res. Lors de l'export en fichier plat .asc, Tau-Argus a notamment besoin que les variables avec
	des d�cimales aient le s�parateur align�.*/
	%if "&weight_var" ne "" %then 
		%do ; 
			proc contents 	data	=	temp01 (keep	=	&weight_var) 
							out	=	content_temp01_wgt (keep	=	type)
							noprint;
			run;

			data _null_ ;
				set content_temp01_wgt;
				call symput ("weight_car",type);
			run;

			%if &weight_car=1 %then
				%do;
					data temp01 ; 
						set temp01 (rename	=	(&weight_var	=	weight_num)) ; 
						&weight_var	=	left(put(weight_num,best.)) ; 
					run ; 
				%end;
		%end ; 

		%do a6	=	1 %to &nb_responsee_var ; 
			data _null_ ; 
				call symput ("responsee_var_&a6", scan("&responsee_var",&a6," ")) ; 
			run ; 
				
				%do ; 
					proc contents 	data	=	temp01 (keep	=	&&responsee_var_&a6) 
									out	=	content_temp01_resp (keep	=	type)
									noprint;
					run;

					data _null_ ;
						set content_temp01_resp;
						call symput ("response_car",type);
					run;

					%if &response_car=1 %then
						%do;
							data temp01 ; 
								set temp01 (rename	=	(&&responsee_var_&a6	=	varnum)) ; 
								&&responsee_var_&a6	=	put(varnum,best.) ; 
								drop varnum ; 
							run ;
						%end;
				%end ;			 
		%end ; 


	data temp01 ; 
		retain &explanatoryy_var &responsee_var &holding_var &weight_var ; 
		set temp01 ; 
		keep &explanatoryy_var &responsee_var &holding_var &weight_var ; 
	run ; 

	/* Gestion de l'ordre des variables.*/
	data _null_ ; 
		call symput ("order_explanatoryy_var",tranwrd("&explanatory_var","*",",")) ; 
	run ; 

	data _null_ ; 
		call symput ("order_responsee_var",tranwrd(",&response_var","*",",")) ; 
	run ; 

	%if "&holding_var" ne "" %then 
		%do ; 
			data _null_ ; 
				call symput ("order_holding_var",",&holding_var") ; 
			run ; 
		%end ; 

	%else %if "&holding_var"	=	"" %then 
		%do ; 
			data _null_ ; 
				call symput ("order_holding_var","") ; 
			run ; 
		%end ; 

	%if "&weight_var" ne "" %then 
		%do ; 
			data _null_ ; 
				call symput ("order_weight_var",",&weight_var") ; 
			run ; 
		%end ; 

	%else %if "&weight_var"	=	"" %then 
		%do ; 
			data _null_ ; 
				call symput ("order_weight_var","") ; 
			run ; 
		%end ; 

	proc sql ; 
		create table asci as 
		select &order_explanatoryy_var &order_responsee_var &order_weight_var &order_holding_var from temp01 ; 
	quit ; 

	/* On r�cup�re les infos sur les longueurs de variables.*/
	proc contents noprint 	data	=	asci 
							out		=	contenti ; 
	run ; 

	proc sort 	data 	=	contenti 
				out		=	contenti (keep	=	name length varnum) ; 
		by varnum ; 
	run ; 

	/* Cette data permet de r�cup�rer l'info de la longueur de la ligne d'au-dessus, ce qui permet de calculer la
	position et la longueur que prendra la variable dans le fichier plat, on a besoin ici de la position de d�part et
	celle d'arriv�e ex. SIREN 1-9 APE 11-15 etc.*/
	data _null_ ; 
		set contenti ; 
		call symput("N",_N_) ; 
	run ; 

	data list_var ; 
		set contenti ; 
		length1		=	1 ; 
		length2		=	length ; 
		if varnum	=	1 then list_var	=	compress(name||"*"||length1||"-"||length2) ; 
			%do a7	=	2 %to &N ; 
				length1		=	sum(lag1(length2),2) ; 
				length2		=	sum(length1,length,-1) ; 
				if varnum	=	&a7 then list_var	=	compress(name||"*"||length1||"-"||length2) ; 
			%end ; 
		list_var	=	tranwrd(list_var,"*"," ") ; 
		keep name varnum list_var ; 
	run ; 

	/* Macro variables qui permettent d'afficher la liste des variables leur position et leur longueur.*/
	proc transpose 	data	=	list_var 
					out		=	temp02(drop	=	_name_) ; 
		var name ; 
		id varnum ; 
	run ; 

	data _null_ ; 
		set temp02 ; 
		length list_var $2000 ; 
			%do a8	=	1 %to &N ; 
				list_var	=	compress(list_var||"*"||_&a8) ; 
			%end ; 
		list_var	=	tranwrd(list_var,"*","||") ; 
		call symput("list_var",substr(list_var,3)) ; 
	run ; 

	proc transpose 	data	=	list_var 
					out		=	temp03 (drop	=	_name_) ; 
		var list_var ; 
		id name ; 
	run ; 

	data _null_ ; 
		set temp03 ; 
		list_var	=	&list_var ; 
		call symput("list_var",list_var) ; 
	run ; 

	filename asc "&library_asc_rda.\TEMPORARY FILES MACRO\&asc" ; 
	data _null_ ; 
		set asci ; 
		file asc ; 
		put &list_var ; 
	run ; 

	/* On passe � la cr�ation du fichier de m�tadonn�e (.rda)
	On r�cup�re pour chaque variable que l'on a export�e dans le .asc les infos de la position et de longueur de la
	variable (et non les positions de d�part/arriv�e).Ex :
	SIREN 1 9
	APE 11 5
	etc.
	On remplace les variables d�crites dans le param�tre '&hierarchical_var' par les noms g�n�riques correspondant.*/
	data _null_ ; 
		call symput ("explanatoryy_var_entre_cote",	upcase(tranwrd("&explanatory_var","*",'" "'))) ; 
		call symput ("responsee_var_entre_cote",	upcase(tranwrd("&response_var","*",'" "'))) ; 
		call symput ("hierarchical_var_entre_cote",	upcase(tranwrd("&hierarchical_var"," ",'" "'))) ; 
	run ; 

	proc sort data	=	list_var ; 
		by varnum ; 
	run ; 

	proc sort data	=	contenti ; 
		by varnum ; 
	run ; 

	data rda ; 
		length HIERCODELIST $1000 ; 
		merge 
		list_var 
		contenti (keep	=	varnum length) ; 
		by varnum ; 
		list_var	=	tranwrd(list_var," ","*") ; 
		list_var	=	tranwrd(compbl(scan(list_var,-2,"-")||" "||length),"*"," ") ; 
		if upcase(compress(name)) in ("&explanatoryy_var_entre_cote") then type_var	=	"<RECODEABLE>" ; 
		if upcase(compress(name)) in ("&hierarchical_var_entre_cote")then 
			do ; 	HIERARCHICAL	=	"<HIERARCHICAL>" ; 
					HIERLEADSTRING	=	'<HIERLEADSTRING> "@"' ; 
					HIERCODELIST	=	"<HIERCODELIST> "||'"'||"&library_asc_rda.\"||compress(name||".hrc"||'"') ; 
			end ; 
		HIERLEVELS	=	"" ; 
		if upcase(compress(name)) in ("&responsee_var_entre_cote") 	then type_var	=	"<NUMERIC>" ; 
		if upcase(compress(name)) 	=	upcase("&weight_var") 		then type_var	=	"<WEIGHT>" ; 
		if upcase(compress(name)) 	=	upcase("&holding_var") 		then type_var	=	"<HOLDING>" ; 
	run ; 

	proc sort data	=	rda ; 
		by name ; 
	run ; 

	%let varr	=	&responsee_var &weight_var ; 

	/* S'il n'y a pas de variable de poids, on se sert de la variable de r�ponse de base pour d�terminer le nombre de d�cimales*/
	%if &weight_var = %then 
		%do;
			data decimal ;
				set asci;
			run;
		%end;

	/* La macro %decimal permet de r�cup�rer l'info du nombre de d�cimale pour les variables de comptage et de poids.*/
	%macro decimal (decimal=) ; 
		%do loop	=	1 %to %sysfunc(countw(&varr.)) ; 
		    %let WORD	=	%scan(&decimal.,&loop.) ; 
		   /* %put boucle &loop. : &WORD. ; */
			data temp05 ; 
				set decimal ; 
				max_varr	=	0 ; 
					%do a9	=	0 % to 9 ; 
						max_varr	=	 max_varr+count(scan(&word,2,"."),"&a9") ; 
					%end ; 
			run ; 

			proc means data	=	temp05 noprint max ; 
				var max_varr ; 
				output 	out	=	temp05 
						max	=	decimal ; 
			run ; 

			data temp05 ; 
				set temp05 ; 
				name	=	"&word" ; 
			run ; 

			data rda ; 
				merge 
				rda
				temp05 (keep	=	 name decimal) ; 
				by name ; 
				if decimal	=	0 then decimal	=	. ; 
			run ; 
		%end ; 
	%mend ; 

	%decimal (decimal	=	&varr) ; 

	proc sort data	=	rda ; 
		by varnum ; 
	run ; 

	/* On ordonne les variables pour que le fichier de m�tadonn�e (.rda) soit lisible par Tau-Argus.*/
	data rda ; 
		set rda (rename	=	(decimal	=	decimalll)) ; 
		decimall	=	left(put(decimalll,best.)) ; 
		if decimalll ne . then decimal	=	"<DECIMALS>"||" "||decimall ; 
		drop decimalll decimall ; 
		num_listvar			=	1+7*(_n_-1) ; 
		num_type_var		=	num_listvar+1 ; 
		num_decimal			=	num_listvar+2 ; 
		num_HIERARCHICAL	=	num_listvar+3 ; 
		num_HIERLEADSTRING	=	num_listvar+4 ; 
		num_HIERCODELIST	=	num_listvar+5 ; 
		num_HIERLEVELS		=	num_listvar+6 ; 
	run ; 

	data rda ; 
		length instruction$1000 ; 
		merge 
		rda (keep	=	list_var 			num_listvar 		rename	=	(list_var		=	instruction num_listvar			=	num))
		rda (keep	=	type_var 			num_type_var 		rename	=	(type_var		=	instruction num_type_var		=	num))
		rda (keep	=	decimal 			num_decimal 		rename	=	(decimal		=	instruction num_decimal			=	num))
		rda (keep	=	HIERARCHICAL 		num_HIERARCHICAL	rename	=	(HIERARCHICAL	=	instruction num_HIERARCHICAL	=	num)) 
		rda (keep	=	HIERLEADSTRING 		num_HIERLEADSTRING 	rename	=	(HIERLEADSTRING	=	instruction num_HIERLEADSTRING	=	num)) 
		rda (keep	=	HIERCODELIST 		num_HIERCODELIST 	rename	=	(HIERCODELIST	=	instruction num_HIERCODELIST	=	num)) 
		rda (keep	=	HIERLEVELS 			num_HIERLEVELS 		rename	=	(HIERLEVELS		=	instruction num_HIERLEVELS		=	num)) ; 
		by num ; 
		drop num ; 
		if instruction ne "" ; 
	run ; 

	filename rda "&library_asc_rda.\TEMPORARY FILES MACRO\&rda" ; 
		data _null_ ; 
			set rda ; 
			file rda ; 
			put instruction ; 
	run ; 
%mend ; 
 

/********************************************************************************************************************/
/********************************************************************************************************************/
/*								suppression des doublons dans une liste de variable									*/
/********************************************************************************************************************/
/* %unique		=	supprime les doublons dans une liste de variable												*/
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro unique (
	typ_var	=	,
	sep		=	) ; 

	proc transpose 	data 	=	&typ_var 
					out 	=	&typ_var (drop 	=	_name_) ; 
		var _all_ ; 
	run ; 

	data max ; 
		set &typ_var ; 
		max	=	count(col1,"&sep")+1 ; 
	run ; 
	
	proc sort data	=	max ; 
		by descending max ; 
	run ; 

	data max ; 
		set max ; 
		if _n_	=	1 ; 
		keep max ; 
	run ; 

	data _null_ ; 
		set max ; 
		call symput ("n_var",max) ; 
	run ; 

	data &typ_var ; 
		set &typ_var  ; 
		tabulation	=	col1 ; 
			%do b1	=	 1 %to &n_var ; 
				col&b1	=	scan(tabulation,&b1,"&sep") ; 
			%end ; 
		test	=	&n_var ; 
	run ; 

	%MACRO tables_set ; 
		%do b2	=	2 %to &n_var ; 
		    &typ_var (keep	=	col&b2 rename	=	(col&b2	=	col1))
		%end ; 
	%mend ; 

	data &typ_var ; 
		set 
		&typ_var (keep	=	col1) 
		%tables_set ; 
		n	=	_n_ ; 
	run ; 

	proc sort data	=	&typ_var (where	=	(col1 ne ""))nodupkey ; 
		by col1 ; 
	run ; 

	proc sort data	=	&typ_var ; 
		by n ; 
	run ; 

	proc transpose 	data	=	&typ_var (drop	=	n)
					out		=	&typ_var (drop	=	_name_) ; 
		var col1 ; 
	run ; 

	data &typ_var ; 
		length &typ_var $200 ; 
		set &typ_var ; 
		&typ_var	=	"" ; 
		array y _all_ ; 
			do over y ; 
				&typ_var	=	compbl(&typ_var||" "||y) ; 
			end ; 
		&typ_var	=	substr(tranwrd(compbl(tranwrd(tranwrd(&typ_var," ","&sep"),"&sep&sep",""))||" ","&sep ",""),2) ; 
		keep &typ_var ; 
	run ; 

%mend ; 


/********************************************************************************************************************/
/********************************************************************************************************************/
/*								Cr�ation de fichier de hi�rarchie (.hrc)											*/
/********************************************************************************************************************/
/* %hrc		=	g�n�re un fichier de hi�rarchie (.hrc), � partir de la TABSAS. Celle-ci devra comporter toutes les 	*/
/*				variables correspondant aux diff�rents niveaux agr�g�s souhait�s dans sa hi�rarchie. 				*/
/*				Cette macro ne peut g�n�rer que des hi�rarchies "sym�triques", ou "compl�tes"						*/
/*				Les longueurs des modalit�s de la &detailled_var doivent �tre �gales.								*/
/*					Les param�tres de la macro :																	*/
/*						tab			=	nom de la table sas (doivent s'y trouver : les variables correspondant � 	*/
/*										chaque niveau agr�g� ("commune","dep", "reg" par exemple)					*/
/*						detailed_var=	nom de la variable fine ("commune" par exemple)								*/
/*						agreg		=	noms des variables s�par�s par un espace qui font partie de l'arbre dans 	*/
/*										l'ordre du plus agr�g� au plus fin ("reg dep commune")						*/
/*						library_hrc	=	nom du r�pertoire et du nom de fichier hrc g�n�r� � la fin.					*/	
/*
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro hrc (
	tab				=	,
	detailed_var	=	,
	agreg			=	,
	library_hrc		=	);

	libname hrc "&library_hrc" ;

	data &tab ;
		set hrc.&tab ;
	run;


	proc sort data = &tab nodupkey; 
		by &agreg &detailed_var;
	run;

	data _null_ ;
		call symput ("nbagreg",count("&agreg"," ")+1 );
	run;

		%do c1=1 %to &nbagreg ;
			data _null_;
				call symput ("var&c1",scan("&agreg",&c1," "));
			run;

			data _null_;
				set &tab;
				call symput ("length",vlength(&&Var&c1)+&c1);
			run;

			data &tab ; 
				length &&var&c1 $&length ;
				set &tab (rename=(&&var&c1=var));
				&&var&c1=substr(repeat("@",&c1-1)||var,2);
				if lag(&&var&c1)=&&var&c1 then &&var&c1 = '';
				drop var;
			run;
		%end;

	data _null_ ;
		call symput ("agreg_sep",tranwrd("&agreg"," ",","));
	run;

	data _null_;
		set &tab;
		call symput ("length_detailed_var",vlength(&detailed_var)+&nbagreg);
	run;

	data &tab ;
		length &detailed_var $&length_detailed_var;
		set &tab (rename=(&detailed_var=var));
		&detailed_var=repeat("@",&nbagreg-1)||var;
	run;

	proc sql; 
		create table tab0 as 
		select  &agreg_sep, &detailed_var
		from &tab ; 
	quit; 

	data tab ;
	run;

	data _null_ ;
		call symput ("nb_line","2");
	run;


		%do %until (&nb_line=1);
			data tabb tab0 ;
				set tab0;
				if _n_=1 then output tabb ;
				else output tab0;
			run;

			proc transpose 	data 	= tabb
							out 	= tabb (drop=_name_);
				var &agreg &detailed_var; 
			run;

			data tab;
				set tab tabb;
				if col1 ne '';
			run;

			data _null_;
				set tab0 END=eof;
			if eof then 
				do;
			    	call symput ("nb_line",put(_N_,8.)); 
				end;
			run;
			/* Pour �viter que la log soit pleine et que la macro cesse de fonctionner, on supprime la log � chaque boucle.*/
			/*dm "log;clear;";*/
		%end;

	data tabb tab0 ;
		set tab0;
		if _n_=1 then output tabb ;
		else output tab0;
	run;

	proc transpose 	data 	= tabb
					out 	= tabb (drop=_name_);
		var &agreg &detailed_var;
	run;

	data tab;
		set tab tabb;
		if col1 ne '';
	run;


	data _null_;
		File "&library_hrc.\&detailed_var..hrc" dsd dlm=';' lrecl=32767;
		Set  tab ;
		Put ( _all_)(+0);
	run;
%mend;

/********************************************************************************************************************/
/********************************************************************************************************************/
/*								Pr�paration de fichier temporaire pour les macro suivantes							*/
/********************************************************************************************************************/
/* %batch_file	=	on g�n�re les fichiers vierges que les macro suivantes viendront remplir.						*/
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro batch_file (
	library	=	) ; 

	proc sql ;                                                                                                                               
		create table empty_batch (operation char(16)) ; 
	quit ; 

	proc sql ; 
		insert into empty_batch (operation)
			values('<OPENMICRODATA>')
			values('<OPENTABLEDATA>')
			values('<OPENMETADATA>') 
			values('<SPECIFYTABLE>')
			values('<SAFETYRULE>')
			values('<READMICRODATA>')
			values('<READTABLE>')
			values('<SOLVER>')
			values('<SUPPRESS>')
			values('<APRIORI>')
			values('<WRITETABLE>') 
			/*values('<GOINTERACTIVE>')*//* Option qui permet en manuel d'avoir le TauArgus_version qui reste ouvert 
			apr�s l'ex�cution du batch, mais qui emp�che l'encha�nement des batchs sous la version Open Source.*/
			values('test') ;                                                                                                                                                                                                                        
	quit ;  

	%let library	=	&library	 ; 

	data tab1 tab2 ; 
		length instruction $150 ; 
		length tabulation $150 ; 
		length order 8. ; 
		set empty_batch (where	=	(operation	=	'')) ; 
		instruction	=	'' ; 
	run ; 

	data tab3 tab4 tab5 ; 
		length instruction $150 ; 
		set empty_batch (where	=	(operation	=	'')) ; 
		instruction	=	'' ; 
	run ; 

%mend ; 

/********************************************************************************************************************/
/********************************************************************************************************************/
/*								Remplissage des lignes OPENMICRODATA et OPENMETADATA du batch						*/
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro opendata (
	library_opendata	=	,
	asc					=	microdata,
	rda					=	metadata) ; 

	data tab1 ; 
		length instruction $150 ; 
		set empty_batch (where	=	(operation in("<OPENMICRODATA>" "<OPENMETADATA>"))) ; 
		if operation 	=	"<OPENMICRODATA>" then instruction 	=	"'&library_opendata.\&asc..asc'" ; 
		if operation 	=	"<OPENMETADATA>" then instruction 	=	"'&library_opendata.\&rda..rda'" ; 
		instruction	=	tranwrd(instruction,"'",'"') ; 
	run ; 
%mend ; 

/********************************************************************************************************************/
/********************************************************************************************************************/
/*								Remplissage des lignes OPENTABLEDATA et OPENMETADATA du batch						*/
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro OPENTABLEDATA (
	library_OPENTABLEDATA	=	,
	tabulation_number		=	,
	output_name				=	) ; 

	data tab1 ; 
		length instruction $150 ; 
		set 
		tab1 
		empty_batch (where	=	(operation in("<OPENTABLEDATA>" "<OPENMETADATA>"))) ; 
	run ; 

	data tab1 ; 
		set tab1 ; 
		if operation 	=	"<OPENTABLEDATA>" and instruction	=	'' then instruction 	=	"'&library_OPENTABLEDATA.\&output_name..tab'" ; 
		if operation 	=	"<OPENMETADATA>" and instruction	=	'' then instruction 	=	"'&library_OPENTABLEDATA.\&output_name..rda'" ; 
		instruction	=	tranwrd(instruction,"'",'"') ; 
		if tabulation ='' then tabulation	=	"&tabulation_number";
		order=_n_;
	run ; 
%mend ; 


/********************************************************************************************************************/
/********************************************************************************************************************/
/*								Remplissage des lignes SPECIFYTABLE et SAFETYRULES du batch							*/
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro SPECIFYTABLE_SAFETYRULES (
	tabulation					=	,
	tabulation_number			=	,
	primary_secret_rules_all	=	DOM FREQ,
	primary_secret_rules_x		=	,
	cost_var_all				=	,
	cost_var_x					=	,
	shadow_var_all				=	,
	shadow_var_x				=	,
	weight						=	,
	holding						=	,
	dom_k						=	85,
	dom_n						=	1,
	dom_khold					=	85,
	dom_nhold					=	1,
	p_p							=	10,
	p_n							=	1,	
	p_nhold						=	10,
	p_phold						=	1,	
	frequency					=	3,
	frequencyrange				=	10,
	frequencyhold				=	3,
	frequencyrangehold			=	10,
	manual_safety_range			=	10,
	zero_unsafe					=	) ; 

	%if &holding ne %then %if &weight ne %then 
		%do ; 
			data _null_ ; 
				put "ERROR: Les deux param�tres '&weight_var' et '&holding_var' ne peuvent �tre appel� dans une m�me session" ; 
				put "WARNING: Tau-Argus ne g�re pas ces deux options conjointement, il faut choisir l'une ou l'autre" ; 
			run ; 
			%ABORT ; 
		%end ; 

	data _null_ ; 
		call symput ("response_var",upcase(compress(scan("&tabulation",-1," ")))) ; 
	run ; 

	data null ; 
		call symput("length_resp",length("*&response_var"));
	run;

	data _null_ ; 
		call symput ("var_de_tabulation",reverse(substr(reverse ("&tabulation"),&length_resp)));
	run;

	/* Crit�re de co�t pour le secret secondaire.*/
	%if &cost_var_x	=	%then 
		%do ; 
			data _null_ ; 
				call symput ("cost_varr","&cost_var_all") ; 
			run ; 
		%end ; 

	%else %if &cost_var_x ne %then 
		%do ; 
			data _null_ ; 
				call symput ("cost_varr","&cost_var_x") ; 
			run ; 
		%end ; 


	%if &cost_varr	=	 %then 
		%do ; 
			data _null_ ; 
				call symput ("costt","") ; 
			run ; 
		%end ; 
		
	%else %if &cost_varr	=	 frequency %then 
		%do ; 
			data _null_ ; 
				call symput ("costt","-1") ; 
			run ; 
		%end ; 

	%else %if &cost_varr	=	 unity %then 
		%do ; 
			data _null_ ; 
				call symput ("costt","-2") ; 
			run ; 
		%end ; 

	%else %if &cost_varr ne %then 
		%do ; 
			data _null_ ; 
				call symput ("costt","&cost_varr") ; 
			run ; 
		%end ; 

	/* Shadow_var */
	%if &shadow_var_x 	=		%then 
		%do ; 
			data _null_ ; 
				call symput ("shadow_varr","&shadow_var_all") ; 
			run ; 
		%end ; 
	%else %if &shadow_var_x ne %then 
		%do ; 
			data _null_ ; 
				call symput ("shadow_varr","&shadow_var_x") ; 
			run ; 
		%end ; 

	/* weight */
	%if &weight ne %then 
		%do ; 
			data _null_ ; 
				call symput ("Wgt","|Wgt(1)") ; 
			run ; 
		%end ; 

	%else %if &weight	=	%then 
		%do ; 
			data _null_ ; 
				call symput ("Wgt","") ; 
			run ; 
		%end ; 

	/* Zero_unsafe */
	%if &zero_unsafe ne %then 
		%do ; 
			data _null_ ; 
				call symput ("zero_unsafee","|ZERO(&zero_unsafe)") ;
			run ; 
		%end ; 

	%else %if &zero_unsafe	=	%then 
		%do ; 
			data _null_ ; 
				call symput ("zero_unsafee","") ; 
			run ; 
		%end ; 

	/* Manual_safety_range */
	%if &manual_safety_range ne %then 
		%do ; 
			data _null_ ; 
				call symput ("manual_safety_rangee","|MAN(&manual_safety_range)") ;
			run ; 
		%end ; 

	%else %if &manual_safety_range	=	%then 
		%do ; 
			data _null_ ; 
				call symput ("manual_safety_rangee","") ; 
			run ; 
		%end ; 


/* R�gles de secret primaire (valeurs possibles : DOM, DOM P, DOM FREQ, DOM P FREQ, P FREQ, P, FREQ, NORULES).*/
	data _null_ ;
		call symput ("primary_secret_rules_","&primary_secret_rules") ;
	run ;

	%if &primary_secret_rules_x	=	%then 
		%do ; 
			data _null_ ; 
				call symput ("primary_secret_rules_","&primary_secret_rules_all") ; 
			run ; 	
		%end ; 
	%else %if &primary_secret_rules_x ne %then 
		%do ; 
			data _null_ ; 
				call symput ("primary_secret_rules_","&primary_secret_rules_x") ; 
			run ; 	
		%end ; 
	%if &primary_secret_rules_ ne NORULES %then
		%do ;
			%if &response_var	=	FREQ %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_rules_","FREQ") ;
					run ; 
				%end ; 
		%end;

	%if &holding	=	%then
		%do;
			%if &primary_secret_rules_	=	DOM %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","NK(1,&dom_k.)|NK(0,0)|)") ; 																  
					run ; 
				%end ; 
			%else %if &primary_secret_rules_	=	DOM P %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","NK(1,&dom_k.)|NK(0,0)|P(&p_p.,&p_n.)|P(0,0,0)") ; 
					run ; <SAFETYRULE>     
				%end ; 
			%else %if &primary_secret_rules_	=	DOM FREQ %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","NK(1,&dom_k.)|NK(0,0)| FREQ(&frequency.,&frequencyrange.)") ; 
					run ; 
				%end ; 
			%else %if &primary_secret_rules_	=	DOM P FREQ %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","NK(1,&dom_k.)|NK(0,0)|P(&p_p.,&p_n.)|P(0,0,0)|FREQ(&frequency.,&frequencyrange.)") ; 
					run ; 
				%end ; 
			%else %if &primary_secret_rules_	=	P FREQ %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","P(&p_p.,&p_n.)|P(0,0,0)|FREQ(&frequency.,&frequencyrange.)") ; 
					run ;
				%end ; 
			%else %if &primary_secret_rules_	=	P %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","P(&p_p.,&p_n.)|P(0,0,0)") ; 
					run ;
				%end ; 
			%else %if &primary_secret_rules_	=	FREQ %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","FREQ(&frequency.,&frequencyrange.)") ; 
					run ;
				%end ; 
		%end;

	%if &holding	ne %then 
		%do;
			%if &primary_secret_rules_	=	DOM %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","NK(1,&dom_k.)|NK(0,0)|NK(1,&dom_khold.)|NK(0,0)|)") ; 																  
					run ; 
				%end ; 
			%else %if &primary_secret_rules_	=	DOM P %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","NK(1,&dom_k.)|NK(0,0)|NK(1,&dom_khold.)|NK(0,0)|P(&p_p.,&p_n.)|P(0,0,0)|P(&p_phold.,&p_nhold.)|P(0,0,0)") ; 
					run ; <SAFETYRULE>     
				%end ; 
			%else %if &primary_secret_rules_	=	DOM FREQ %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","NK(1,&dom_k.)|NK(0,0)|NK(1,&dom_khold.)|NK(0,0)|FREQ(&frequency.,&frequencyrange.)|FREQ(&frequencyhold.,&frequencyrangehold.)") ; 
					run ; 
				%end ; 
			%else %if &primary_secret_rules_	=	DOM P FREQ %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","NK(1,&dom_k.)|NK(0,0)|NK(1,&dom_khold.)|NK(0,0)|P(&p_p.,&p_n.)|P(0,0,0)|P(&p_phold.,&p_nhold.)|P(0,0,0)|FREQ(&frequency.,&frequencyrange.)|FREQ(&frequencyhold.,&frequencyrangehold.)") ; 
					run ; 
				%end ; 
			%else %if &primary_secret_rules_	=	P FREQ %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","P(&p_p.,&p_n.)|P(0,0,0)|P(&p_phold.,&p_nhold.)|P(0,0,0)|FREQ(&frequency.,&frequencyrange.)|FREQ(&frequencyhold.,&frequencyrangehold.)") ; 
					run ;
				%end ; 
			%else %if &primary_secret_rules_	=	P %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","P(&p_p.,&p_n.)|P(0,0,0)|P(&p_phold.,&p_nhold.)|P(0,0,0)") ; 
					run ;
				%end ; 
			%else %if &primary_secret_rules_	=	FREQ %then 
				%do ; 
					data _null_ ; 
						call symput ("primary_secret_ruless","FREQ(&frequency.,&frequencyrange.)|FREQ(&frequencyhold.,&frequencyrangehold.)") ; 
					run ;
				%end ; 
		%end;

	%if &primary_secret_rules_	=	NORULES %then 
		%do ; 
			data _null_ ; 
				call symput ("primary_secret_ruless","") ; 
			run ; 
		%end ; 
		
	/* On remplit <SAFETYRULE>.*/
	data tab2 ; 
		set 
		tab2 (where	=	(operation ne 'test')) 
		empty_batch (where	=	(operation in("<SAFETYRULE>" "<SPECIFYTABLE>"))) ; 
		if operation	=	"<SAFETYRULE>" and instruction	=	"" then 
			do ; 
				instruction	=	compress("&primary_secret_ruless"||"&wgt"||"&zero_unsafee"||"&manual_safety_rangee") ; 
			end ; 
		if substr(instruction,1,1)	=	"|" then instruction	=	substr(instruction,2) ; 
	run ; 


	/* On remplit <SPECIFYTABLE>.*/
	data _null_ ; 
		call symput ("var_tabulation_entre_cote",upcase(tranwrd(left(trim("&var_de_tabulation"))," ",'* *'))) ; 
	run ; 

	data tab2 ; 
		set tab2 ; 
		if operation	=	"<SPECIFYTABLE>" and instruction	=	"" then 
			do ; 
				instruction	=	upcase(compress(tranwrd("*&var_tabulation_entre_cote.*|*&response_var.*|*&shadow_varr.*|*&costt*",'*','"'))) ; 
			end ;
		if tabulation ='' then tabulation	=	"&tabulation_number";
		order=_n_+10;
	run ; 
%mend ; 

/********************************************************************************************************************/
/********************************************************************************************************************/
/*								Remplissage de la ligne SOLVER du batch												*/
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro solver_batch (
	lp_solver_batch		=	free) ; 

	data tab6 ; 
		length instruction $150 ; 
		set empty_batch (where	=	(operation in ("<SOLVER>"))) ; 
		%if &lp_solver_batch = free %then %do;
			if operation 	=	"<SOLVER>" then instruction 	=	"FREE" ; 
		%end;
		%if &lp_solver_batch = xpress %then %do;
			if operation 	=	"<SOLVER>" then instruction 	=	"XPRESS" ; 
		%end;
		%if &lp_solver_batch = cplex %then %do;
			if operation 	=	"<SOLVER>" then instruction 	=	"CPLEX" ; 
		%end; 
		if instruction		=	"" then delete ; 
	run ; 
%mend ; 

/********************************************************************************************************************/
/********************************************************************************************************************/
/*								Remplissage des lignes SUPPRESS du batch											*/
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro suppress (
	bounds					=	100,
	modelsize				=	0,
	method_all				=	hypercube,
	method_x				=	,
	MaxTimePerSubtable		=	20,
	linked_tables			=	yes); 

	%if &method_x ne %then
		%do ; 
			data _null_ ; 
				call symput ("methodd","&method_x") ; 
			run ; 
		%end ; 
	%else 
		%do ; 
			%if &method_x	=	%then
				%do ; 
					data _null_ ; 
						call symput ("methodd","&method_all") ; 			
					run ; 
				%end ; 
		%end ; 

	%if &linked_tables	=	yes %then 
		%do ; 
			%let ntab	=	0 ; 
		%end ; 
	%else 
		%do ; 
			%let ntab	=	_n_ ; 
		%end ; 

	data tab3 ; 
		set 
		tab3 (where	=	(operation ne 'test')) 
		empty_batch (where	=	(operation in("<SUPPRESS>"))) ; 
		method				=	"&methodd" ; 
		if operation 		=	"<SUPPRESS>" and instruction	=	'' and method	=	"hypercube" 
		then instruction 	=	compress("GH"||"("||&ntab||","||"&bounds"||","||"&modelsize"||")") ; 
		else 
		if operation 		=	"<SUPPRESS>" and instruction	=	'' and method	=	 "modular" 
		then instruction 	=	compress("MOD"||"("||&ntab||")") ; 
		else 
		if operation 		=	"<SUPPRESS>" and instruction	=	'' and method	=	 "optimal" 
		then instruction 	=	compress("OPT"||"("||&ntab||","||"&MaxTimePerSubtable"||")") ; 
		drop method ; 
		if instruction		=	"" then delete ; 
	run ; 
%mend ; 

/********************************************************************************************************************/
/********************************************************************************************************************/
/*								Remplissage des lignes WRITETABLE du batch											*/
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro WRITETABLE (
	outputtype		=	4,
	parameter		=	,
	output_name		=	) ; 
	
	%macro ext (outputtypee,ext) ;
		%if &outputtype	=	&outputtypee	%then 
			%do ;
				data _null_ ; 
					call symput ("extt","&ext") ;
				run ;
			%end;
	%mend;

	data _null_ ; 
		call symput ("extt","") ;
	run ;

	%ext (1,csv) ;
	%ext (2,csv) ;
	%ext (3,txt) ;
	%ext (4,sbs) ;
	%ext (5,tab) ;
	%ext (6,jj) ;

	%if &extt	=	%then 
		%do ;
			data _null_ ; 
				put "WARNING: Le param�tre '&outputtype' n'est pas correctement renseign�. Il ne peut prendre que les valeurs 1, 2, 3, 4, 5, 6" ; 
			run ;
			%abort;
		%end;

	data tab4 ; 
		set 
		tab4 (where	=	(operation ne 'test')) 
		empty_batch (where	=	(operation in("<WRITETABLE>"))) ; 
		if operation 		=	"<WRITETABLE>" and instruction	=	''
		then instruction 	=	compress("("||_n_||",&OutputType.,&parameter.,"||'"')||"&library.\TEMPORARY FILES MACRO\&output_name..&extt"||'"'||")" ; 
	run ; 
%mend ; 

/********************************************************************************************************************/
/********************************************************************************************************************/
/*													Execution du batch												*/
/********************************************************************************************************************/
/********************************************************************************************************************/
/* %TauArgusexe	=  ex�cute le batch et renseigne le fichier texte logbook du d�roulement du processus sous Tau-Argus*/
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro TauArgusexe (
	TauArgus_exe	=	,
	batch_name		=	) ; 
	X " ""&TauArgus_exe"" ""&library.\TEMPORARY FILES MACRO\&batch_name"" ""&library.\TEMPORARY FILES MACRO\LogBook.txt"" " ; 

	data logbook;
		%let _EFIERR_ = 0;
		infile "&library.\TEMPORARY FILES MACRO\LogBook.txt"  delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
		informat var1 $250. ;
		input
		var1 $;
	run;

	data logbook ;
		set logbook end	=	fin ;
		var1	=	substr(var1,25) ;
		if fin	=	1;
		if substr(var1,1)	=	"Program abnormally terminated" then TauArgus_issues	=	"yes" ;
		else TauArgus_issues	=	"no" ;
	run ;

	data logbook ;
		set logbook ;
		call symput ("TauArgus_issues",TauArgus_issues) ;
	run;
	
	%if &TauArgus_issues	=	yes %then 
		%do ;
			data _null_ ; 
				put "ERROR: Tau-Argus n'a pas trouv� de solution.";
				put "WARNING: Il existe de nombreuses raisons possibles � cela. Le logbook pr�sent dans le r�pertoire 'TEMPORARY FILES MACRO' pourra �ventuellement vous aider � comprendre l'origine du probl�me." ;
				put "WARNING: L'une des raisons probables est que l'algorithme choisi pour la r�solution du secret secondaire (&method) n'a pas trouv� de solution du fait de la complexit� du ou des tableaux." ; 
			run ; 
			%abort ; 
		%end ;
%mend ; 


/********************************************************************************************************************/
/********************************************************************************************************************/
/*										Mise en forme des sorties au format SBS (.sbs)								*/
/********************************************************************************************************************/
/********************************************************************************************************************/
/* %formating	=	g�n�re pour chaque fichier .sbs du r�pertoire library_formating\temporary files macro un fichier*/
/*					excel et une table sas. Pour les cases avec un FLAG de secret en B ou F qui sont �galement 		*/
/*					concern�es par de secret de fr�quence, on remplace le FLAG par un A, par convention.			*/
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro formating (
	library_formating	=	,
	tabulation_1		=	,
	tabulation_2		=	,
	tabulation_3		=	,
	tabulation_4		=	,
	tabulation_5		=	,
	tabulation_6		=	,
	tabulation_7		=	,
	tabulation_8		=	,
	tabulation_9		=	,
	tabulation_10		=	,
	output_name_1		=	,
	output_name_2		=	,
	output_name_3		=	,
	output_name_4		=	,
	output_name_5		=	,
	output_name_6		=	,
	output_name_7		=	,
	output_name_8		=	,
	output_name_9		=	,
	output_name_10		=	,
	displayed_value		=	) ;

	X mkdir "&library_formating.\RESULTS" ; 
	libname results "&library_formating.\RESULTS" ; 

	/* On r�cup�re les noms des fichiers .sbs.*/
	data sbs_files ; 
		length fic $ 300 tabulation $ 200 output_name $ 200 ; 
		infile "&library_formating.\temporary files macro\*.sbs" filename	=	fic ; 
		input ; 
		file	=	fic ; 
		sbs_name	=	scan(file,-2,"./\") ; 
			%do d1	=	1 %to 10 ; 
				if sbs_name	=	"&&output_name_&d1" then 
					do ; 
						tabulation		=	"&&tabulation_&d1" ; 
						output_name		=	"&&output_name_&d1" ; 
						order			=	&d1 ; 
					end ; 
			%end ; 
	run ; 

	%if &syserr>4 %then
		%do ;
			data _null_ ; 
				put "ERROR: les masques de secret au format .sbs n'ont pas �t� trouv�s." ; 
				put "WARNING: Tau-Argus n'a probablement pas r�ussi � faire le secret secondaire. Se r�f�rer au fichier logbook.txt dans le r�pertoire 'temporary files macro'" ; 
			run ; 
			%abort ; 
		%end;

	proc sort data	=	sbs_files noduplicate ; 
		by order ; 
	run ; 

	data _null_ ; 
		set sbs_files ; 
		call symput (compress("fic"!!_N_), left(trim(file))) ; 
		call symput (compress("tabulation"!!_N_), left(trim(tabulation))) ; 
		call symput (compress("output_name"!!_N_),left(trim(output_name))) ; 
		call symput ("nbFic", _N_) ; 
		call symput (compress("nb_"!!_N_), count(trim(tabulation)," ")) ; 
	run ; 

	proc sort data	=	sbs_files ; 
		by tabulation ; 
	run ; 

	data complete_file ; 
		set _null_ ; 
	run ; 

		/* Pour chaque fichier ...*/
		%do d2	=	1 %to &nbFic ; 
			data _null_ ; 
				set sbs_files ; 
				/* Pour chaque variable ...*/
					%do d3	=	1 %to &&nb_&d2+1 ; 
						call symput ("varr&d3",scan("&&tabulation_&d2",&d3," ")) ; 
						call symput ("response_var",scan("&&tabulation_&d2",-1," ")) ; 
					%end ; 
			run ; 

			filename sbs "&&fic&d2" ; 
			data &&output_name&d2 ; 
				length var1 $200 ; 
				infile sbs LRECL	=	512 dlm	=	"###" ; 
				input var1 $ ; 
			run ; 

			data &&output_name&d2 ; 
				length flag $1 ; 
				length secret $21 ; 
				length dominance 8. ; 
				set &&output_name&d2 ; 
				var1 				=	left(tranwrd(var1,"""", "")) ; 
				value	 			=	input(scan(var1,&&nb_&d2+1,","),best.) ; 
				&varr1				= 	left(scan(var1,1,",")) ; 
				nb_unit				=	left(scan(var1,&&nb_&d2+2,",")) ; 
				individu_count		=	input(nb_unit,best.) ; 
				nbcoma 				= 	count(var1,",")- (&&nb_&d2+2) ; 
				if nbcoma			=	0 then flag	=	left(scan(var1,-1,",")) ; 
				else if nbcoma		=	1 then 
					do ; 
						flag		=	left(scan(var1,-2,",")) ; 
						dominance	=	left(scan(var1,-1,",")) ; 
					end ; 
				else if nbcoma		=	2 then 
					do ; 
						flag		=	left(scan(var1,-3,",")) ; 
						dominance	=	left(scan(var1,-2,",")) ; 
						p			=	left(scan(var1,-1,",")) ; 
					end ; 
				/*if flag in ("B" "F") and individu_count <3 then flag	=	"A" ; */
					/* Pour chaque variable ...*/
					%do d4	=	1 %to &&nb_&d2+1 ; 
						&&varr&d4	=	left(scan(var1,&d4,",")) ; 
					%end ; 
				%if &displayed_value	=	no %then 
					%do ; 
						if flag in ("A" "B" "D" "F") then 
							do ; 
								nb_unit	=	"" ; 
								&&response_var	=	"" ; 
							end ; 
					%end ; 
				if flag	=	"A" then 
					do ; 
						secret		=	"Fr�quence         (A)" ; 
						dominance 	=	. ; 
					end ; 
				else if flag	=	"B" then secret	=	"dominance         (B)" ; 
				else if flag	=	"F" then secret	=	"P%                (F)" ; 
				else if flag	=	"D" then secret	=	"Secondaire        (D)" ; 
				else if flag	=	"V" then secret	=	"Cases diffusables (V)" ; 
				drop var1 nbcoma ; 
			run ; 

			data complete_file ; 
				set 
				complete_file 
				&&output_name&d2 (keep	=	value individu_count secret) ; 
			run ; 
				
			proc means data	=	&&output_name&d2 n noprint ; 
				var individu_count ; 
				class flag ; 
				output 	out 	=		temp (keep	=	flag _freq_) 
						n	=	nb ; 
			run ; 

			data temp ; 
				set temp ; 
				if flag 	=	'' then flag	=	'T' ; 
			run ; 

			proc transpose 	data	=	temp
							out		=	temp (drop	=	_name_ rename	=	(T	=	Total)) ; 
				id flag ; 
			run ; 

			data temp ; 
				set temp ; 
				tabulation	=	"&&tabulation_&d2" ; 
			run ; 

			data sbs_files ; 
				merge 
				sbs_files 
				temp ; 
				by tabulation ; 
			run ; 

			data &&output_name&d2 ; 
				retain
					/* Pour chaque variable ...*/
					%do d5	=	1 %to &&nb_&d2+1 ; 
						 &&varr&d5 
					%end ; 
				nb_unit flag dominance ; 
				set &&output_name&d2 ; 
			run ; 
			
			/* R�duction des longueurs de variables � leur longueur max.*/
			proc contents noprint 
				data	=	&&output_name&d2 
				out		=	t (where	=	(type	=	2)) ; 
			run ; 

			data _null_ ; 
				set 
				t 
				end	=	last ; 
				call symput ('nn'||left(_n_),name) ; 
				if last then call symputx('cnt',_n_) ; 
			run ; 
			 
			%macro rep ; 
				%do d6	=	1 %to &cnt ; 
					%global val&d6 ; 
					proc sql noprint ; 
						select max(length(&&nn&d6)) into: val&d6 from &&output_name&d2 ; 
					quit ; 
				%end ; 
			%mend ; 
			%rep ; 

			%macro convs ; 
				%do d7	=	1 %to &cnt ; 
					proc sql ; 
						alter table &&output_name&d2 
						modify &&nn&d7 char(&&val&d7) 
						format		=	$%sysfunc(trim(&&val&d7)). 
						informat	=	$%sysfunc(trim(&&val&d7)). ; 
					quit ; 
				%end ; 
			%mend ; 
			%convs ;

			/* On �carte la variable P dans les cas o� celle-ci est absente.*/
			data &&output_name&d2 ; 
				length p 3. ; 
				set &&output_name&d2 (rename	=	(p	=	pp)) ; 
				p	=	pp ; 
			run ; 

			proc means data	=	&&output_name&d2 sum noprint nway ; 
				var p ; 
				output out	=	p sum	=	p ; 
			run ; 

			data _null_ ; 
				set p ; 
				call symput ("pp", p) ; 
			run ; 

			%if &pp >0 	%then 
				%do ; 
					%let p	=	 ; 
				%end ; 	
			%else 
				%do ; 	
					%let p	=	p ; 
				%end ; 

			data results.&&output_name&d2 ; 
				set &&output_name&d2 (drop	=	value individu_count secret &p pp) ; 
			run ; 
			
			proc export data	=	 results.&&output_name&d2 
				outfile	=	"&library_formating.\results\&&output_name&d2...xls" replace 
				dbms	=	excel5 ; 
			run ; 
		%end ; 
%mend ; 

/********************************************************************************************************************/
/********************************************************************************************************************/
/*										Cr�ation d'un fichier excel de synth�se										*/
/********************************************************************************************************************/
/********************************************************************************************************************/
/* %synthesis	=	g�n�re dans le r�pertoire library_synthesis un fichier excel comptabilisant le nombre de 	*/
/*					cases selon leur statut (flag) pour chaque masque de secret au format excel du r�pertoire.
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro synthesis (
	library_synthesis	=	) ; 

	/* On supprime l'�ventuel file synth�se.xls.*/
	option noxwait xsync ; 
	X "cd &library_synthesis" ; 
	X "del synthesis.xls" ; 	
	libname tabsas "&library_synthesis";

	/* On r�cup�re les noms de fichiers .sas7bdat.*/
	data filessas ; 
		length fic $ 300 name $ 32 ; 
		infile "&library_synthesis.\*.sas7bdat" filename	=	fic ; 
		input ; 
		file	=	fic ; 
		name	=	scan(file,-2,"./\") ; 
	run ; 

	proc sort data	=	filessas noduplicate ; 
		by file ; 
	run ; 

	data _null_ ; 
		set filessas ; 
		call symput (compress("fic"!!_N_), left(trim(file))) ; 
		call symput (compress("name"!!_N_), left(trim(name))) ; 
		call symput ("nbFic", _N_) ; 
		call symput ("name", name) ; 
		call symput (compress("nb_"!!_N_), count(name,"_")) ; 
		call symput (compress("tabsas"!!_N_),name);
	run ; 

	data complete_file ; 
		length file $80 ; 
		set _null_ ; 
		file	=	"a" ; 
	run ; 

		/* Pour chaque file ...*/
		%do e1	=	1 %to &nbFic ; 
			data complete_file ; 
				set 
				complete_file (where	=	(file ne "a"))
				tabsas.&&tabsas&e1 (in	=	a) ; 
				if a	=	1 then file	=	 "&&name&e1" ; 
			run ; 
		%end ; 

	data complete_file ; 
		set complete_file ; 
		n	=	1 ; 
	run ; 

	proc means data	=	complete_file sum noprint ; 
		var n ; 
		class flag file ; 
		output 	out	=	complete_file 
				sum	=	nb_flag ; 
	run ; 

	data complete_file ; 
		set complete_file ; 
		if flag	=	"" then flagg	=	"TOTAL" ; 
		else 				flagg	=	flag ; 
		drop flag ; 
		if file	=	"" then file	=	"ZZZZZ" ; 
	run ; 

	proc sort data	=	 complete_file ; 
		by file ; 
	run ; 

	proc transpose 	data 	=	complete_file 
					out 	=	complete_file (drop	=	_name_) ; 
		var nb_flag ; 
		by file ; 
		id flagg ; 
	run ; 

	proc sort data	=	complete_file ; 
		by descending file ; 
	run ; 

	data complete_file ; 
		set complete_file ; 
		if file	=	 "ZZZZZ" then file	=	"Total" ; 
	run ; 

	proc export data	=	complete_file
	            outfile	=	"&library_synthesis.\synthesis.xls" 
	            dbms	=	EXCEL5 replace ; 
	run ;
%mend ;  


/********************************************************************************************************************/
/********************************************************************************************************************/
/*														Macro principale											*/
/********************************************************************************************************************/
/********************************************************************************************************************/
%macro Tau_Argus (
	library											=						,	
	tabsas											=						,
	batch_name										=	batch_sas.arb		,
	input											=	microdata			,	
	weight_var										=						,
	holding_var										=						,
	hierarchical_var								=						,
	tabulation_1									=						,
	tabulation_2									=						,
	tabulation_3									=						,
	tabulation_4									=						,
	tabulation_5									=						,
	tabulation_6									=						,
	tabulation_7									=						,
	tabulation_8									=						,
	tabulation_9									=						,
	tabulation_10									=						,
	output_name_1									=						,
	output_name_2									=						,
	output_name_3									=						,
	output_name_4									=						,
	output_name_5									=						,
	output_name_6									=						,
	output_name_7									=						,
	output_name_8									=						,
	output_name_9									=						,
	output_name_10									=						,
	hierarchy_1										=						,
	hierarchy_2										=						,
	hierarchy_3										=						,
	hierarchy_4										=						,
	hierarchy_5										=						,
	hierarchy_6										=						,
	hierarchy_7										=						,
	hierarchy_8										=						,
	hierarchy_9										=						,
	hierarchy_10									=						,
	primary_secret_rules							=	DOM FREQ			,
	shadow_var										=						,
	cost_var										=						,
	shadow_var_1									=						,
	shadow_var_2									=						,
	shadow_var_3									=						,
	shadow_var_4									=						,
	shadow_var_5									=						,
	shadow_var_6									=						,
	shadow_var_7									=						,
	shadow_var_8									=						,
	shadow_var_9									=						,
	shadow_var_10									=						,
	cost_var_1										=						,
	cost_var_2										=						,
	cost_var_3										=						,
	cost_var_4										=						,
	cost_var_5										=						,
	cost_var_6										=						,
	cost_var_7										=						,
	cost_var_8										=						,
	cost_var_9										=						,
	cost_var_10										=						,
	primary_secret_rules_1							=						,
	primary_secret_rules_2							=						,
	primary_secret_rules_3							=						,
	primary_secret_rules_4							=						,
	primary_secret_rules_5							=						,
	primary_secret_rules_6							=						,
	primary_secret_rules_7							=						,
	primary_secret_rules_8							=						,
	primary_secret_rules_9							=						,
	primary_secret_rules_10							=						,
	dom_k											=	85					,
	dom_n											=	1					,
	dom_khold										=	85					,
	dom_nhold										=	1					,
	p_p												=	10					,	
	p_n												=	1					,
	p_phold											=	10					,
	p_nhold											=	1					,
	frequency										=	3					,
	frequencyrange									=	10					,
	frequencyhold									=	3					,
	frequencyrangehold								=	10					,
	zero_unsafe										=						,
	manual_safety_range								=	10					,
	bounds											=	100					,
	modelsize										=	0					,
	method											=	hypercube			,
	solver											=						,
	MaxTimePerSubtable								=	20					,
	linked_tables									=	yes					,
	lp_solver										=	free				,
	method_1										=						,
	method_2										=						,
	method_3										=						,
	method_4										=						,
	method_5										=						,
	method_6										=						,
	method_7										=						,
	method_8										=						,
	method_9										=						,
	method_10										=						,
	solver_1										=						,
	solver_2										=						,
	solver_3										=						,
	solver_4										=						,
	solver_5										=						,
	solver_6										=						,
	solver_7										=						,
	solver_8										=						,
	solver_9										=						,
	solver_10										=						,
	outputtype										=	4					,
	parameter										=						,
	TauArgus_exe									=						,
	TauArgus_version								=	opensource			,
	synthesis										=	no					,
	displayed_value									=						,
	work											=	empty				,
	apriori_1										=						,
	apriori_2										=						,
	apriori_3										=						,
	apriori_4										=						,
	apriori_5										=						,
	apriori_6										=						,
	apriori_7										=						,
	apriori_8										=						,
	apriori_9										=						,
	apriori_10										=						,
	apriori_creation								=						,
	compute_missing_totals							=						) ; 

	/* on vide la log.*/
	/*dm "log ; clear ; " ; */
	option noxwait xsync ; 
	X "cd &library.\temporary files macro" ; 
	X "del *.arb" ; 	
	X "del *.bak" ; 	
	X "del *.sbs" ; 	

	/* On fait ici une s�rie de v�rification, pour informer l'utilisateur le cas �ch�ant du probl�me rencontr�.*/

	/* On v�rifie que le param�tre obligatoire TauArgus_exe est bien renseign�.*/
	%if %length(&TauArgus_exe) = 0 %then %do;
		data _null_ ; 
			put "ERROR: Le param�tre TauArgus_exe est d�sormais obligatoire. Veuillez le renseigner." ; 
		run ; 
		%ABORT ; 
	%end;

	/* On teste les pram�tres qui ne sont plus utilisables : solver, solver_1, ..., solver_10. */
	%if %length(&solver) 
		or %length(&solver_1)
		or %length(&solver_2)
		or %length(&solver_3)
		or %length(&solver_4)
		or %length(&solver_5)
		or %length(&solver_6)
		or %length(&solver_7)
		or %length(&solver_8)
		or %length(&solver_9)
		or %length(&solver_10)  
	%then %do ; 
		data _null_ ; 
			put "ERROR: Les param�tres solver, solver_1, ..., solver_10 qui permettaient de sp�cifier la m�thode ne sont plus utilisables.";
			put "ERROR: Veuillez utiliser les param�tres method, method_1, ..., method_10 qui les remplacent." ;
			put "ERROR: Si vous souhaitez plut�t sp�cifier le solveur, veuillez utiliser le param�tre lp_solver." ; 
		run ; 
		%ABORT ; 
	%end ; 

	/* on teste la validit� des longueurs &library+&tabulation, et en cas de longueur trop importante, on stoppe la macro et on pr�vient 
	l'utilisateur avec un message d'alerte.*/
	data _null_ ; 
		call symput ("length_library",length("&library")) ; 
	run ; 

	%if &length_library > 128 %then 
		%do ; 
			data _null_ ; 
				put "ERROR: La longueur du param�tre library ne doit pas exceder 128 caract�res." ; 
			run ; 
			%ABORT ; 
		%end ; 

	/* On d�finit le nom de la sortie en fonction des param�tres '&tabulation_x' et '&output_name_x'.*/
		%do g1	=	1 %to 10 ; 
			%if &&tabulation_&g1 ne %then 
				%do ; 
					data _null_ ; 
						%if &&output_name_&g1	=	%then 
							%do ; 
								call symput ("output_name_&g1",compress(tranwrd(tranwrd(trim(tranwrd("&&tabulation_&g1","_","*"))," ","_"),"*",""))) ; 
							%end ; 
					run ; 
				%end ; 
		%end ; 

	/* On v�rifie que le param�tre '&primary_secret_rules' est bien r�dig� */
	data test_primary_secret_rules ;
		primary_secret_rules	=	"&primary_secret_rules" ;
		if primary_secret_rules not in ("DOM" "DOM P" "DOM FREQ" "DOM P FREQ" "P FREQ" "P" "FREQ" "NORULES") then 
			do ;
				call symput ("error_primary_secret_rules", "yes") ;
			end ;
		else do ;
			call symput ("error_primary_secret_rules", "no") ;
			end ;
	run ;
	%if &error_primary_secret_rules = yes %then
		%do ;
			data _null_ ; 
				put "ERROR: Le param�tre '&primary_secret_rules' est mal renseign�. Il doit correspondre � l'une des propositions suivantes (respecter la casse : DOM, DOM P, DOM FREQ, DOM P FREQ, P FREQ, P, FREQ, NORULES)." ; 
			run ; 
			%ABORT ; 
		%end ; 

	/* On v�rifie que les r�pertoires de travail et de Tau-Argus ne comporte pas de caract�re accentu� dans le cas o� 
	l'on utilise la version opensource de Tau-Argus.*/
	%if &TauArgus_version = opensource %then
		%do ;
			data test_accent ; 
				accent=	"&library.&TauArgus_exe" ; 
				if 	find (accent,"�","i") ge 1 or (
					find (accent,"�","i") ge 1) or (
					find (accent,"�","i") ge 1) or (
					find (accent,"�","i") ge 1) or (
					find (accent,"�","i") ge 1) or (
					find (accent,"�","i") ge 1) or (
					find (accent,"�","i") ge 1) or (
					find (accent,"�","i") ge 1) or (
					find (accent,"�","i") ge 1) or (
					find (accent,"�","i") ge 1) or (
					find (accent,"�","i") ge 1) 
				then 
					do ;
						call symput ("test_accent","yes") ; 
					end;
				else 
					do;
						call symput ("test_accent","no") ; 
				end;
			run ; 
			%if &test_accent	=	yes %then  
				%do ; 
					data _null_ ; 
						put "ERROR: Un ou plusieurs caract�res accentu�s dans les r�pertoires de travail emp�che Tau-Argus de fonctionner."
						put "ERROR: Le r�pertoire de travail et/ou celui de Tau-Argus contiennent un ou plusieurs caract�res accentu�s. Les versions open-source (> version 4.1) de Tau-Argus ne fonctionnent pas avec." ; 
					run ; 
					%ABORT ; 
				%end ; 
		%end;

	/* On v�rifie que lorsque l'on a plusieurs tabulations, le param�tre '&linked_tables' ne soit = 'yes' que lorsque les 
	variables de r�ponses sont les m�mes dans toutes les tabulations.*/
	data variables ; 
	run ; 

		%do g2	=	1 %to 10 ; 
			data _null_ ; 
				call symput ("tabulationn_&g2",tranwrd("&&tabulation_&g2"," ","*")) ; 
			run ; 

			data _null_ ; 
				call symput ("response_var_&g2",lowcase(compress(scan("&&tabulationn_&g2",-1,"*")))) ; 
			run ; 

			data variables ; 
				set variables ; 
				response_var_&g2		=	 "&&response_var_&g2" ; 
			run ; 
		%end ; 

	data 
		response_var 	(keep	=	response_var_1 response_var_2 response_var_3 response_var_4 response_var_5 response_var_6 response_var_7 response_var_8 response_var_9 response_var_10) ;
		set variables ; 
	run ; 

	%unique (
		typ_var	=	response_var,
		sep		=	*) ;
 
	data _null_ ; 
		set response_var ; 
		call symput ("nb_responsee_var",count(strip(response_var),"*")+1) ; 
	run ;
	
	%if &nb_responsee_var > 1 %then 
		%do ;
			%if &linked_tables	=	yes %then
				%do ;
					data _null_ ; 
						put "WARNING: Lorsque les diff�rentes tabulations n'ont pas les m�mes variables de r�ponses, le secret secondaire n'est pas trait� en 'tableaux li�s'" ; 
					run ; 

					data _null_ ;
						call symput ("linked_tables", "no");
					run;
				%end;
		%end;

	/* Si par ailleurs, il n'y a qu'une seule tabulation, on force le param�tre '&linked_tables' � 'no' */
	%if &tabulation_2	=	%then 
		%do ;
			data _null_ ; 
				call symput ("linked_tables","no") ;
			run ;
		%end ;

	/* On v�rifie que pour une tabulation donn�e, si c'est la m�thode modular qui est demand�e on a bien au moins une variable 
	hi�rarchique.*/

	%do g3	=	1 %to 1 ;
		data test_method;
			tabulation			=	"&&tabulation_&g3" ;
			tabulation_wo_hrc	=	tabulation ;
			hierarchical_var	=	"&hierarchical_var" ;
		run ;

			%do g4	=	1	%to	6 ;
				data test_method ;
					set test_method ;
					call symput("hrc&g4",compress(scan(compbl("&hierarchical_var"),&g4," ")));
				run;
				
				data test_method ;
					set test_method ;
					hierarchical_var=tranwrd(hierarchical_var,"&&hrc&g4","");
					tabulation_wo_hrc=tranwrd(tabulation_wo_hrc,"&&hrc&g4"," ");
				run;
			%end;	

		data _null_ ;
			set test_method;
			call symput ("tabulation",compress(tabulation));
			call symput ("tabulation_wo_hrc",compress(tabulation_wo_hrc));
		run;

		%if &tabulation_wo_hrc = &tabulation %then 
			%do ;
				%if &&method_&g3 = modular %then 
					%do;
						data _null_ ; 
							put "WARNING: La m�thode modular fonctionne mal avec des tabulations sans hi�rarchies." ; 
						run ;
					%end;
				%else %if &&method_&g3 = %then
					%do;
						%if &method = modular %then
							%do;
								data _null_ ; 
									put "WARNING: La m�thode modular fonctionne mal avec des tabulations sans hi�rarchies." ; 
								run ;
							%end;
					%end;
			%end;
	%end;

	/* Cr�ation d'un r�pertoire de fichiers temporaires et d'un r�pertoire pour les masques d�finitifs.*/
	X mkdir "&library.\TEMPORARY FILES MACRO" ; 
	X mkdir "&library.\RESULTS" ; 

	libname results "&library.\RESULTS" ; 

	%if &input	=	microdata %then 
		%do ; 
			%asc_rda (				
				library_asc_rda		=	&library,
				tabsas				=	&tabsas,
				tabulation_1		=	&tabulation_1,
				tabulation_2		=	&tabulation_2,
				tabulation_3		=	&tabulation_3,
				tabulation_4		=	&tabulation_4,
				tabulation_5		=	&tabulation_5,
				tabulation_6		=	&tabulation_6,
				tabulation_7		=	&tabulation_7,
				tabulation_8		=	&tabulation_8,
				tabulation_9		=	&tabulation_9,
				tabulation_10		=	&tabulation_10,
				weight_var			=	&weight_var,
				holding_var			=	&holding_var,
				hierarchical_var	=	&hierarchical_var) ; 
		%end ; 

		%do g5	=	1 %to 10 ; 
			%if &&hierarchy_&g5 ne %then
				%do;
					data _null_ ; 
						call symput ("detailed_var",lowcase(compress(scan("&&hierarchy_&g5",-1," ")))) ; 
					run ; 

					data _null_ ; 
						call symput ("agreg",compbl(tranwrd(lowcase("&&hierarchy_&g5"),"&detailed_var",""))) ; 
					run ; 
					
					%hrc (
						tab				=	&tabsas,
						detailed_var	=	&detailed_var,
						agreg			=	&agreg,
						library_hrc		=	&library);
				%end ; 
		%end;

	%batch_file (
		library				=	&library) ; 

	%solver_batch(lp_solver_batch	=	&lp_solver);

	%if &input	=	microdata %then 
		%do ; 
			%opendata (
				library_opendata	=	&library.\TEMPORARY FILES MACRO) ; 
		%end ; 

	%if &input	=	tabledata %then 
		%do ; 
				%do g6	=	1 %to 10 ; 
					%if &&tabulation_&g6 ne %then 
						%do ; 
							%OPENTABLEDATA (
								library_OPENTABLEDATA	=	&library.\TEMPORARY FILES MACRO,
								tabulation_number		=	tabulation_&g6,
								output_name				=	&&output_name_&g6	) ; 
						%end ; 
				%end ; 
		%end ; 

		%do g7	=	1 %to 10 ; 
			%if &&tabulation_&g7 ne %then 
				%do ; 
					%SPECIFYTABLE_SAFETYRULES (
						tabulation					=	&&tabulation_&g7,
						tabulation_number			=	tabulation_&g7,
						primary_secret_rules_all	=	&primary_secret_rules,
						primary_secret_rules_x		=	&&primary_secret_rules_&g7,
						cost_var_all				=	&cost_var,
						cost_var_x					=	&&cost_var_&g7,
						shadow_var_all				=	&shadow_var,
						shadow_var_x				=	&&shadow_var_&g7,
						weight						=	&weight_var,
						holding						=	&holding_var,
						dom_k						=	&dom_k,
						dom_n						=	&dom_n,
						dom_khold					=	&dom_khold,
						dom_nhold					=	&dom_nhold,
						p_p							=	&p_p,
						p_n							=	&p_n,
						p_phold						=	&p_phold,
						p_nhold						=	&p_nhold,
						frequency					=	&frequency,
						frequencyrange				=	&frequencyrange,
						frequencyhold				=	&frequencyhold,
						frequencyrangehold			=	&frequencyrangehold,
						manual_safety_range			=	&manual_safety_range,
						zero_unsafe					=	&zero_unsafe);
				%end ; 
		%end ; 

		%do g8	=	1 %to 10 ; 
			%if &&tabulation_&g8 ne %then 
				%do ; 
					%suppress 	(
						bounds					=	&bounds	,
						modelsize				=	&modelsize,
						method_all				=	&method,
						method_x				=	&&method_&g8,
						MaxTimePerSubtable		=	&MaxTimePerSubtable,
						linked_tables			=	&linked_tables) ; 

					data _null_ ; 
						call symput ("length_writetable_tabulation_&g8",length("&library.\TEMPORARY FILES MACRO\&&tabulation_&g8...sbs")) ; 
					run ; 

					%if &&length_writetable_tabulation_&g8 > 142 %then
						%do ; 
							data _null_ ; 
								put "ERROR: longueur du param�tre '&library'+'&output_name' trop longue" ; 
								"WARNING: la longueur du r�pertoire+nom du fichier de sortie Tau-Argus ne doit pas exc�der 142 caract�res" ; 
							run ; 
							%ABORT ; 
						%end ; 
					%writetable (
						outputtype		=	&outputtype,
						parameter		=	&parameter,
						output_name		=	&&output_name_&g8) ; 					
				%end ; 
		%end ; 

	/* Int�gration des lignes APRIORI le cas �ch�ant.*/
		%do g9	=	1 %to 10 ; 
			%if &&tabulation_&g9 ne %then 
				%do ; 
					%if &&apriori_&g9 ne %then 
						%do ; 
							data tab5 ; 
								set 
								tab5 (where	=	(operation ne 'test')) 
								empty_batch (where	=	(operation in("<APRIORI>"))) ; 
								%if &TauArgus_version	=	opensource %then 
									%do ; 
										if operation 	=	"<APRIORI>" and instruction	=	''
										then instruction	=	"'&library.\&&tabulation_&g9...hst',&g9,';',0,0" ; 
									%end ; 
								%else 
									%do ; 
										if operation 	=	"<APRIORI>" and instruction	=	''
										then instruction	=	"'&library.\&&tabulation_&g9...hst',&g9,';'" ; 
									%end ; 
								instruction	=	 tranwrd(instruction,"'",'"') ; 
							run ; 
						%end ; 
				%end ; 
		%end ; 

	%if &input	=	microdata %then 
		%do ; 
			data _null_ ; 
				call symput ("read","READMICRODATA") ; 
			run ; 

			data tab12 ;
				set tab1 tab2 ;
			run ;
		%end ; 
	%else %if &input	=	tabledata %then 
		%do ; 
			data _null_ ; 
				call symput ("read","READTABLE") ; 
			run ; 

			data tab12 ;
				set tab1 tab2 ;
			run ;

			proc sort 
				data	=	tab12 ;
				by tabulation order ;
			run; 			
		%end ; 


	data batch ; 
		retain operation instruction ; 
		set 
		tab12 (keep	=	operation instruction)
		empty_batch (where	=	(operation in("<&read>"))) 
		tab5
		tab6
		tab3 
		tab4 
		empty_batch (where	=	(operation in("<GOINTERACTIVE>"))) ; 
		%if &compute_missing_totals	=	yes %then
			%do;
				if operation	=	"<READTABLE>" then instruction	=	"1";
			%end;
	run ; 

	filename arb "&library.\TEMPORARY FILES MACRO\&batch_name" ; 
	data _null_ ; 
		set batch ; 
		file arb ; 
		put operation 1-16 instruction 18-200 ; 
	run ; 

	%TauArgusexe (
		TauArgus_exe	=	&TauArgus_exe,
		batch_name		=	&batch_name);

	/* On teste la longueur des names de files.*/
		%do g10	=	1 %to 10 ; 
			%if &&tabulation_&g10 ne %then 
				%do ; 
					data _null_ ; 
						call symput ("length_output_name_&g10",length("&&output_name_&g10")) ; 
					run ; 
					%if &&length_output_name_&g10 > 32 %then 
						%do ; 
							data _null_ ; 
								put "ERROR: la longueur du parametre output_name est trop longue" ; 
								put "WARNING: la longueur du output_name est trop longue, elle ne doit pas exc�der 32 caract�res. Par d�faut ce param�tre �quivaut � tabulation. Il est possible de le renseigner dans l'appel de la macro." ; 
							run ; 
							%ABORT ; 
						%end ; 	
				%end ; 
		%end ; 

	
	/* On applique la macro %formating uniquement si les masques produits sont au format .sbs.*/
	%if &outputtype	=	4 %then 
		%do ; 
			%formating(
				library_formating	=	&library,
				tabulation_1		=	&tabulation_1,	output_name_1	=	&output_name_1,
				tabulation_2		=	&tabulation_2,	output_name_2	=	&output_name_2,
				tabulation_3		=	&tabulation_3,	output_name_3	=	&output_name_3,
				tabulation_4		=	&tabulation_4,	output_name_4	=	&output_name_4,
				tabulation_5		=	&tabulation_5,	output_name_5	=	&output_name_5,
				tabulation_6		=	&tabulation_6,	output_name_6	=	&output_name_6,
				tabulation_7		=	&tabulation_7,	output_name_7	=	&output_name_7,
				tabulation_8		=	&tabulation_8,	output_name_8	=	&output_name_8,
				tabulation_9		=	&tabulation_9,	output_name_9	=	&output_name_9,
				tabulation_10		=	&tabulation_10,	output_name_10	=	&output_name_10,
				displayed_value		=	&displayed_value) ; 
			
			%if &synthesis	=	yes %then 
				%do ; 
					%synthesis (library_synthesis	=	&library.\results)
				%end ; 
		%end ;

	/* On transforme les sorties sbs en fichiers d'a priori dans le cas o� le param�tre '&outputtype'	=	APRIORI*/
	%if &apriori_creation	=	yes %then 
		%do ;
			%if &outputtype ne 4 %then 
				%do;
					data _null_ ; 
						put "ERROR: le param�tre '&outputtype' n'est pas le bon" ; 
						put "WARNING: si le param�tre '&apriori_creation' est renseign� � 'yes', le param�tre '&outputtype' doit etre renseign� � '4' (format .sbs)" ; 
					run ; 
					%ABORT ; 
				%end;

			%do	g11	=	1	%to 10 ;
				%if &&tabulation_&g11 ne %then 
					%do ; 
						data &&output_name_&g11 ;
							set results.&&output_name_&g11 ;
							drop &&response_var_&g11 nb_unit dominance flag ;
							if flag	=	"V" then status	=	"s" ; 
							else status	=	"u" ;
							array y _character_ ; 
								do over y ; 
									if y	=	"Total" then y = "" ; 
								end ;
						run;

						proc export	data		=	&&output_name_&g11
							        outfile		=	"&library.\&&tabulation_&g11...hst" 
					        		dbms		=	dlm replace ;
									delimiter	=	';' ; 
									putnames	=	no ;
						run ;
					%end;
			%end;
		%end;

	/* On vide la work.*/
	%if &work	=	empty %then 
		%do ; 
			proc datasets kill nolist ; 
			quit ; 
		%end ; 
%mend ;
