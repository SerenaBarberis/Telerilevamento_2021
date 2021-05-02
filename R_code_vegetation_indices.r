#R_code_vegetation_indices.r
#calcolo dell'indice di vegetazione per osservare quanto è sana la vegetazione e quante biomassa è presente
setwd('C:/Users/Sery/Desktop/lab')
library(raster)

defor1<-brick('defor1.jpg')
defor2<-brick('defor2.jpg')

# b1= NIR, b2= red, b3=green

par(mfrow=c(1,2))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")




