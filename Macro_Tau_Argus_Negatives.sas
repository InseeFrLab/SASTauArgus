/* Macro %Tau_Argus_Negatives                                                     									*/
/********************************************************************************************************************/
/* Cette macro fait appel à la macro %Tau_Argus, et propose une gestion de tabulation comportant des cases négatives*/
/* selon une méthode mise en place au département des méthodes statistiques de l'Insee par Gaël de Peretti,  		*/
/* Julien Lemasson et Maxime Bergeat.																				*/
/* Compte tenu du fait que l'application stricte des règles du secret donne des résultats qui ne sont pas 			*/
/* satisfaisants sur ce type de tableau, la méthode consiste a faire le secret primaire en double : sur la variable */
/* de réponse telle quelle d'une part, et sur la variable de réponse en valeur absolue d'autre part. On compile		*/
/* ensuite les résultats avec comme règle : si la case est cachée dans au moins un des deux cas de figure, alors on */
/* cache. Pour le secret secondaire, nous calculons une variable de coût de secret secondaire à partir de la 		*/
/* variable de réponse problématique. Les valeurs des différents individus sont modifiées de sorte qu'il n'y ait 	*/
/* plus de valeur négative, que l'ordre des individus soit respecté et que le grand total soit identique, selon la  */
/* formule suivante : Vi'=[ (Vi-min(Vi)) x somme(Vi)] / [ somme((Vi-min(Vi)) ] (Vi étant la valeur pour un individu */ 
/* i).Les masques de secret produit présentent néanmoins la variable de réponse initiale pour faciliter les 		*/
/* éventuels contrôles.																								*/
/* L'appel de la macro %Tau_Argus est ici peu modulable, de nombreux paramètres sont les valeurs par défaut 		*/
/* ('&input', '&primary_secret_rules' ...).																			*/
/********************************************************************************************************************/
/* Auteurs : Julien LEMASSON, Maxime BEAUTE	            								                            */
/********************************************************************************************************************/
/* Version : cf. CHANGELOG.md            	            								                            */
/********************************************************************************************************************/
/* Paramètres de la macro                                                                							*/
/********************************************************************************************************************/
/*TauArgus_exe			=	(OBLIGATOIRE) Répertoire et nom de l'application Tau-Argus. 							*/
/*							Ce paramètre spécifie donc indirectement la version de Tau-Argus utilisée.				*/
/*							Par exemple : Y:\Logiciels\TauArgus\TauArgus4.2.0b5\TauArgus.exe						*/
/*TauArgus_version		=	A spécifier lorsque l'on utilise les versions de Tau-Argus antérieures ou égales à 3.5.	*/
/*								opensource : (par défaut)															*/
/*								(vide) : pour les versions 3.5 ou moins												*/
/*library				=	OBLIGATOIRE. Répertoire de travail. S'y trouvent la table sas en entrée, les éventuels	*/
/*							fichiers plats décrivant les hiérarchies des variables hiérarchiques (.hrc), 	        */
/*							et les éventuels fichiers d'a priori (.hst).											*/
/*								(vide) : par défaut																	*/
/*tabsas				=	nom de la table sas de microdonnées. Obligatoire si '&input'='microdata'.				*/
/*								(vide) : par défaut																	*/
/*weight_var			=	nom de la variable de poids le cas échéant. Il ne peut n'y en avoir qu'une par appel de */
/*							macro.																					*/
/*								(vide) : par défaut																	*/
/*holding_var			=	nom de la variable de holding le cas échéant. Il s'agit d'un numéro identifiant type 	*/
/*							SIREN. Il ne peut n'y en avoir qu'une par appel de macro.								*/
/*								(vide) : par défaut																	*/
/*tabulation_1			=	Liste des variables (séparées d'un espace) décrivant la première tabulation. On placera	*/
/*							les variables de ventilation (caractère) en premier, pour finir par la variable de 	    */
/*							réponse (numérique). Si la tabulation est un tableau de comptage, la variable de réponse*/
/*							devra être "FREQ", la macro n'appliquera alors pas la règle de dominance.				*/
/*								(vide) : par défaut																	*/
/*tabulation_10			=	idem, pour la deuxième... jusqu'à la 10ème tabulation.									*/
/*								(vide) : par défaut																	*/
/*hierarchical_var		=	liste des variables hiérarchiques, séparées par un espace. À chaque variable doit être 	*/
/*							associée un fichier plat (.hrc) décrivant la hiérarchie de la variable. 				*/
/*								(vide) : par défaut																	*/
/*method				=	Spécifie la méthode utilisée pour traiter le secret secondaire.							*/
/*								hypercube : (par défaut)															*/
/*								modular 																			*/
/*								optimal : ne fonctionne pas pour des tableaux liés.									*/
/*solver				=	Ancien paramètre désormais appelé method.												*/
/*							Pour des raisons de clarté, il n'est plus possible d'utiliser ce paramètre.				*/
/*lp_solver				=	Spécifie le solveur à utiliser pour traiter le secret secondaire.						*/
/*								free : solveur gratuit (par défaut)													*/
/*								xpress	: nécessite la licence XPress de FICO.										*/
/*								cplex : nécessite la licence CPlex d'IBM.											*/
/*								(vide) : solveur non-spécifié.														*/
/*synthesis				=	Permet de générer un fichier excel résumant le nombre de case selon le statut de chaque */
/*							masque sous format excel du répertoire RESULTS.											*/
/*								yes																					*/
/*								no : (par défaut)																	*/
/*temp_file				=	Permet de supprimer les fichiers temporaires, notamment la table jumelle de &tabsas, qui*/
/*							contient la variable de coût, ainsi que les masques de secret intermédiaires, avec 	    */
/*							le double secret primaire.																*/
/*								no : par défaut																		*/
/********************************************************************************************************************/

