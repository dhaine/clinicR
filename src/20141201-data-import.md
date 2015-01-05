---
layout: lesson
root: ..
---



# Importation de données dans R

Fréquemment on reçoit ses données dans un fichier Excel. Plusieurs *packages*
existe qui peuvent lire ce format (`gdata`, `RODBC`, `XLConnect`, `xlsx`,
`RExcel`) (note: `gdata` a besoin de `Perl` pour importer un fichier Excel, ce
qui peut ne pas être disponible sur une machine Windows, alors que ce ne serait
pas un problème sur Mac ou Linux). Une meilleure manière de transférer ses
données est via un fichier texte, .csv par exemple. Pourquoi csv?

* Peut être lu par n'importe quel logiciel passé, présent et probablement futur,
* Pour la compatibilité descendante,
* Pour la compatibilité entre plate-forme (Windows, Mac, Linux),
* Pour la facilité de lecture par un être humain comparativement à d'autres
  formats tels que XML, HL7, JSON etc.

Un fichier .csv est donc plus facile à utiliser, plus fiable et plus pérenne
qu'un fichier Excel.

Il faut cependant que le fichier soit dans un certain format pour pouvoir être
importé. Le fichier exposé dans l'image suivante comporte-t-il des erreurs?

<img src="figure/bad-file.png" width="75%" height="75%"/>


## Importation d'un fichier .csv

Les données [health](health.csv) vont être utilisées pour démontrer
l'utilisation de `read.csv()`. Ce fichier reprend les lactations de 500 vaches
provenant de différents troupeaux, avec leur âge, numéro de lactation, présence
de fièvre de lait et/ou de déplacement de caillette. Pour ce faire, on utilise la
fonction `read.csv()` qui va importer ces données tabulaires (un *data frame*
pour `R`: plusieurs lignes, colonnes et de format mixte). `read.csv()` fait
partie des fonctions `read.table()` (cf. `?read.table`) pour importer des
données de type mixte. Si les données étaient uniquement numériques, on pourrait
utiliser la fonction `scan()` (pour des matrices). On assigne le jeu de données
importé à une variable avec `<-` ("on crée un objet dans `R`"). `read.table()`
retourne toujours un *data frame*.

Par défaut, `read.csv()` utilise la virgule comme séparateur de champs. On peut
modifier le séparateur en utilisant l'argument `sep =` (p.ex. `sep = ';'`). Ceci
est important sur des ordinateurs *francophones* où la virgule représente la
décimale (et non le point comme en anglais). Autres solutions: `read.csv2()` ou
l'argument `dec = ` pour spécifier un autre séparateur de décimale.


<pre class='in'><code>health <- read.csv(file = "health.csv")
head(health)</code></pre>



<div class='out'><pre class='out'><code>     unique age lactation disease presence
1 K100-P284 6.7         6      mf        0
2 K100-P284 6.7         6      da        0
3 K100-P295 6.9         6      mf        0
4 K100-P295 6.9         6      da        0
5 K100-P357 5.9         4      mf        0
6 K100-P357 5.9         4      da        0
</code></pre></div>



<pre class='in'><code>str(health)</code></pre>



<div class='out'><pre class='out'><code>'data.frame':	1000 obs. of  5 variables:
 $ unique   : Factor w/ 500 levels "K100-P284","K100-P295",..: 1 1 2 2 3 3 4 4 5 5 ...
 $ age      : num  6.7 6.7 6.9 6.9 5.9 5.9 6.6 6.6 5.4 5.4 ...
 $ lactation: int  6 6 6 6 4 4 5 5 4 4 ...
 $ disease  : Factor w/ 2 levels "da","mf": 2 1 2 1 2 1 2 1 2 1 ...
 $ presence : int  0 0 0 0 0 0 0 0 0 0 ...
</code></pre></div>

Utilisant `str(health)`, chaque variable a-t-elle été importée comme vous
l'espériez?

## Les différents arguments

* `header`: `TRUE` par défaut. Si la première ligne de votre fichier n'est pas
  le nom des variables, mettre `header = FALSE`

