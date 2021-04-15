# R_code_copernicus.r
#visualizzaione dei dati scaricati da Copernicus

setwd('C:/Users/Sery/Desktop/lab')

install.packages('ncdf4')
library(raster)
library(ncdf4)

albedo <- raster ('c_gls_ALBH_202006130000_GLOBE_PROBAV_V1.5.1.nc')
albedo #informazioni sui dati: 632217600 celle, sistema di riferimento wgs84

#non montiamo le bande sui componenti rgb, ma abbiamo un singolo strato, quindi possiamo decidere noi l scala di colore da utilizzare
cl <-colorRampPalette(c('blue', 'green','red', 'yellow'))(100)
plot(albedo,col=cl)    #quanto il suolo riflette energia

#resampling:funzione aggregate: da un'immagine con n pixel la trasformo in un'immagine con un numero minore di pixel, per alleggerire l'immagine ed avere un'elaborazione più veloce (factor è l'argomento di diminuzione, es fattore 50:diminuito di 2500 volte l'immagine originale)
albedores<-aggregate(albedo,fact=100) #diminuisco l'informazione di 10000 volte
plot(albedores,col=cl)



