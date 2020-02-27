library(raster)
library(rgdal)


## load maps -----

func_migr_b001_without_cross <- raster("maps/gardermoen_func_migratory_b001_without_cross.asc")
func_migr_b001_with_cross <- raster("maps/gardermoen_func_migratory_b001_without_cross.asc")

cellStats(func_migr_b001_without_cross, sum)
cellStats(func_migr_b001_with_cross, sum)
sum(values(p_stationary_without_cross_2702))


plot(func_migr_b001_without_cross)
str(func_migr_b001_without_cross)
# ..@ ncols   : int 377
# ..@ nrows   : int 425





