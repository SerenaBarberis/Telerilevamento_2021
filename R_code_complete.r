# R_code_complete.r Telerilevamento Geo-Ecoologico

#---------------------------------------------------

#Summary:

# 1. Remote sensing first code
# 2. R code time series 
# 3. R code Copernicus data
# 4. R code knitr
# 5. R code multivariate analysis
# 6. R code classification
# 7. R code ggplot2
# 8. R code vegetation indices
# 9. R code land cover
# 10. R code variability
# 11. R code spectral signatures

#------------------------------------------------

# 1. Remote sensing first code
setwd ("C:/Users/Sery/Desktop/lab")

install.packages("raster")
library(raster)

#brick function: serve per caricare i dati, importa i dati raster e li inserisce in R ("" perchè usciamo da R per prendere l'immagine nella cartella lab)
p224r63_2011 <- brick("p224r63_2011_masked.grd")

p224r63_2011 #informazioni sul file caricato, rasterbrick:serie di bande in formato raster; 1499 righe di pixel e 2967 colonne di pixel, 4447533 pixel totali per ogni singola banda; risoluzione 30m (landstat); 7 bande

#plot function: genera un'immagine del dato, applica una scala di colori default
plot(p224r63_2011)
#B1=blu       B5,B7=infrarosso medio
#B2=verde     B6= infrarosso termico, non è una riflettanza e ha una diversa risoluzione (in genere 60m invece che 30m)
#B3=rosso
#B4= NIR

#colorRampPalette function: stabilire la variazione dei colori (scala di colori) 
#c=array ->racchiude gli elementi in uno stesso argomento (in questo caso i colori)
#100= livelli di colore (sfumatura tra i 3 colori)

cl <- colorRampPalette(c('black','grey','light grey'))(100)
plot(p224r63_2011, col=cl)

#nuova scala di colori (si assiociano i colori ai valori di riflettanza)
cl <- colorRampPalette(c('blue','green','grey', 'red', 'magenta', 'yellow'))(100)
#cl <- colorRampPalette(c('blue','green', 'red', 'magenta', 'yellow'))(50)
plot(p224r63_2011, col=cl)

#bande di landsat
#B1: blu
#B2: verde
#B3: rosso
#B4: infrarosso vicino (prima lunghezza d'onda dopo il rosso più vicino al visibile)
#B5: infrarosso medio
#B6: termico
#B7: infrarosso medio

#$->lega la banda all'immagine satellitare totale (se non si vuole usare si può usare la funzione attach)
#plotto solo la banda del blu (B1_sre)
plot(p224r63_2011$B1_sre)
#plottare una sola banda con un'altra scala di colore
cl <- colorRampPalette(c('blue','green','grey', 'red', 'magenta', 'yellow'))(100)
plot(p224r63_2011$B1_sre,col=cl)

# funzione par: funzione generica, serve per plottare solo determinati elementi, decidendone la disposizione. (mf=multiframe)
#plottare la banda del blu assieme alla banda del verde

par(mfrow=c(1,2)) #1 riga e 2 colonne (par(mfrow=c(2,1)) 2 righe e 1 colonna #se si vogliono determinare prima il numero di colonne e poi le righe->par(fmcol..)
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

# plottare le prime 4 bande di landsat
par(mfrow=c(4,1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
# 2 righe e 2 colonne
par(mfrow=c(2,2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)

#per ogni banda mettiamo una diversa scala di colori, all'interno dello stesso grafico 2x2
par(mfrow=c(2,2))
clb <- colorRampPalette(c('dark blue','blue','light blue'))(100) 
plot(p224r63_2011$B1_sre, col=clb)

clg <- colorRampPalette(c('dark green','green','light green'))(100)
plot(p224r63_2011$B2_sre, col=clg)

clr <- colorRampPalette(c('dark red','red','pink'))(100)
plot(p224r63_2011$B3_sre, col=clr)

cln <- colorRampPalette(c('red','orange','yellow'))(100)
plot(p224r63_2011$B4_sre, col=cln)

#come visualizzare i dati con i plot RGB
#bande di landsat
#B1: blu
#B2: verde
#B3: rosso
#B4: infrarosso vicino (prima lunghezza d'onda dopo il rosso più vicino al visibile)
#B5: infrarosso medio
#B6: termico
#B7: infrarosso medio

#plotRGB: funzione che plotta un oggetto raster con molti livelli secondo le bande RGB (r3,g2,b1->come vediamo noi l'immagine). stretch:prendiamo la riflettanza delle singole bande per evitare la distorsione verso una sola sfumatura del colore). lin=lineare
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")

#Cambiamo la disposizione RGB per visualizzare diversamente l'immagine, R4,G3,B2 (rimuoviamo il blu)
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin") #vegetazione rossa
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin") #vegetazione verde "fluorescente", si vede bene la componente agricola (viola)
plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="Lin") #infrarosso nella componente blu, vegetazione blu, suolo nudo giallo

#montiamo le 4 immagini all'interno dello stesso grafico
pdf('immagine.pdf') #per salvare l'immagine in pdf
par(mfrow=c(2,2))
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin") 
plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="Lin")
dev.off()

#histogram stretch
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="hist") 

