#### #####  #####  #####  #####  #####  #####  ###### 
#### #####   DATASET MUSICS GENRE   #####  ##### ####
##### #####  #####  #####  #####  #####  #####  #####

rm(list=ls())

# carrega os dados de treinamento 
dtset_genres <- read.csv("data/genresTrain.csv", header = TRUE, sep=",")

dim(dtset_genres)

# parsing de classes
levels(dtset_genres$GENRE)[levels(dtset_genres$GENRE)=="Blues"] <- "1"

levels(dtset_genres$GENRE)[levels(dtset_genres$GENRE)=="Classical"] <- "2"

levels(dtset_genres$GENRE)[levels(dtset_genres$GENRE)=="Jazz"] <- "3"

levels(dtset_genres$GENRE)[levels(dtset_genres$GENRE)=="Metal"] <- "4"

levels(dtset_genres$GENRE)[levels(dtset_genres$GENRE)=="Pop"] <- "5"

levels(dtset_genres$GENRE)[levels(dtset_genres$GENRE)=="Rock"] <- "6"

remove_outliers <- function(x, na.rm = TRUE, ...) {
    qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
    H <- 1.5 * IQR(x, na.rm = na.rm)
    y <- x
    y[x < (qnt[1] - H)] <- NA
    y[x > (qnt[2] + H)] <- NA
    y
}

# remover classe
variables<-dtset_genres[,-192]

sum_miss_values<-NULL

for (i in 1:ncol(variables)){
    # conta o número de registros ausentes
    sum_miss_values[i]<-sum(!complete.cases(remove_outliers(dtset_genres[,i])))
}

for (i in 1:4){
    # localiza os indices com NA
    ind<-which(is.na(remove_outliers(dtset_genres[,i]))) 
    # remove  NA
    dtset_genres<-dtset_genres[-ind,]
    nrow(dtset_genres)
}

# 3312 removidos
# contagem de NA
sum(!complete.cases(dtset_genres))

head(dtset_genres)
nrow(dtset_genres)

# percentual de instancias NA removidas
100 - ((nrow(dtset_genres)*100)/12495)

save(dtset_genres, file="data/load_dataset.RData")
