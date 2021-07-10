# R_code_no2.r

library(raster)
library(RStoolbox) #per l'analisi raster multivariata

#1. Set the working directory EN
setwd('C:/Users/Sery/Desktop/lab/EN')


#2. Import the first image (single band) EN_0001
EN01 <- raster('EN_0001.png')   #con la funzione raster impporto una sola banda, mentre con la funzinoe brick le importo tutte

#3. Plot the first importated image with your preferred Color Ramp Palette
cl <- colorRampPalette(c("blue","black","orange","purple")) (200)
plot(EN01, col=cl)                   

# 4. Import the last image (13th) and plot it with previous Color Ramp Palette
EN13 <- raster('EN_0013.png')
plot(EN13, col=cl)                   

#5. Make the difference between the two images and plot it
ENdif <- EN13 - EN01 #diminuzione della no2 (gennaio - marzo)
plot(ENdif, col=cl)

# 6. plot everything, altogether
par(mfrow=c(3,1))
plot(EN01, col=cl, main='NO2 in January') 
plot(EN13, col=cl,  main='NO2 in March') 
plot(ENdif, col=cl, main='Difference March - January')

# 7. Import the whole set
EN01 <- raster('EN_0001.png')
EN02 <- raster('EN_0002.png')
EN03 <- raster('EN_0003.png')
EN04 <- raster('EN_0004.png')
EN05 <- raster('EN_0005.png')
EN06 <- raster('EN_0006.png')
EN07 <- raster('EN_0007.png')
EN08 <- raster('EN_0008.png')
EN09 <- raster('EN_0009.png')
EN10 <- raster('EN_0010.png')
EN11 <- raster('EN_0011.png')
EN12 <- raster('EN_0012.png')
EN13 <- raster('EN_0013.png')
# modo più veloce
rlist <- list.files(pattern='EN')
rlist
import <- lapply(rlist,raster)
import

EN <- stack(import)
plot(EN, col=cl)

# 8. Replicate the plot of images 1 and 13 using the stack
dev.off()
par(mfrow=c(2,1))
plot(EN$EN_0001, col=cl)
plot(EN$EN_0013, col=cl) #immagini prese dallo stack

# 9. Compute a PCA over the 13 images
ENpca <- rasterPCA(EN)

summary(ENpca$model)

plotRGB(ENpca$map, r=1, g=2, b=3, stretch="lin") #gran parte dell'informazione è nella componente red, con la prima componente abbiamo quasi tutta la varianza spiegata

# 10. Compute the local variability (local standard deviation) of the first PCA
PC1sd <- focal(ENpca$map$PC1, w=matrix(1/9, nrow=3, ncol=3), fun=sd)
plot(PC1sd, col=cl)