# par colore visibile, falsi colori e falsi colori con histogram stretch
par(mfrow=c(3,1))
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="hist") #individua tutte le differenze della componente vegetale (non più omogeneo come si vede con lo stretch lineare)

#PCA analisi delle componenti principali 
install.packages('RStoolbox')
library(RStoolbox)

# importiamo 1988 image, quindi p224r63_1988_masked, per avere un confronto con l'immagine satellitare del 2011
p224r63_1988 <- brick("p224r63_1988_masked.grd")
p224r63_1988
plot(p224r63_1988) #visualizza le singole bande (le stesse dell'immagine del 2011)
#visualizziamo l'immagine con l'RGB 
plotRGB(p224r63_1988, r=3, g=2, b=1, stretch="Lin")
#per vedere l'immagiine con l'infrarosso vicino (NIR)
plotRGB(p224r63_1988, r=4, g=3, b=2, stretch="Lin")

#plot in RGB con l'immagine del 1988 e 2011
par(mfrow=c(2,1))
plotRGB(p224r63_1988, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")

#plot 2x2 con 2 immagini in NIR con stretch lineare e 2 con histogram strech (utile ad esempio per studi di geologia,petrografia, per rilevare meglio la granulometria, che anch'essa influenza la riflettanza)
pdf('multitemp.pdf')
par(mfrow=c(2,2))
plotRGB(p224r63_1988, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_1988, r=4, g=3, b=2, stretch="hist")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="hist")
dev.off()

#---------------------------------------------------

# 2. R code time series 

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

#-----------------------------------------------------------------

# 3. R_code_copernicus.r
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

#------------------------------------------------------------------------
# 4. R_code_knit.r

setwd('C:/Users/Sery/Desktop/lab')
library(knitr)
#knitr: genera un report che andrà a salvare nella stessa cartella del codice che abbiamo salvato (R_code_greenland.r)
#funzione stitch: primo argomento è il nome del codice (R_code_greenland.r); template->misc 

stitch('R_code_greenland.r.txt', template=system.file("misc", "knitr-template.Rnw", package="knitr"))
#produce un file .tex
# crea una cartella figure con le singole immagini in formato pdf

#------------------------------------------------------------------------

# 5. R_code_multivariate_analysis.r

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

#----------------------------------------------------------

# 6.R_code_classification.r

setwd('C:/Users/Sery/Desktop/lab')
library(raster)
library(RStoolbox)

#funzione brick: prende un pacchetto di dati e crea un raste con bande RGB
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

#funzione plotRGB: permette di visualizzare il rasterbrick
plotRGB(so, 1,2,3, stretch='lin')

#funzione unsuperClass (pacchetto RStoolbox):opera la classificazione non supervised dei pixel. vengono scelti il numero di classi (in questo caso 3)
soc <- unsuperClass(so, nClasses=3) #crea un modello di classificazione e una mappa, che per vedere bisogna plottarla (collegandola con $)
cl <- colorRampPalette(c('yellow','red','black'))(100)
plot(soc$map, col=cl) #funzione set.seed per considerare gli stessi pixel, altrimenti l'immagine può variare perchè considera diversi pixel

#classificazione unsupervised con 20 classi
set.seed(42)
soe <- unsuperClass(so, nClasses=20)
plot(soe$map, col=cl)
#download imagine from https://www.esa.int/ESA_Multimedia/Missions/Solar_Orbiter/(result_type)/images and make the unsupervised classification
sun <- brick('sun.png')
sunc <-unsuperClass(sun, nClasses=3)
plot(sunc$map)
# con 20 classi
sunc <-unsuperClass(sun, nClasses=20)
plot(sunc$map)

#Gran Canyon 
#https://earthobservatory.nasa.gov/images/80948/exploring-the-grand-canyon
#When John Wesley Powell led an expedition down the Colorado River and through the Grand Canyon in 1869, he was confronted with a daunting landscape. At its highest point, the serpentine gorge plunged 1,829 meters (6,000 feet) from rim to river bottom, making it one of the deepest canyons in the United States. In just 6 million years, water had carved through rock layers that collectively represented more than 2 billion years of geological history, nearly half of the time Earth has existed.

setwd('C:/Users/Sery/Desktop/lab')
library(raster)
library(RStoolbox)

#il file è in RGB, quindi si utilizza la funzione brick
gc <- brick('dolansprings_oli_2013088_canyon_lrg.jpg')
plotRGB(gc, r=1, g=2, b=3, stretc='lin')
plotRGB(gc, r=1, g=2, b=3, stretc='hist') #strech ancora più alto dei valori, in modo da visualizzare più variazioni di colore possibili (tutte le gamme delle bande RGB)

