#### #####  #####  #####  #####  #####  #####  ###### 
#### ##### SELECT THE BEST FEATURES #####  ##### ####
##### #####  #####  #####  #####  #####  #####  ##### 

rm(list=ls())

load("data/load_dataset.RData")

library(caret)

set.seed(1234)

t<-proc.time()

control <- rfeControl(functions=rfFuncs, method="cv", number=10)

results <- rfe(dtset_genres[,-192], dtset_genres[,192], sizes=c(1:191), rfeControl=control)

proc.time()-t

predictors(results)
features_chosen<-predictors(results)

save(list=ls(), file="data/features_chosen.RData")
