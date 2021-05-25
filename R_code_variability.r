# R_code_variability.r

library(raster)
library(RStoolbox)
library(ggplot2)
# install.packages("viridis")
library(viridis)
library(gridExtra)

setwd('C:/Users/Sery/Desktop/lab')

#importiamo l'immagine sentinel, quindi utiliziamo la funzione brick (l'immagine è composta da 3 layer: NIR, red e green)
sent <- brick("sentinel.png")
sent # informazioni sull'immagine
# NIR 1, RED 2, GREEN 3
# r=1, g=2, b=3 #default della funzione plotRGB, quindi si può anche non scrivere
plotRGB(sent, stretch='lin') # plotRGB(sent,r=1, g=2, b=3)  (plotRGB è una funzione di RStoolbox)
plotRGB(sent,r=2, g=1, b=3, stretch='lin') # vegetazione in verde, l'acqua assorbe tutta la radiazione

# Moving window: viene calcolata la deviazione standard nel pixel centrale (sulla base di 9 pixel) e la moving window continua per tutti i gruppi di 9 pixel. Alla fine ottengo una nuova mappa che deriva dalla mappa principale (ma nei pixel laterali esterni ha dei non valori), con all'interno i pixel basati sulla deviazione standard calcolata in una certa finestra (3x3). Maggiore è la finestra di pixel utilizzata più è diversa dalla mappa originale.
#la finestra mobile pssa su un solo layer dell'immagine, quindi andrebbero accorpati tutti i layer, per questo ad esempio si può utilizzare l'NDVI 
sent #vediamo il nome delle bande 1,2,3
#sentinel.1=NIR, sentinel.2=red, sentinel.3=green
nir <- sent$sentinel.1
red <- sent$sentinel.2
ndvi <- (nir-red)/ (nir+red)
plot(ndvi) # nel bianco no c'è vegetazione (acqua, crepacci), il marrone è roccia nuda, giallo e verde chiaro sono le parti di bosco, mentre il verde scuro sono le praterie 
cl <- colorRampPalette(c('black','white','red','magenta','green'))(100)
plot(ndvi,col=cl)

#calcolo deviazione standard-> funzione focal
#w=moving window 3x3 (più grande è la finestra di pixel più è lungo il calcolo)
ndvisd3 <- focal(ndvi, w=matrix(1/9,nrow=3,ncol=3), fun=sd) #facciamo una finestra mobile 3x3 sull'immagine ndvi

clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)
plot(ndvisd3, col=clsd) #giallo-rosso=dev. standard più alta (blu->dev.standard bassa, equivale alla roccia nuda)

#media dell'immagine ndvi
ndvimean3 <- focal(ndvi, w=matrix(1/9,nrow=3,ncol=3), fun=mean)
plot(ndvimean3, col=clsd)

# calcolo con diversa moving window (13x13)
ndvisd13 <- focal(ndvi, w=matrix(1/169,nrow=13,ncol=13), fun=sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)
plot(ndvisd13, col=clsd)

# calcolo con diversa moving window (5x5)
ndvisd5 <- focal(ndvi, w=matrix(1/25,nrow=5,ncol=5), fun=sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100)
plot(ndvisd5, col=clsd)

# per compattare i dati si può anche utilizzare la funzione rasterPCA (pacchetto RStoolbox) e usare la prima componente principale
# RasterPCA -> analisi componenti principali per raster
#PCA
sentpca <- rasterPCA(sent)
plot(sentpca$map) #la PC1 contiene la maggior parte delle informazioni, le altre gradualmente perdono l'informazione
sentpca
summary(sentpca$model) #proporzione di variabilità spiegata da ogni singolo componente
#la prima PC contiene il 67.36% dell'informazione(variabilità) originaria




