# Bias Analysis Exercises
library(Hmisc)

pop <- stata.get("cyst_bias_pop10.dta", lowernames = TRUE)

str(pop)
dim(pop)
head(pop)

library(epiR)
## 2x2 table
pop$cyst <- factor(pop$cyst, levels = c(1, 0))
pop$know <- factor(pop$know, levels = c(1, 0))
ctab <- table(pop$cyst, pop$know, dnn = c("Cyst", "Know"))
epi.2by2(ctab, method = "cohort.count")

## controlling for pig
ctab2 <- table(pop$cyst, pop$know, pop$pig, dnn = c("Cyst", "Know", "Pig"))
epi.2by2(ctab2, method = "cohort.count")

cyst.glm <- glm(cyst ~ know + pig,
                family = binomial("logit"),
                data = pop)
cyst.sum <- summary(cyst.glm)
cbind(exp(coef(cyst.glm)), exp(confint(cyst.glm)), coef(cyst.sum)[, 4])

## prevalence of pig in know==0
with(pop[pop$know == 0, ], sum(pig, na.rm = TRUE) / length(pig))
## prevalence of pig in know==1
with(pop[pop$know == 1, ], sum(pig, na.rm = TRUE) / length(pig))

## effect of pig on know
pop$pig <- factor(pop$pig, levels = c(1, 0))
ctab.know <- table(pop$pig, pop$know, dnn = c("Pig", "Know"))
epi.2by2(ctab.know, method = "cohort.count")
## effet of pig on cyst
ctab.cyst <- table(pop$pig, pop$cyst, dnn = c("Pig", "Cyst"))
epi.2by2(ctab.cyst, method = "cohort.count")

## interaction with know
library(epicalc)
with(pop, mhor(cyst, pig, know,
               design = "cohort",
               decimal = 2,
               graph = FALSE))

## episensr
library(episensr)
confounders(pop$cyst, pop$know,
            type = "OR",
            p = c(0.61, 0.22),
            OR.cd = 3.97)
## with effect modification
confounders.emm(pop$cyst, pop$know,
                type = "OR",
                p = c(0.61, 0.22),
                OR.cd = c(7.5, 14.1))
## probabilistic
set.seed(123)
probsens.conf(pop$cyst, pop$know,
              reps = 1000,
              prev.exp = list("trapezoidal", parms = c(0.24, 0.48, 0.68, 0.78)),
              prev.nexp = list("trapezoidal", parms = c(0.06, 0.17, 0.28, 0.39)),
              risk = list("trapezoidal", parms = c(1.41, 2.81, 5.6, 11.17)))