* `stringsAsFactors`: par défaut, `R` convertit les variables de type caractères
  en facteurs
  (cf. [atelier SWC](https://dhaine.github.io/2014-11-06-fmv/novice/epi/01-data-structures.html)). C'est
  peut-être ce que vous recherchiez, ou pas. Par exemple, s'il y a eu une erreur
  lors de l'identification de la vache K100-P284 et que vous voulez remplacer
  K100-P284 par K100-P999:


<pre class='in'><code>health$unique <- ifelse(health$unique == "K100-P284", "K100-P999", health$unique)
head(health)</code></pre>



<div class='out'><pre class='out'><code>     unique age lactation disease presence
1 K100-P999 6.7         6      mf        0
2 K100-P999 6.7         6      da        0
3         2 6.9         6      mf        0
4         2 6.9         6      da        0
5         3 5.9         4      mf        0
6         3 5.9         4      da        0
</code></pre></div>

Que s'est-il passé? Maintenant essayons avec `stringsAsFactors`:


<pre class='in'><code>health <- read.csv(file = "health.csv",
                   stringsAsFactors = FALSE)
str(health)</code></pre>



<div class='out'><pre class='out'><code>'data.frame':	1000 obs. of  5 variables:
 $ unique   : chr  "K100-P284" "K100-P284" "K100-P295" "K100-P295" ...
 $ age      : num  6.7 6.7 6.9 6.9 5.9 5.9 6.6 6.6 5.4 5.4 ...
 $ lactation: int  6 6 6 6 4 4 5 5 4 4 ...
 $ disease  : chr  "mf" "da" "mf" "da" ...
 $ presence : int  0 0 0 0 0 0 0 0 0 0 ...
</code></pre></div>



<pre class='in'><code>health$unique <- ifelse(health$unique == "K100-P284", "K100-P999", health$unique)
head(health)</code></pre>



<div class='out'><pre class='out'><code>     unique age lactation disease presence
1 K100-P999 6.7         6      mf        0
2 K100-P999 6.7         6      da        0
3 K100-P295 6.9         6      mf        0
4 K100-P295 6.9         6      da        0
5 K100-P357 5.9         4      mf        0
6 K100-P357 5.9         4      da        0
</code></pre></div>

> **Rappel:** Les facteurs sont en fait des nombres!

> **Truc:** Il existe une option globale, `options(stringsAsFactors = FALSE)`
> pour contrôler ce comportement de manière générale. Mais changer une option
> globale peut avoir des conséquences non prévues lorsque combinée avec d'autres
> codes (provenant de *packages* ou que vous *sourcer* dans votre code
> actuel). Cela peut aussi vous rendre plus difficile la compréhension de votre
> code. Je ne le recommande donc pas.

* `as.is`: supprime la conversion en facteur pour un sous-ensemble des
  variables.

* `strip.white`: si un *blanc* a été introduit avant ou après une donnée. On
  peut dire à `R` de s'en débarrasser avec `strip.white`.

* `na.strings`: les *blancs*, NA, NaN, Inf et -Inf sont considérés comme des
  valeurs manquantes. L'argument `na.strings` permet de modifier ce
  comportement.
  
**Fonctions utiles avec les data frames**

* `head()` - pour voir les 6 premières lignes
* `tail()` - pour voir les 6 dernières lignes
* `dim()` - ses dimensions
* `nrow()` - le nombre de lignes
* `ncol()` - le nombre de colonnes
* `str()` - structure de chaque colonne
* `names()` - liste l'attribut `names` d'un data frame (ou n'importe quel autre
  objet), ce qui donne les noms des colonnes.

## Formats propriétaires binaires

Le *package* `foreign` permet d'importer des données en format propriétaire
binaire tels que Stata, SAS, SPSS etc. Par exemple (fichiers Stata et SAS
provenant de [VER](http://www.upei.ca/ver/datasets-programs) par Ian Dohoo):


<pre class='in'><code>install.packages("foreign")
library(foreign)
read.dta("calf_pneu.dta")  # for Stata files
read.xport("file.xpt")  # for SAS XPORT format
read.spss("file.sav")  # for SPSS format
read.epiinfo("file.REC")  # for EpiInfo format (and EpiData)
read.mpt("file.mtp")  # for Minitab Portable Worksheet

## other solutions for Stata files:
library(memisc)
Stata.file()
library(Hmisc)
stata.get("calf_pneu.dta")
## other solution for SPSS files:
library(Hmisc)
spss.get()</code></pre>

Remarquez que vous ne pouvez pas importer des fichiers SAS en format *permanent*
(`.ssd` ou `.sas7bdat`). Si SAS est installé sur votre système, vous pouvez
utiliser `read.ssd` pour importer ces formats.

> **Truc:** Si vous n'avez pas SAS et que vous *roulez* sous Windows, vous
> pouvez utiliser le SAS System Viewer
> ([téléchargement gratuit](http://support.sas.com/downloads/package.htm?pid=176))
> pour ouvrir votre fichier SAS et l'exporter en `.csv`.

Autres solutions pour les fichiers SAS:


<pre class='in'><code>library(SASxport)
read.xport("file.xpt")
sas.get()  ## in package Hmisc
library(sas7bdat)
read.sas7bdat("calf_pneu.sas7bdat")</code></pre>

> **Note:** Pour créer un fichier Transport SAS, on peut utiliser la procédure
> PROC COPY:

> `libname sasfile 'C:\path to your folder'
> libname sasxpt XPORT 'C:\path to your folder\file.xpt'
> proc copy in = sasfile out = sasxpt;
> select yourfile;
> run;`

## Importation de fichiers compressés

Les fichiers compressés par l'algorithme *gzip* peuvent être décompressés par la
fonction `gzfile` et ceux par l'algorithme *bzip2* par la fonction `bzfile`.


<pre class='in'><code>read.table(gzfile("file.gz"))</code></pre>

## Connexion à une base de données

Il y a plusieurs *packages* permettant de connecter `R` à un DBMS (`RODBC`,
`RMySQL`, `RSQLite`, `ROracle` etc.).

## Connexion à un tableur

En plus des *packages* cités plus haut pour Excel, on peut utiliser les suivants
pour avoir accès à des fichier `.ods`.


<pre class='in'><code>## for ODS files:
library(gnumeric)  # sous Linux, gnumeric
health <- read.gnumeric.sheet(file = "health.ods",
                              head = TRUE,
                              sheet.name = "Feuille1")

library(readODS)
health <- read.ods("health.ods", sheet = 1)</code></pre>

Pour un fichier Google Doc, il est préférable de l'exporter d'abord au format
`csv`, puis de le transférer dans R. Pour d'autres solutions, voir
[The Omega Project](http://www.omegahat.org/).

*Note concernant RODBC et Excel:* ne fonctionne que sous Windows et seule la
version 32-bit de `R` est supportée. De plus il est nécessaire d'avoir le
*driver* Excel RODBC installé.

## Écrire un nouveau fichier .csv

La fonction `write.csv(...)` permet d'écrire des fichiers .csv et prend
au minimum deux arguments: les données à sauvegarder et le nom du fichier de
sortie.


<pre class='in'><code>write.csv(health, file = 'new-health.csv')</code></pre>

Si vous ouvrez ce nouveau fichier vous constaterez que les colonnes ont un nom
mais que la première colonne est faire de numéros.

L'argument `row.names=...` permet d'attribuer un nom aux lignes dans le fichier
de sortie. Par défaut cet argument est `TRUE` et comme `R` ne sait pas comment
appeler les lignes, il utilise un numéro. Pour éviter cela, on peut mettre
l'argument `row.names` comme `FALSE`:


<pre class='in'><code>write.csv(health, file= 'new-health.csv', row.names = FALSE)</code></pre>

> **Truc:** Il y a aussi un argument `col.names` qui peut être utiliser pour
> donne un nom aux colonnes d'un jeu de données qui n'en aurait pas. Si les
> colonnes de votre jeu de données ont déjà un nom (p.ex. via  `headers = TRUE`
> lors de l'importation), alors l'argument `col.names` sera ignoré.

Parfois on veut remplacer les `NA` de notre jeu de données lors de
l'exportation. Pour ce faire on peut utiliser l'argument `na`.


<pre class='in'><code>write.csv(health, file = 'new-health.csv', row.names = FALSE, na = '-99')</code></pre>

---
**Information additionnelle**

[Manuel R](http://cran.r-project.org/doc/manuals/r-patched/R-data.pdf)
