## load libraries ----
library(raster)
library(rgdal)


## load maps -----
func_migr_b001_without_cross_2802 <- raster("maps/func_migr_b001_without_cross_2802.asc")
func_migr_b001_with_cross_2802 <- raster("maps/func_migr_b001_with_cross_2802.asc")


## plot maps ----
plot(func_migr_b001_without_cross_2802) 
plot(func_migr_b001_with_cross_2802)


####### sum functuionality -------------------
# stationary ----
cellStats(func_stati_b001_without_cross_2802, sum) # [1] 42547849
cellStats(func_stati_b001_with_cross_2802, sum) # [1] 43289952

cellStats(func_stati_b001_with_cross_2802, sum) - cellStats(func_stati_b001_without_cross_2802, sum)
# [1] 742103.1
# > (742103.1/42547849)*100 ----> or do I have to use the larger number (func with cross)?
# [1] 1.744161 %


# migratory ----
cellStats(func_migr_b001_without_cross_2802, sum) # [1] 153484358
cellStats(func_migr_b001_with_cross_2802, sum) # [1] 153497768

cellStats(func_migr_b001_with_cross_2802, sum) - cellStats(func_migr_b001_without_cross_2802, sum)
# [1] 13409.49
# > (13409.49/153484358)*100 ----> or do I have to use the larger number (func with cross)?
# [1] 0.008736714 %