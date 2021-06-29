# Changelog

Tous les changements notables apportés à ce projet sont documentés dans ce fichier.  

Ce projet respecte le [Versionnage Sémantique](https://semver.org/lang/fr/spec/v2.0.0.html).  

## Version 2.0.1 - 29/06/2021
- Ouverture de la macro sur le GitHub InseeFrLab.
- Corrections mineures de commentaires.
- Modification des noms de fichiers et dossiers : notamment "exemples-cas-pratiques.md" en "Documentation_SASTauArgus.md" et "Macro Tau_argus - Cas pratiques.sas" en "Code_exemple_SASTauArgus.sas".
- Mise à jour de la documentation "Documentation_SASTauArgus.md".
- Mise à jour du fichier lisez-moi "README.md".
- Ajout du fichier de licence "LICENSE.txt".
- Ajout du fichier "CHANGELOG.md".


## Version 2.0.0 - 25/06/2021
- Attention : Cette version brise la rétrocompatibilité. Pour refaire fonctionner vos appels aux macros %Tau_Argus ou %Tau_Argus_negatives,  
veuillez renommer vos paramètres "solver" en "method", et "solver_X" en "method_X", conformément aux nouveaux messages d'erreur. Le cas échéant, 
veuillez également spécifier le paramètre TauArgus_exe, désormais obligatoire.
- Suppression de la macro %correction_output5 qui effectuait des traitements supplémentaires lors de l'exportation de données tabulées. Ces 
traitements engendraient un mauvais formatage des tables en sortie lors de l'utilisation du paramètre outputtype=5.
- Renommage des paramètres solver, solver_1, ..., solver_10 en method, method_1, ..., method_10. Ces paramètres permettent de choisir la méthode à 
utiliser pour calculer le secret secondaire, et non le solveur.
- Pour plus de clarté, interdiction d'utiliser les paramètres solver, solver_1, ..., solver_10.
- Ajout du paramètre lp_solver de choix du solveur.
- TauArgus_version prend désormais la valeur opensource par défaut. L'ancienne valeur par défaut (vide) n'était valable que pour la version 3.5 de 
Tau-Argus, qui n'est de toute façon plus disponible sur internet. Il n'est donc souvent plus nécessaire de renseigner le paramètre TauArgus_version.
- Il est désormais obligatoire de spécifier une valeur au paramètre TauArgus_exe.
- Formatage des commentaires pour une meilleur lisibilité sur un écran de largeur 1280.
- Passage en markdown de la documentation explicative "Macro Tau_argus - Cas pratiques.pdf" en "exemples-cas-pratiques.md".
- Mise à jour du code d'exemple "Macro Tau_argus - cas pratiques.sas" conformément aux modifications de cette version.


## Version 1.1.2 - 08/02/2021
- Correction de l'orthographe et de la syntaxe dans les commentaires. Mise à jour des commentaires sur les paramètres solver et manual_safety_range.
- Mise à jour du code illustratif "Macro Tau_argus - Cas pratiques.sas".
- Mise à jour du PDF d'explications "Macro Tau_argus - Cas pratiques.pdf".
- Ajout d'un fichier ".gitignore" pour ne pas commit les cas de test.


## Version 1.1.1 - 29/01/2021
- Léger remaniement des commentaires pour publier la macro sur le dépôt interne de l'Insee.


## Version 1.1.0 - 28/08/2018
- Ajout des paramètres hierarchy_7 à hierarchy_10
- Correction du paramètre &tabulation (qui devient &tabulation_number) dans les sous-macro %OPENTABLEDATA et %SPECIFYTABLE_SAFETYRULES. Lorsque l'on 
utilisait l'option &input	=	tabledata, si les tabulations n'étaient pas dans l'ordre alphabétique dans l'appel de la macro, cela provoquait une 
erreur d'écriture dans le batch qui le rendait faux.
- Correction dans la sous-macro %SPECIFYTABLE_SAFETYRULES. La condition "%if holding	=	%then ; %do ;" devient "%if &holding	=	%then %do ;".
Il manquait jusqu'alors le "&" et il y avait un ";" en trop. Sous la condition "%if holding	ne %then %do;", un certain nombre de paramètres censé 
être relatifs aux paramètres "holding" ne l'étaient pas, c'est corrigé. Cela impliquait que les paramètres de secret primaire du niveau individuel 
étaient appliqués tel quel sur le niveau holding, ce qui est le cas le plus souvent.
- Dans la sous-macro %formating, mise en commentaire de la ligne
"if flag in ("B" "F") and individu_count <3 then flag	=	"A" ;"
- Le "3" correspond à la règle appliquée pour les entreprises, mais il aurait fallu que ce soit le paramètre &frequency qui soit utilisé.
Cela n'a pas d'incidence particulière, il s'agissait d'une rectification du flag pour les cases ayant un problème de dominance et de fréquence en 
même temps. Nous imposions le flag du secret primaire de fréquence par convention. Mais dans tous les cas, la case était bien comptée dans le secret 
primaire.
- Ajout de précision par rapport au paramètre "&primary_secret_rules", en particulier sur la valeur "NORULES".


## Version 1.0.0 - 02/11/2017
- Création des macros %Tau_Argus et %Tau_Argus_negatives.