%macro Tau_Argus_Negatives (
	TauArgus_exe		=	,
	TauArgus_version	=	opensource,
	library				=	,
	tabsas				=	,
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
	hierarchical_var	=	,
	weight_var			=	,
	holding_var			=	,
	method				=	hypercube,
	solver				=	,
	lp_solver			=	,
	temp_file			=	no) ;

	libname tabsas "&library" ;

	%macro primary_secret_abs (tabulationn,output_name);
		data _null_ ; 
			call symput ("response_varr",lowcase(compbl(scan("&tabulationn.",-1," ")))) ; 
		run ; 

		data null ; 
			call symput("length_resp",length(" &response_varr.")+1);
		run;

		data _null_ ; 
			call symput ("vent",compbl(reverse(substr(reverse ("&tabulationn"),&length_resp))));
		run;

		/* On prépare la table, pour qu'elle comporte la variable en valeur absolue et la variable de coût.*/
		data tab_A ;
			set tabsas.&tabsas. ;
			&response_varr.abs	=	abs (&response_varr.) ;
			tot="tot" ;
		run ;

		proc means data	=	tab_A min sum noprint nway ;
			var &response_varr ;
			class tot ;
			output out	=	tab_B (drop	=	_type_ _freq_) 
				sum		=	sum_&response_varr. 
				min		=	min_&response_varr. ;
		run ;

		data tab_A ; 
			merge 
			tab_A
			tab_B ;
			by tot ;
			&response_varr._minus_min	=	&response_varr. - min_&response_varr. ;
		run ;

		proc means data	=	tab_A sum noprint nway ;
			var &response_varr._minus_min ;
			class tot ;
			output out	=	tab_B (drop	=	_type_ _freq_) 
				sum=sum_&response_varr._minus_min ;
		run ;

		data tabsas.&tabsas._bis ;
			merge 
			tab_A
			tab_B ;
			by tot ;
			&response_varr.cost	=	round(((&response_varr. - min_&response_varr.) * sum_&response_varr.)/sum_&response_varr._minus_min ,0.01) ;
			drop sum_&response_varr._minus_min min_&response_varr. ;
		run ;
		/* On fait le secret primaire sur la variable de réponse + la variable de réponse en valeur absolue ...*/
		%TAU_ARGUS (
			TauArgus_exe		=		&TauArgus_exe,
			TauArgus_version	=		&TauArgus_version,
			method				=		,
			solver				=		&solver.,
			tabsas				=		&tabsas._bis,
			library 			=	 	&library.,
			tabulation_1		=		&tabulationn.,
			tabulation_2		=		&tabulationn.abs,
			hierarchical_var	=		&hierarchical_var,
			weight_var			=		&weight_var,
			holding_var			=		&holding_var,
			linked_tables		=		no) ;
		
				/* ... On compile les deux ... */
		data _null_ ; 
			call symput ("ventt",tranwrd(tranwrd("&vent.","_","")," ","_")) ;
		run ;

		proc sort 	data	=	results.&output_name ; 
					by &vent. ;
		run ;

		proc sort 	data	=	results.&output_name.abs ; 
					by &vent. ;
		run ;

		data _null_ ;
			call symput ("nb_vent",count("&vent."," ")+1);
		run;

		%do ii=1 %to &nb_vent. ;
			data _null_;
				call symput ("vent&ii",scan ("&vent.",&ii," "));
			run;
		%end;

		data &output_name ;
			merge 
			results.&output_name (keep	=	&vent. flag rename=(flag=flagbasic))
			results.&output_name.abs  (keep	=	&vent. flag rename=(flag=flagabs)) ;
			by &vent. ;
			if flagbasic in ('A' 'B' 'F') or flagabs in ('A' 'B' 'F') then flag='u' ;
			else flag='s' ;
				%do jj=1 %to &nb_vent. ;
					if &&vent&jj	=	"Total" then &&vent&jj	=	"" ;
				%end;
			drop flagbasic flagabs ;
		run ;
		
		/* On exporte le tout dans un fichier d'a priori.*/
		proc export data		=	&output_name
					outfile		=	"&library.\&tabulationn.cost.hst" 
		        	dbms		=	dlm replace ;
					delimiter	=	';' ; 
					putnames	=	no ;
		run ;
	%mend;


		/* On définit le nom de la sortie en fonction des paramètres '&tabulation_x' et '&output_name_x'.*/
		%do g1	=	1 %to 10 ; 
			%if &&tabulation_&g1 ne %then 
				%do ; 
					data _null_ ; 
						call symput ("output_name_&g1",compress(tranwrd(tranwrd(trim(tranwrd("&&tabulation_&g1","_","*"))," ","_"),"*",""))) ; 
					run ; 
				%end ; 
		%end ; 
		
		/* On applique cette double couche de secret primaire à toutes les tabulations.*/
		%do kk	=	1 %to 10 ;
			%if &&tabulation_&kk ne %then 
				%do;
					%primary_secret_abs (&&tabulation_&kk,&&output_name_&kk);
					data _null_ ;
						call symput ("tabulation_cost&kk","&&tabulation_&kk..cost");
					run;
				%end;
			%else %if &&tabulation_&kk = %then 
				%do;
					data _null_ ;
						call symput ("tabulation_cost&kk","");
					run;
				%end;
		%end;

	/* On fait le secret secondaire en important le secret primaire par les fichiers d'a priori générés en amont.*/
	%TAU_ARGUS (
		TauArgus_exe			=	&TauArgus_exe,
		TauArgus_version		=	&TauArgus_version,
		tabsas					=	&tabsas._bis,
		library					=	&library,
		tabulation_1			=	&tabulation_cost1,
		apriori_1				=	yes,
		tabulation_2			=	&tabulation_cost2,
		apriori_2				=	yes,
		tabulation_3			=	&tabulation_cost3,
		apriori_3				=	yes,
		tabulation_4			=	&tabulation_cost4,
		apriori_4				=	yes,
		tabulation_5			=	&tabulation_cost5,
		apriori_5				=	yes,
		tabulation_6			=	&tabulation_cost6,
		apriori_6				=	yes,
		tabulation_7			=	&tabulation_cost7,
		apriori_7				=	yes,
		tabulation_8			=	&tabulation_cost8,
		apriori_8				=	yes,
		tabulation_9			=	&tabulation_cost9,
		apriori_9				=	yes,
		tabulation_10			=	&tabulation_cost10,
		apriori_10				=	yes,
		hierarchical_var		=	&hierarchical_var,
		weight_var				=	&weight_var,
		holding_var				=	&holding_var,
		method					=	&method,
		lp_solver				=	&lp_solver,
		primary_secret_rules	=	NORULES	) ;

	/* Pour plus de clarté, on récupère les bonnes informations de statut des cases de dominance et de valeur de la case.*/
	%macro formating_negatives (tabulationn,output_name);
		data _null_ ; 
			call symput ("response_varr",lowcase(compbl(scan("&tabulationn.",-1," ")))) ; 
		run ; 

		data null ; 
			call symput("length_resp",length(" &response_varr.")+1);
		run;

		data _null_ ; 
			call symput ("vent",compbl(reverse(substr(reverse ("&tabulationn"),&length_resp))));
		run;

		data _null_ ; 
			call symput ("ventt",tranwrd(tranwrd("&vent.","_","")," ","_")) ;
		run ;

		proc sort data	=	results.&output_name.cost ; 
			by &vent. ;
		run ;

		proc sort data	=	results.&output_name.abs ; 
			by &vent. ;
		run ;

		proc sort data	=	results.&output_name ; 
			by &vent. ;
		run ;

		data results.&output_name ;
			merge 
			results.&output_name.cost 	(in	=	cost 	keep	=	&vent. flag rename=(flag=flagcost))
			results.&output_name.abs	(in	=	abs 	keep	=	&vent. flag dominance rename=(flag=flagabs dominance=dominanceabs))
			results.&output_name 		(in	=	normal 	keep	=	&vent. flag dominance &response_varr. rename=(flag=flagbasic dominance=dominancebasic)) ;
			by &vent ;
			if flagcost	=	"V" then flag	=	"V" ; 
			else if flagabs	=	"A" or flagbasic	=	"A" then flag="A" ; 
			else if flagabs	=	"B" or flagbasic	=	"B" then 
				do ; 
					flag		=	"B" ; 
					dominance	=	max (dominanceabs,dominancebasic) ; 
				end	 ;
			else flag	=	"D" ;
			if dominance > "100" then dominance	=	"100" ; /*ça peut arriver d'avoir une dominance > 100 à cause des valeurs négatives on force alors la valeur à 100*/
			if flag in ('A' 'B' 'D') then 
				do ; 
					&response_varr.	=	"" ;
					nb_unit			=	"" ;
				end ;
			drop flagcost flagabs flagbasic dominanceabs dominancebasic ;
		run ;

		%if &temp_file	=	no %then
			%do;
				/* On supprime les tables intermédiaires.*/
				option noxwait xsync ;
				X "cd &library\results" ;
				X "del &output_name.cost.sas7bdat" ;
				X "del &output_name.abs.sas7bdat" ;
				X "del &output_name.cost.xls" ;
				X "del &output_name.abs.xls" ;
			%end;
	%mend;

			%do ll	=	1 %to 10 ;
			%if &&tabulation_&ll ne %then 
				%do;
					%formating_negatives (&&tabulation_&ll,&&output_name_&ll);
				%end;
		%end;

	proc delete data	=	tabsas.&tabsas._bis ;
	run;

	%synthesis (library_synthesis	=	&library.\results);
%mend ;
