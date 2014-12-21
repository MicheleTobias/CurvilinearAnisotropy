library(sp)
library(gstat)
library(rgdal)

#load data
# needs to be data.frame
depths.sn<-readOGR(dsn='C:\\Users\\Michele\\Documents\\Research\\CurvilinearAnisotropy\\WillametteRiver', layer='points_sn')

data.sn<-subset(depths.sn, X > 0 & Y > 0)
data.sn2<-cbind(data.sn$GID, data.sn$DEPTH, data.sn$N, data.sn$S)
data.sn2<-data.frame(data.sn2)
names(data.sn2)<-c("GID", "Depth", "N", "S")

#format data
# coordinates(data) = ~x+y
coordinates(data.sn2) = ~N+S

bubble(data.sn2, "Depth")

### Need to figure out how to: 
####### use the variogram function appropriately
####### use the right kriging type

#variogram + pick model
#data.vgm<-variogram(log(Depth)~1, data.sn2)
data.vgm<-variogram(Depth~1, data.sn2, alpha=0)
data.fit<- fit.variogram(data.vgm, model = vgm(1, "Exp", 1000, 0.001))
#data.fit

vgm.data<- vgm(
psill=2, 
model="Exp", 
range=800, 
nugget=0.58, 
anis=c(0,.01))

vgm.data<- vgm(
psill=2.8, 
model="Exp", 
range=1100, 
nugget=0.58, 
anis=c(0,.01))

#plot(data.vgm, data.fit)
#x11()
#plot(data.vgm, vgm.data)

vgm.dir=variogram(Depth~1, data.sn2, alpha = 0)
data.fit<- fit.variogram(data.vgm, model = vgm(1, "Exp", 1000, 0.001))
plot(vgm.dir, vgm.data)




#kriging
rivergrid<-readOGR(dsn='C:\\Users\\Michele\\Documents\\Research\\CurvilinearAnisotropy\\WillametteRiver', layer='rivergrid_sn')
rivergrid2<-cbind(rivergrid$GID, rivergrid$N, rivergrid$S)
rivergrid2<-data.frame(rivergrid2)
names(rivergrid2)<-c("GID", "N", "S")
coordinates(rivergrid2)<-~N+S
#data.kriged<- krige(log(Depth)~1, locations=data.sn2, model=vgm.data, newdata=rivergrid2)
data.kriged<- krige(Depth~1,  locations=data.sn2, model=vgm.data, newdata=rivergrid2)
x11()
spplot(data.kriged["var1.pred"])

data.kriged@data$GID<-rivergrid2$GID

writeOGR(data.kriged, dsn="C:\\Users\\Michele\\Documents\\Research\\CurvilinearAnisotropy\\WillametteRiver", layer="krigedpoints", driver="ESRI Shapefile")




#sample with grid points