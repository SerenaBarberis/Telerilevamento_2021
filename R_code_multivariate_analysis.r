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

#funzione raster aggregate: aggreghiamo i pixel con una certa media in modo da avere un'immagine a risoluzione più bassa e quindi più leggera->ricampionamento
#aggregate cells: resampling (ricampionamento)
#fact=quanto vogliamo ingrandire i pixel, in questo caso linearmente aumentiamo di 10. dalla risoluzione iniziale di 30m abbiamo un' immagine di 300m (aumentare la grandezza dei pixel diminuisce la risoluzione)
p224r63_2011res <- aggregate(p224r63_2011, fact=10)

par(mfrow=c(2,1))
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch='lin')
plotRGB(p224r63_2011res, r=4, g=3, b=2, stretch='lin')

#funzione rasterPCA:  compatta i dati in un numero minore di bande (pacchetto RStoolbox)
# la PCA produce sia un modello che una mappa, quindi per visualizzare solo la mappa si utilizza $
p224r63_2011res_pca <- rasterPCA(p224r63_2011res)
p224r63_2011res_pca # informazioni su cosa abbiamo generato
# funzione summary:sommario del nostro modello e dei dati
summary(p224r63_2011res_pca $model)
#cumulative proportion: con le prime 3 bande spiego tutta la variabilità possibile
plot(p224r63_2011res_pca$map) #prima componente con quasi tutta l'informazione(variabilità),quindi foresta,agricolo,ecc.. mentre l'ultima ha praticamente solo rumore(residuo)

plotRGB(p224r63_2011res_pca$map, r=1,g=2, b=3, stretch='lin')

