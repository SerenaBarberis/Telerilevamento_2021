# R_code_variability.r

library(raster)
library(RStoolbox)
library(ggplot2)
# install.packages("viridis")
library(viridis) #colorare i plot di ggplot in modo automatico
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
#calcolo focal pc1
pc1 <- sentpca$map$PC1
plot(pc1)
pc1sd5 <- focal(pc1, w=matrix(1/25,nrow=5,ncol=5), fun=sd)
clsd <- colorRampPalette(c('blue','green','magenta','pink','orange','brown','red','yellow'))(100)
plot(pc1sd5, col=clsd)

#come inserire un segmento di codice esterno dentro il nostro codice: funzione source
source('source_test_lezione.r') #calcolo deviazione standard 7x7 dal codice nella cartella

source('source_ggplot.r')

#plottiamo tramite ggplot i dati
#funzione ggplot: crea una nuova finestra in cui poi si inseriscono i dati
#funzione geom_point: crea punti allinterno della finestra
#geom_raster: inserisce i pixel nella finestra, formando una mappa
#aes: definisce l'estetica dell'immagine, in questo caso x e y sono le coordinate geografiche e il riempimento (fill) è il layer del raster
ggplot() + geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis()

#pacchetto viridis: contiene 8 scale di colore automatiche (# The package contains eight color scales: “viridis”, the primary choice, and five alternatives with similar properties - “magma”, “plasma”, “inferno”, “civids”, “mako”, and “rocket” -, and a rainbow color map - “turbo”.)
# https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html

p0 <- ggplot() + geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis() +  ggtitle("Standerd deviationof PC1 by viridis scale")

p1 <- ggplot() + geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis(option="magma") +  ggtitle("magma palette")

p2 <- ggplot() + geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis(option="plasma") +  ggtitle("plasma palette")

p3 <- ggplot() + geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis(option="inferno") +  ggtitle("inferno palette")

p4 <- ggplot() + geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis(option="civids") +  ggtitle("cividis palette")

p5 <- ggplot() + geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis(option="mako") +  ggtitle("mako palette")

p6 <- ggplot() + geom_raster(pc1_devst, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis(option="rocket") + ggtitle("rocket palette")

p7 <- ggplot() + geom_raster(pc1sd5, mapping = aes(x = x, y = y, fill = layer)) + scale_fill_viridis(option="turbo") + ggtitle("turbo palette")

grid.arrange(p0, p1, p2, p3, p4, p5, p6, p7, nrow = 2) # this needs griExtra, tabella con tutte le scale di colori viridis (unisce le immagini di ggplot in una unica). nrow è il numero di righe
