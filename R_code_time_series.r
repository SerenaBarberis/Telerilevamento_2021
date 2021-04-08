#time series analysis: Greenland increase of temperature
#Data and code from Emanuela Cosma

#install.packages('raster')
library(raster)
library(gdal)
setwd('C:/Users/Sery/Desktop/lab/greenland')

#raster function (pacchetto raster): crea un immagine raster di un singolo oggetto
lst_2000 <- raster("lst_2000.tif")
lst_2000 #informazioni sul file

plot(lst_2000)

#importiamo le altre immagini
lst_2005 <- raster("lst_2005.tif")
plot(lst_2005)
lst_2010 <- raster("lst_2010.tif")
plot(lst_2010)
lst_2015 <- raster("lst_2015.tif")
plot(lst_2015)

#grafico con tutte e 4 le immagini-> funzoine par
par(mfrow=c(2,2))
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)

# come importare le immagine tutte insieme-> funzione lapply: applica la funzione raster a una lista di file
#funzione list.files: crea una lista di file che R userà per applicare la funzione lapply

#list f files   #pattern:scritta comune che hanno i fule, quindi lst
rlist <- list.files(pattern="lst")
rlist #lista di file a cui vogliamo applicare la funzione raster (mediante lapply)

# funzione lapply -> X=lista dei file su cui applicare la funzione, FUN= funzione da applicare
import <- lapply(rlist,raster)
import #info di tutti i file caricati

# funzione stack: raggruppiamo i 4 file raster in un blocco unico 
TGr <- stack(import) 
plot(TGr) #plotta direttamente le 4 immagini
#
plotRGB(TGr, 1, 2, 3, stretch="Lin") #nella stessa immagine ci sono i valori dell'immagine 1, 2 e 3, quindi una sovrapposizione
plotRGB(TGr, 2, 3, 4, stretch="Lin")  #immagine del 2005 nel rosso, immagine del 2010 nel verde e l'immagine del 2015 nel blu 
plotRGB(TGr, 4, 3, 2, stretch="Lin") 

install.packages('rasterVis')
library(rasterVis)


