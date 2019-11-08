#*****************************************************
### Predict landscape permeability for Gardermoen ----
#*****************************************************

# Make raster stack --------

# * Load libraries ======
library(raster)

# * Load rasters ======

# ** Transform layers #######

log_dist_building <- raster("maps/dist_building.tif")
values(log_dist_building) <- log10(values(log_dist_building) + 1)
plot(log_dist_building)

rail_cross <- raster("maps/crossed_rail.tif")
summary(values(rail_cross))

road_cross <- raster("maps/dist_roads.tif")
values(road_cross) <- ifelse(values(road_cross)==0, 1, 0)
plot(road_cross)

dist_passage <- raster("maps/fence.tif")
values(dist_passage) <- ifelse(values(dist_passage)==0, 0, 800) #at 800 any effect of the passage seems to be gone
crossing <- raster("maps/crossings_grey.tif")
values(dist_passage) <- ifelse(values(crossing)==1, 0, values(dist_passage))
crossing <- raster("maps/crossings_high_use.tif")
values(dist_passage) <- ifelse(values(crossing)==1, 0, values(dist_passage))
crossing <- raster("maps/crossings_low_use.tif")
values(dist_passage) <- ifelse(values(crossing)==1, 0, values(dist_passage))
crossing <- raster("maps/crossings_green.tif")
values(dist_passage) <- ifelse(values(crossing)==1, 0, values(dist_passage))
plot(dist_passage)
writeRaster(dist_passage, filename="maps/test.tif", overwrite=T)

log_road_dist <- raster("maps/dist_roads.tif")
values(log_road_dist) <- log10(values(log_road_dist)+1)

dist_roads <- raster("maps/dist_roads.tif")
road_traffic_high <- raster("maps/dist_road_traffic_high.tif")
values(road_traffic_high) <- ifelse(values(dist_roads) < values(road_traffic_high),0,1)

interaction1 <- interaction2 <- road_traffic_high
values(interaction1) <- values(log_road_dist)*values(road_traffic_high)
values(interaction2) <- values(road_cross)*values(road_traffic_high)

# ** Make brick #######

mybrick <- raster("data/prop_young_forest.tif")
mybrick <- brick(mybrick)
mybrick <- addLayer(mybrick, raster("data/slope.tif"))
mybrick <- addLayer(mybrick, rail_cross)
mybrick <- addLayer(mybrick, log_dist_building)
mybrick <- addLayer(mybrick, raster("data/prop_ar5_agri.tif"), raster("data/prop_ar5_bog.tif"), raster("data/prop_ar5_urban.tif"))
mybrick <- addLayer(mybrick, raster("data/prop_old_forest.tif"), raster("data/prop_water.tif"))
mybrick <- addLayer(mybrick, road_cross)
mybrick <- addLayer(mybrick, raster("maps/crossings_grey.tif"), raster("maps/crossings_high_use.tif"), raster("maps/crossings_low_use.tif"), raster("maps/crossings_green.tif"))
mybrick <- addLayer(mybrick, dist_passage)
mybrick <- addLayer(mybrick, log_road_dist)
mybrick <- addLayer(mybrick, road_traffic_high)
mybrick <- addLayer(mybrick, interaction1, interaction2)

airport <- raster("data/prop_airport.tif") #for posthoc removal

# Predict --------

# * Load libraries ======
library(ResourceSelection)
library(boot)

# * Load model ======
load("outputs/mod_sspf_allyear.rda")
sspf_mod <- mod_sspf_allyear
coefs <- sspf_mod$coefficients

# * Make newdat ======
newdat <- as.data.frame(mybrick)
str(newdat)
newdat[,3] <- as.numeric(newdat[,3])
table(newdat[,3])
newdat[,3] <- ifelse(newdat[,3]==1, 0, 1)
str(newdat)

tmp <- newdat[,15]
sum(is.na(tmp)) #I don't get it, but it seems to correspond with the values of 800
newdat[,15] <- as.numeric(newdat[,15])
newdat[,15] <- ifelse(is.na(tmp), 800, 0)
table(newdat[,15])
str(newdat)

newdat <- data.frame(intercept=1, step_length=25, squareLS = 25^2, newdat)
newdat <- as.matrix(newdat)
head(newdat)

# * Predict ======

predvals <- (newdat %*% coefs)

linpred <- predvals[,1]
predprob <- inv.logit(linpred)

# ** make and write raster #######
slope <- raster("data/slope.tif")

permeability <- slope
values(permeability) <- predprob
plot(permeability)

writeRaster(permeability, "maps/permeability.tif", overwrite=T)
