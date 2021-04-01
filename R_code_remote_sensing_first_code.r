# R_code_remote_sensing_first_code.r #

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









