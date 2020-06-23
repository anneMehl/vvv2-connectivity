## load libraries ----
library(raster)
library(rgdal)


## load maps -----
func_diff_all_1905 <- raster("maps/func_diff_all_1905.asc")

permeability_without_all_crop_1905 <- raster("maps/permeability_without_all_crop_1905.asc")


## plot maps ----
plot() 
plot()


cellStats(quality6_0804, sum) - cellStats(quality6_without_humans_0506, sum)


####### sum functuionality -------------------
# stationary ----

## From jupyterhub:
# 100*(sum(func)-sum(func2))/sum(func)

# = 0.006877481967657158 % (0.007%) change between with and without crossings (green and 
# low-use structures)

# = 0.009023298655115702% (0.009%) change, when removing low- and high-use, 
# and green crossing structures

# Just as a comparison: 4.53738097807044% change when removing buildings



# migratory ----
cellStats(func_migr_b001_without_cross_2802, sum) # [1] 153484358
cellStats(func_migr_b001_with_cross_2802, sum) # [1] 153497768

cellStats(func_migr_b001_with_cross_2802, sum) - cellStats(func_migr_b001_without_cross_2802, sum)
# [1] 13409.49
# > (13409.49/153484358)*100 ----> or do I have to use the larger number (func with cross)?
# [1] 0.008736714 %


str(func_migr_b001_without_cross_2802)
str(func_stati_b001_with_cross_2802)







