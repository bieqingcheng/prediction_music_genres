#### #####  #####  #####  #####  #####  #####  ###### 
#### #####   NUMBER OF INSTANCES OPTIMUM  #####  ##### 
##### #####  #####  #####  #####  #####  #####  #####
rm(list=ls())

load("data/load_dataset.RData")
load("data/features_chosen.RData")

opt<-options("scipen" = 20)
getOption("scipen")

library(randomForest)
library(e1071)
library(caret)

d_test <- NULL
d_val <- NULL

for (i in 1:length(features_chosen)){
    
    if (i%%10==0){
    
        dtset_music <- cbind(dtset_genres[,c(1:i)], GENRE = dtset_genres[,192])
            
        smp_size <- floor(0.7 * nrow(dtset_music))
        
        set.seed(1234)
        training_ind <- sample(seq_len(nrow(dtset_music)), size = smp_size)
        
        # treino
        buildData <- dtset_music[training_ind,]
        
        # validação
        validation<- dtset_music[-training_ind,]
        
        smp_size <- floor(0.7 * nrow(buildData))
        
        inTrain <- sample(seq_len(nrow(buildData)), size = smp_size)
        
        training <- buildData[inTrain,]
        testing <- buildData[-inTrain,]
        
        # tuning para o parametro mtry
        mtry<-tuneRF(training[,-ncol(dtset_music)], training[,ncol(dtset_music)], ntreeTry = 1000, stepFactor = 1.5,
                     improve = 0.01, trace=TRUE, plot=TRUE, dobest=FALSE)
        
        mtry_min_err<-as.data.frame(mtry)
        
        best_mtry<-mtry_min_err[which.min(mtry_min_err$OOBError), ]$mtry
        
        # passando o melhor valor para mtry para o modelo
        model <- randomForest(GENRE ~ ., data = training, importance = TRUE, ntree = 1000, mtry = best_mtry)    
    
        pred_test <- predict(model, newdata = testing)
        cmrf_test <- confusionMatrix(pred_test, testing$GENRE)
        
        acc<-as.numeric(round(cmrf_test$overall['Accuracy'], 4))
        feat<-length(c(1:i))
        
        # guardando os resultados das previsoes (acurácia) e número de features para os dados de teste
        d_test <<- rbind(d_test, data.frame(Accuracy=acc, NumberFeatures=feat))  
        #print(d_test)
        
        pred_val <- predict(model, newdata = validation)
        cmrf_val <- confusionMatrix(pred_val, validation$GENRE)
    
        acc<-as.numeric(round(cmrf_val$overall['Accuracy'], 4))
        feat<-length(c(1:i))
        
        # guardando os resultados das previsoes (acurácia) e número de features para os dados de validação
        d_val <<- rbind(d_val, data.frame(Accuracy=acc, NumberFeatures=feat))  
        #print(d_val)
    
        }
} 
    

df_best_testing <- d_test 
df_best_validation <- d_val

# visualizações
library(ggplot2)

features_140<-features_chosen[1:140]

dtset_genres_140<-dtset_genres[,c(features_140)]

save(dtset_genres_140, file="best_features.RData")

p1 <- ggplot(df_best_testing, aes(x=NumberFeatures, y=Accuracy))

p1<- p1 + geom_point(aes(color = Accuracy)) + geom_line(aes(y = Accuracy)) + scale_x_continuous(breaks = seq(10,100,10)) + scale_y_continuous(limits = c(0,1)) + ggtitle("Conjunto de Teste - Acurácia x Numero de Features")

p2 <- ggplot(df_best_validation, aes(x=NumberFeatures, y=Accuracy))

p2 <- p2 + geom_point(aes(color = Accuracy)) + geom_line(aes(y = Accuracy)) + scale_x_continuous(breaks = seq(10,100,10)) + scale_y_continuous(limits = c(0,1)) + ggtitle("Conjunto de Validação - Acurácia x Numero de Features")

# código externo
source("multiplot.R")

multiplot(p1,p2, cols=2)
