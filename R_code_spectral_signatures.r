# R_code_spectral_signatures.r
 
library(raster)
library(rgdal)
library(ggplot2)

setwd('C:/Users/Sery/Desktop/lab')

defor2 <- brick('defor2.jpg')
# defor2.1, defor2.2 ,defor2.3
# NIR, red, green

plotRGB(defor2, r=1, g=2, b=3, stretch='lin') #plotRGB(defor2, r=1, g=2, b=3, stretch='hist')

# click: funzione per creare le firme spettrali (cliccando in un punto della mappa si ottengono le informazioni)

click(defor2, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="yellow") #non chiudere plotRGB(defor2, r=1, g=2, b=3, stretch='lin')
#results
#x     y  cell defor2.1 defor2.2 defor2.3
#1 477.5 346.5 94405      241      229      217
#      x     y   cell defor2.1 defor2.2 defor2.3
#1 548.5 183.5 211347       59       69      131

#creiamo un dataframe con 3 colonne (numero di banda, valori di riflettanza per la vegetazione,riflettanza per l'acqua) poi usiamo ggplot2 per creare le firme spettrali
band <- c(1,2,3)
forest <- c(241,8,22)
water <- c (50,69,120)
#tabella
spectrals <- data.frame(band, forest, water)

#plot the spectral signatures
#sull'asse delle x il numero di bande e sulla y la riflettanza
#ggplot inserisce il plot, la funzione geom_line inserisce le geometrie nel grafico
ggplot(spectrals, aes(x=band)) + 
geom_line(aes(y=forest), color='green') +
geom_line(aes(y=water), color='blue') +
labs(x='band', y='reflectance')
#labs-> funzione che inserisce nel grafico i nomi degli assi
#l'acqua ha un comportamento, a livello di riflettanza, praticamente opposto alla vegetazione

#### Multitemporal analisys

defor1 <- brick('defor1.jpg')
plotRGB(defor1, r=1, g=2, b=3, stretch='lin')

#firme spettrali defor1
click(defor1, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="yellow")
# Results
#     x     y   cell defor1.1 defor1.2 defor1.3
#1 85.5 316.5 115040      214       13       31
#      x     y   cell defor1.1 defor1.2 defor1.3
#1 108.5 292.5 132199      213       25       42
#     x     y   cell defor1.1 defor1.2 defor1.3
#1 29.5 312.5 117840      224       22       36
#     x     y   cell defor1.1 defor1.2 defor1.3
#1 58.5 301.5 125723      186       11       26
#     x     y   cell defor1.1 defor1.2 defor1.3
#1 58.5 332.5 103589      216       11       28

#defor2
plotRGB(defor2, r=1, g=2, b=3, stretch='lin')
click(defor2, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="yellow")
# Results
#  x     y  cell defor2.1 defor2.2 defor2.3
#1 71.5 341.5 97584      180      178      166
#     x     y   cell defor2.1 defor2.2 defor2.3
#1 88.5 315.5 116243      167      160      141
#     x     y   cell defor2.1 defor2.2 defor2.3
#1 98.5 335.5 101913      190      163      156
#     x     y   cell defor2.1 defor2.2 defor2.3
#1 96.5 305.5 123421      174      107      116
#      x     y  cell defor2.1 defor2.2 defor2.3
#1 108.5 342.5 96904      183      168      147

# Dataset 
band <- c(1, 2, 3)
time1 <- c(214, 13, 31)
time1p2 <- c(213, 25, 42)
time2 <- c(180, 178, 166)
time2p2 <- c(167, 160, 141)
 
#Dataframe
spectrals <- data.frame(band, time1, time2, time1p2, time2p2)

#plot the spectral signature
ggplot(spectrals, aes(x=band)) + 
geom_line(aes(y=time1), color='red') +
geom_line(aes(y=time1p2), color='red') +
geom_line(aes(y=time2), color='black') +
geom_line(aes(y=time2p2), color='black') +
labs(x='band', y='reflectance')
#linetype='dotted'-> nel grafico i punti sono rappresentati da linee con puntini invece che linee continue

# Image from Earth Observatory
eo <- brick('nz.jpg')
plotRGB(eo, r=1, g=2, b=3, stretch='hist')
#selezioniamo i punti sulla mappa
click(eo, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="yellow")
#results
#   x     y  cell nz.1 nz.2 nz.3
#1 228.5 353.5 90949    0   84  105
#     x     y   cell nz.1 nz.2 nz.3
#1 269.5 257.5 160110    1  116  109
#      x     y   cell nz.1 nz.2 nz.3
#1 355.5 243.5 170276   25   44   38

#tabella
band<- c(1,2,3)
stratum1 <-c(0,84,105)
stratum2 <- c(1,116,109)
stratum3 <- c(25,44,38)

#data frame
spectralsg <- data.frame(band, stratum1, stratum2, stratum3)

#plot data
ggplot(spectralsg, aes(x=band)) + 
geom_line(aes(y=stratum1), color='yellow') +
geom_line(aes(y=stratum2), color='red') +
geom_line(aes(y=stratum3), color='green') +
labs(x='band', y='reflectance')


