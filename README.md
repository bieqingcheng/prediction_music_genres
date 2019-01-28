# prediction_music_genres

Competition: Kaggle - back to the prediction of music genres

A database of 60 music performers has been prepared for the competition. The material is divided into six categories: classical music, jazz, blues, pop, rock and heavy metal. For each of the performers 15-20 music pieces have been collected. All music pieces are partitioned into 20 segments and parameterized. The descriptors used in parametrization also those formulated within the MPEG-7 standard, are only listed here since they have already been thoroughly reviewed and explained in many studies. The feature vector consists of 191 parameters, the first 127 parameters are based on the MPEG-7 standard, the remaining ones are cepstral coefficients descriptors and time-related dedicated parameters:

a) parameter 1: Temporal Centroid, 
b) parameter 2: Spectral Centroid average value, 
c) parameter 3: Spectral Centroid variance, 
d) parameters 4-37: Audio Spectrum Envelope (ASE) average values in 34 frequency bands
e) parameter 38: ASE average value (averaged for all frequency bands)
f) parameters 39-72: ASE variance values in 34 frequency bands
g) parameter 73: averaged ASE variance parameters
h) parameters 74,75: Audio Spectrum Centroid – average and variance values
i) parameters 76,77: Audio Spectrum Spread – average and variance values
j) parameters 78-101: Spectral Flatness Measure (SFM) average values for 24 frequency bands
k) parameter 102: SFM average value (averaged for all frequency bands)
l) parameters 103-126: Spectral Flatness Measure (SFM) variance values for 24 frequency bands
m) parameter 127: averaged SFM variance parameters
n) parameters 128-147: 20 first mel cepstral coefficients average values 
o) parameters 148-167: the same as 128-147
p) parameters 168-191: dedicated parameters in time domain based of the analysis of the distribution of the envelope in relation to the rms value.

File descriptions
genresTrain.csv - the training set
genresTest2.csv - the test set

Pipeline:
1. Load the dataset (load_dataset.R)
2. Select the best features (best_features.R)
3. Choose the number features selected (features_optium.R)
4. Create and apply model - Test data and validation (mlr_tunning.R)
