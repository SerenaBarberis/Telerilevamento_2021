#R_code_multivariate_analysis.r

library(raster)
library(RStoolbox)
setwd('C:/Users/Sery/Desktop/lab')

#immagini a 7 bande->funzione brick: carica tutto il set di bande
p224r63_2011 <- brick('p224r63_2011_masked.grd')
p224r63_2011
plot(p224r63_2011)

#plottiamo i valori della banda 1 confrontati con i valori della banda 2 
#pch-> forma punti
#cex-> dimensione punti
plot(p224r63_2011$B1_sre, p224r63_2011$B2_sre, col='red', pch=19, cex=2) 
plot(p224r63_2011$B2_sre, p224r63_2011$B1_sre, col='red', pch=19, cex=2)

#funzione pairs->mette in correlazione a 2 a 2 le variabili del dataset, in questo caso le correlazioni tra le bande, alcune bande sono molto correlate tra loro
pairs(p224r63_2011)

