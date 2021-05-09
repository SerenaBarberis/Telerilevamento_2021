#R_code_vegetation_indices.r
#calcolo dell'indice di vegetazione per osservare quanto è sana la vegetazione e quante biomassa è presente
setwd('C:/Users/Sery/Desktop/lab')

install.packages('rasterdiv')
library(raster) #require(raster)
library(RStoolbox)
library(rasterdiv)
library(rasterVis)


defor1<-brick('defor1.jpg')
defor2<-brick('defor2.jpg')

# b1= NIR, b2= red, b3=green

par(mfrow=c(1,2))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")

#calcoliamo il DVI1 -> NIR=defor1.1 - RED=defor1.2
dvi1 <- defor1$defor1.1 - defor1$defor1.2 
dvi1
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) # con schema di colori specifici
plot(dvi1, col=cl, main='DVI at atime 1') #tutto ciò che è in rosso è vegetazione, in giallo l'assenza di vegetazione

#calcolo DVI2
dvi2 <- defor2$defor2.1 - defor2$defor2.2 

#confronto tra dvi1 e dvi2
par(mfrow=c(1,2))
plot(dvi1, col=cl,main='DVI at atime 1')
plot(dvi2, col=cl,main='DVI at atime 2')

#calcolo della differenza di indice di vegetazione tra i due dvi
difdvi <- dvi1 - dvi2 #wARNING: C'è qualche differenza nei pixel, ma comunque calcola sui pixel in comune

cld <- colorRampPalette(c('blue','white','red'))(100)
plot(difdvi, col=cld) #il rosso indica la differenza maggiore, quindi la maggiore sofferenza da parte della vegetazione nel tempo (deforestazione)

#calcolo NDVI1
# (NIR-RED)/(NIR+RED)
ndvi1 <- (defor1$defor1.1 - defor1$defor1.2) / (defor1$defor1.1 + defor1$defor1.2) # o anche dvi1/(defor1$defor1.1 + defor1$defor1.2)
plot(ndvi1,col=cl)
#nel pacchetto RStoolbox si trovano già calcolati alcuni indici (es. spectralIndices può fare il calcolo dell'NDVI)
#calcolo NDVI2
ndvi2 <- (defor2$defor2.1 - defor2$defor2.2 ) / (defor2$defor2.1 + defor2$defor2.2 )
plot(ndvi2,col=cl)

par(mfrow=c(1,2))
plot(ndvi1,col=cl)
plot(ndvi2,col=cl)

# RStoolbox->spectralIndices for vegetation calculation
#defor1
vi1 <- spectralIndices(defor1, green=3, red=2, nir=1)
plot(vi2, col=cl)
#defor2
vi2 <- spectralIndices(defor2, green=3, red=2, nir=1)
plot(vi2, col=cl)

# worldwide NDVI

plot(copNDVI)
# Pixels with values 253, 254 and 255 (water) will be set as NA’s.
copNDVI<-reclassify(copNDVI, cbind(253:255,NA)) #eliminiamo l'acqua
plot(copNDVI)
levelplot(copNDVI) #in colore più chiaro i valori più alti di biomassa
