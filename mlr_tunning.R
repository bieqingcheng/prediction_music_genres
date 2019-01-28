rm(list=ls())

load("data/load_dataset.RData")
load("data/best_features.RData")

library(beepr)
library(mlr)

set.seed(1234)

dtset_genres_140 <- data.frame(cbind(dtset_genres_140, GENRE = dtset_genres$GENRE))

trainTask <- makeClassifTask(data = dtset_genres_140, target = "GENRE")

getParamSet("classif.randomForest")

rf <- makeLearner("classif.randomForest", predict.type = "response", 
                  par.vals = list(ntree = 200, mtry = 3))

rf$par.vals <- list(
    importance = TRUE
)

# setando os parâmetros de tuning
rf_param <- makeParamSet(
    makeIntegerParam("ntree",lower = 50, upper = 500),
    makeIntegerParam("mtry", lower = 3, upper = 100),
    makeIntegerParam("nodesize", lower = 10, upper = 50)
)

# definindo o total de interação 
ran_control <- makeTuneControlRandom(maxit = 50L)

# cross 
set_cv <- makeResampleDesc(method = "CV", iters=3L)

# tunando parâmetros
rf_tune <- tuneParams(learner = rf, resampling = set_cv, task = trainTask, par.set = rf_param, control = ran_control, measures = acc, show.info = TRUE)

# passando os melhores hiperparâmetros para o modelo
rf_tune_tree <- setHyperPars(rf, par.vals = rf_tune$x)

unloadNamespace("caret")

# treinando o modelo
rforest <- train(learner = rf_tune_tree, task = trainTask)
getLearnerModel(rforest)
beep()

# abrindo o conjunto de teste
dtset_music_test <- read.csv("data/genresTest2.csv", header=TRUE)

# passando o conjunto de teste para o modelo 
predict_rf<-predict(rforest$learner.model, dtset_music_test)
predict_rf

rf_140 <- data.frame(cbind(nrow(predict_rf),predict_rf))
rf_140$names <- rownames(rf_140)
rf_140 <- rf_140[,c(2,1)]
colnames(rf_140) <- c("Id", "Genres")
head(rf_140)
tail(rf_140)

# gravando a saida
write.csv(rf_140,file="data/rf_140.csv",row.names=FALSE)
