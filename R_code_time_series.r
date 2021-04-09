#time series analysis: Greenland increase of temperature
#Data and code from Emanuela Cosma

#install.packages('raster')
#install.packages('rgdal')
#install.packages('rasterVis')
library(raster)
library(gdal)
library(rasterVis)
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

#list f files   #pattern:scritta comune che hanno i file, quindi lst
rlist <- list.files(pattern="lst")
rlist #lista di file a cui vogliamo applicare la funzione raster (mediante lapply)

# funzione lapply -> X=lista dei file su cui applicare la funzione, FUN= funzione da applicare
import <- lapply(rlist,raster)
import #info di tutti i file caricati

# funzione stack: raggruppiamo i 4 file raster in un blocco unico 
TGr <- stack(import) 
TGr
plot(TGr) #plotta direttamente le 4 immagini
#
plotRGB(TGr, 1, 2, 3, stretch="Lin") #nella stessa immagine ci sono i valori dell'immagine 1, 2 e 3, quindi una sovrapposizione
plotRGB(TGr, 2, 3, 4, stretch="Lin")  #immagine del 2005 nel rosso, immagine del 2010 nel verde e l'immagine del 2015 nel blu 
plotRGB(TGr, 4, 3, 2, stretch="Lin") 

library(rasterVis)
TGr
#funzione levelplot: rispetto alla fuzione plot ha una risoluzione migliore e genera un grafico di contorno che rappresenta le medie 
levelplot(TGr)
#singola immagine, nel grafico sono riportati i valori medi
levelplot(TGr$lst_2000)
levelplot(TGr$lst_2005)
levelplot(TGr$lst_2010)
levelplot(TGr$lst_2015)
#cambiarere i colori del grafico
cl <- colorRampPalette(c("blue","light blue","pink","red"))(100)
levelplot(TGr,col.regions=cl) 
#4 attributi, che corrispondono ai titoli delle immagini->names.attr
levelplot(TGr,col.regions=cl,names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))
#main-> titolo del grafico: LST variation in time
levelplot(TGr,col.regions=cl,main="LST variation in time",names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))

#Melt files-> unirli in un unico raster
meltlist <- list.files(pattern="melt") 
melt_import<- lapply(meltlist,raster)
melt_import
melt<-stack(melt_import)
melt
#levelplot
levelplot(melt)
cl <- colorRampPalette(c("dark blue","light blue","magenta","red"))(100)
levelplot(melt,col.regions=cl)

#si può effettuare una differenza tra le immagini, ad esempio lo scioglimento del 1979 confrontato con l'immagine del 2007, la risultante della differenza sarà quando ghiaccio si è sciolto in quell'arco di tempo
melt_amount <- melt$X2007annual_melt - melt$X1979annual_melt #bisogna legare il singolo file all'operazione, quindi $

clb <- colorRampPalette(c("blue","white","red"))(100)
plot(melt_amount, col=clb) #le zone rosse sono quelle dove si ha avuto uno scioglimento maggiore del ghiaccio, dal 1979 al 2007

levelplot(melt_amount, col.regions=clb) #picchi nel grafico mostrano il momento di scioglimento del ghiaccio maggiore

#titolo grafico
plot(dif,col=clb,main="Melt area variation 1979 - 2007")


