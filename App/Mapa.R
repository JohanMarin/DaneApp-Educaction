library(sp)
library(rgdal)
library(data.table)


servicios <- as.data.table(read.csv("../data/servicios.csv"))
mapa<- rgdal::readOGR("../data/depto/depto.shp")

ma2014 <- mapa
ma2015 <- mapa

ma2014@data <- servicios[servicios$year==2014]
ma2015@data <- servicios[servicios$year==2015]

map2015<- ma2015
map2014<- ma2014


#---------------------------------------------------------------------------------------


#utah = map2015
#utah@data$id = rownames(utah@data)
#utah.points = fortify(utah, region="id")

#ggplot() + geom_polygon(data = map2015, aes(x=long, y = lat, group = group)) + 
#  coord_fixed(1.3)+
#  geom_path(color="white") +
#  coord_equal() +
#  scale_fill_brewer("electricidad")


