
## ----, include = FALSE---------------------------------------------------
source("chunk_options.R")
opts_chunk$set(fig.path = "figure/201412-import-", fig.height = 5, fig.width = 10)


## ----import-health-------------------------------------------------------
health <- read.csv(file = "health.csv")
head(health)
str(health)


## ----ifelse--------------------------------------------------------------
health$unique <- ifelse(health$unique == "K100-P284", "K100-P999", health$unique)
head(health)


## ----strings-------------------------------------------------------------
health <- read.csv(file = "health.csv",
                   stringsAsFactors = FALSE)
str(health)
health$unique <- ifelse(health$unique == "K100-P284", "K100-P999", health$unique)
head(health)


## ----foreign, eval=FALSE-------------------------------------------------
## install.packages("foreign")
## library(foreign)
## read.dta("calf_pneu.dta")  # for Stata files
## read.xport("file.xpt")  # for SAS XPORT format
## read.spss("file.sav")  # for SPSS format
## read.epiinfo("file.REC")  # for EpiInfo format (and EpiData)
## read.mpt("file.mtp")  # for Minitab Portable Worksheet
## 
## ## other solutions for Stata files:
## library(memisc)
## Stata.file()
## library(Hmisc)
## stata.get("calf_pneu.dta")
## ## other solution for SPSS files:
## library(Hmisc)
## spss.get()


## ----SAS, eval=FALSE-----------------------------------------------------
## library(SASxport)
## read.xport("file.xpt")
## sas.get()  ## in package Hmisc
## library(sas7bdat)
## read.sas7bdat("calf_pneu.sas7bdat")


## ----zip, eval=FALSE-----------------------------------------------------
## read.table(gzfile("file.gz"))


## ----spreadsheet, eval=FALSE---------------------------------------------
## ## for ODS files:
## library(gnumeric)  # sous Linux, gnumeric
## health <- read.gnumeric.sheet(file = "health.ods",
##                               head = TRUE,
##                               sheet.name = "Feuille1")
## 
## library(readODS)
## health <- read.ods("health.ods", sheet = 1)


