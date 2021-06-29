# SASTauArgus
[![License: MIT](https://img.shields.io/github/license/inseefr/arc)](https://opensource.org/licenses/MIT)  

SASTauArgus est un dépôt contenant deux macros en langage SAS : %Tau_Argus (["Macro_Tau_Argus.sas"](Macro_Tau_Argus.sas)) et %Tau_Argus_Negatives (["Macro_Tau_Argus_Negatives.sas"](Macro_Tau_Argus_Negatives.sas)). 
Ces macros effectuent des appels au logiciel [Tau-Argus](https://github.com/sdcTools/tauargus) de gestion de la confidentialité pour des tableaux de données. 
Elles prennent en entrée une base de données individuelles, et génèrent en sortie un tableau agrégé respectant les règles de secret statistique qui ont été spécifiées. 
L'objectif est de se prémunir d'une divulgation d'information individuelle, tout en minimisant la perte d'information engendrée par le processus de protection. 
Dans cette optique, le programme choisit judicieusement les cellules du tableau qui seront masquées.  
  
Si votre tableau de données ne comporte que des valeurs positives ou nulles, il est préférable d'utiliser la macro %Tau_Argus. Sinon, il faut utiliser la macro %Tau_Argus_Negatives.  

## Documentation
Vous trouverez une documentation avec des exemples détaillés d'utilisation dans ce fichier : ["Documentation/Documentation_SASTauArgus.md"](Documentation/Documentation_SASTauArgus.md).
Vous trouverez le code d'exemple associé à cette documentation à cette adresse : ["Documentation/Code_exemple_SASTauArgus.sas"](Documentation/Code_exemple_SASTauArgus.sas).

## Utilisation
Avant toute utilisation de ces macros dans un environnement SAS, il est nécessaire de les charger en les exécutant directement, ou bien en lançant les lignes suivantes :
~~~
option mprint;
filename tauargus "C:\Chemin vers le depot\SASTauArgus"; /* répertoire où se trouve les macros (à modifier) */
%include tauargus (Macro_Tau_Argus); /* pour utiliser la macro %Tau_Argus */
%include tauargus (Macro_Tau_Argus_Negatives); /* pour utiliser la macro %Tau_Argus_Negatives */
~~~

## Méthodologie
La méthodologie employée pour protéger des tableaux de données se fonde sur celle du logiciel [Tau-Argus](https://github.com/sdcTools/tauargus). 
Ce logiciel est piloté, conçu, maintenu et supporté par un [groupe d'experts européens sur la confidentialité](https://ec.europa.eu/eurostat/cros/content/coe-sdc-2020-2024_en). 
Chaque membre de ce groupe, dont l'Insee participe, est issu d'un des instituts nationaux de statistiques d'Europe.

## Encodage
L'encodage de tous les fichiers SAS (.sas) de ce dépôt est en ANSI (Windows-1252). Les autres fichiers sont encodés en UTF-8.

## Contacts
- Clément Guillo (clement.guillo@insee.fr)
- Julien Jamme (julien.jamme@insee.fr)
- Nathanaël Rastout (nathanael.rastout@insee.fr)