#classificazione dell'immagine: si misura la distanza di ogni pixel da un valore multispettrale e si raggruppano a seconda della distanza minore dal valore
#funzione unsuperClass (all interno del pacchetto RStoolbox): classifica i pixel dell'immagine in base alla classe che scegliamo 
#facciamo un modello dell'immagine, quindi avremo la mappa e le informazioni delle classi, per visualizzare solo la mappa nel plot bisogna legarla con $
gcc2 <- unsuperClass(gc, nClasses=2)
plot(gcc2$map)
# con 4 classi
gcc4 <- unsuperClass(gc, nClasses=4)
plot(gcc4$map)

#--------------------------------------------------------------

# 7. R code ggplot2
library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)

setwd("~/lab/")

p224r63 <- brick("p224r63_2011_masked.grd")

ggRGB(p224r63,3,2,1, stretch="lin")
ggRGB(p224r63,4,3,2, stretch="lin")

p1 <- ggRGB(p224r63,3,2,1, stretch="lin")
p2 <- ggRGB(p224r63,4,3,2, stretch="lin")

grid.arrange(p1, p2, nrow = 2) # this needs gridExtra

#-----------------------------------------------------------

# 8. R_code_vegetation_indices.r
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

#--------------------------------------------------------------------

# 9. R_code_land_cover.r

setwd('C:/Users/Sery/Desktop/lab')
install.packages('gridExtra') #permette di usare ggplot per dati raster
library(raster)
library(RStoolbox) #per la classificazione
library(ggplot2) 
library(gridExtra)

#NIR 1, RED 2, GREEN 3

defor1 <- brick("defor1.jpg")
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")

#funzione ggR (pacchetto ggplot): plottare i raster con grafici diversi
ggRGB(defor1,  r=1, g=2, b=3, stretch="Lin") #mostra le coordinate

#defor2
defor2 <- brick("defor2.jpg")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")
ggRGB(defor2,  r=1, g=2, b=3, stretch="Lin")

par(mfrow=c(2,1))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")

par(mfrow=c(2,1))
ggRGB(defor1,  r=1, g=2, b=3, stretch="Lin")
ggRGB(defor2,  r=1, g=2, b=3, stretch="Lin")

#multiframe con ggplo2 e griExtra
p1 <- ggRGB(defor1,  r=1, g=2, b=3, stretch="Lin")
p2 <- ggRGB(defor2,  r=1, g=2, b=3, stretch="Lin")
grid.arrange(p1,p2, nrow=2)

#classificazione unsupervised
d1c <- unsuperClass(defor1, nclasses=2)# produce modello e mappa con 2 valori (perchè abbiamo scelto 2 classi)
plot(d1c$map)
#set.seed() per avere lo stesso risultato

d2c <- unsuperClass(defor2, nclasses=2)
plot(d2c$map)

#con 3 classi
d2c3 <- unsuperClass(defor2, nClasses=3) #agricolo diviso in 2 classi
plot(d2c3$map)

#calcolo perdita di foresta (calcolo frequenza pixel di una certa classe, cioè classe foresta e classe agricolo) -> funzione freq
#defor1
freq(d1c$map) #numeri di pixel delle 2 classi
# aree agricole = 37039
# foresta = 304253
s1 <- 306583 + 34709
prop1 <- freq(d1c$map) / s1
# percentuali
# foreste: 89.1
# aree agricole: 10.9

#defor2
freq(d2c$map)
# aree aperte: 165055
# foreste: 177671
s2 <- 165055 + 177671
prop2 <- freq(d2c$map) / s2
# percentuali
# aree aperte: 48.2
# foreste: 51.8

#generazione dataset(dataframe), 3 colonne (cover, foresta, agricoltura), 2 righe (percentuale nel 1922, percentuale nel 2006)
cover <- c('Forest', 'Agricolture')
percent_1992 <- c(89.1, 10.9)
percent_2006 <- c(48.2, 51.8)
#funzione dataframe:crea una tabella
percentages<-data.frame(cover, percent_1992, percent_2006)

#facciamo il plot con ggplot, in cui definiamo l'estetica del grafico attraverso gli argomenti della funzione
#1922
p1<-ggplot(percentages, aes(x=cover, y=percent_1992, color=cover)) + geom_bar(stat="identity", fill="lightblue") #geom_bar-> grafico a barre
#2006
p2<-ggplot(percentages, aes(x=cover, y=percent_2006, color=cover)) + geom_bar(stat="identity", fill="lightblue")

#mettere i grafici in un'unica immagine
grid.arrange(p1, p2, nrow = 1)

#------------------------------------------------------------------------

# 10.  R_code_variability.r

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


#---------------------------------------------------------------------------------------------------------------------------------

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

#------------------------------------------------------------------
