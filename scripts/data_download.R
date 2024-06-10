
rm(list=ls()) 
library(raster)
library(sf)
library(dplyr)
library(RColorBrewer)
library(starsExtra)
library(rgdal)
library(geodata)

### download covariates variable from isric data hub for soil and bioclimate and elevation and Nigeria admin data from the the global admin data 

work_dir <- "~/Desktop/CIAT_JobApplication/Candidate_Test"
work_dir <- "/media/jemal/EIAR_ASIS/CIAT_JobApplication/Candidate_Test"
setwd(work_dir)
#### isric soil data 
out_dir <- "data/isric/"
out_cov <- "data/Nigeria/covariates/"
if (!dir.exists(out_dir)){
  dir.create(file.path(out_cov), recursive = TRUE)
}
if (!dir.exists(out_cov)){
  dir.create(file.path(out_cov), recursive = TRUE)
}


# https://gadm.org/maps/NGA.html
adm1<-geodata::gadm(country = "NGA",level = 0,path = "data/")
adm1<-geodata::gadm(country = "NGA",level = 0,path = "data/")
adm2 <- geodata::gadm(country = "NGA",level = 0,path = "data/")
dem <- raster(geodata::elevation_30s(country = "NGA", path = "data/",force=T))
dem <- raster("data/wc2.1_10m_elev.tif")

#dem_slope <- starsExtra::slope(dem)
dem_slope <- raster::terrain(dem, opt="slope", unit="degrees", neighbors=8)

## bioclimate variable 
bio_clim <- raster::getData('worldclim', var='bio', res=10)
names(bio_clim) <- paste0("bio",c(1:19))


### ISRIC data download 
isric_url = "https://files.isric.org/soilgrids/latest/data_aggregated/" # isric webDAV data

# soil covariates variables
cov_varaible_name <- c("bdod", "cec",	"clay",	"nitrogen",	"ocd","phh2o","sand",	"silt",	"soc")
#cov_varaible_name <- c("phh2o","sand",	"silt",	"soc")
#voi = "bdod" # variable of interest
depth = "0-5cm"
quantile = "mean"
ress <- "1000"

#### download global soil data 
for (voi in cov_varaible_name){
  voi_url = paste(isric_url,ress,"m/",voi,"/",paste(voi,depth,quantile,ress,sep = "_"),".tif",sep = "") 
  download.file(url = voi_url, method = "curl",
                destfile = paste(out_dir, paste(voi,".tif",sep = ""),sep="" ))
  #soil_layer <- raster(voi_url)
  
}


### read Nigeria shapefile to mask the data
nig_shp <- st_read("data/gadm/gadm41_NGA_shp/gadm41_NGA_0.shp")
nig_shp <- rgdal::readOGR("data/gadm/gadm41_NGA_shp/gadm41_NGA_0.shp")
# get boundary extent Nigeria  
ext <- raster::extent(nig_shp) 

### prepare soil and bioclimate covariate data for Nigeria 
soil_cov <- raster::stack(paste(out_dir, paste(cov_varaible_name,".tif",sep = ""),sep="" ))
clim_cov <- raster::stack(paste("data/wc2/wc2.1_10m_bio_",c(1:19),".tif",sep = ""))

### make soil raster the same projection with climate raster
soil_cov_p <- projectRaster(soil_cov, clim_cov)

# scale slope the same resolution as climate and soil 
res(dem_slope) <- res(soil_cov_p)
res(clim_cov) <- res(clim_cov)

## crop both soil and climate data with NGA extent
nga_soil <- raster::mask(raster::crop(soil_cov_p, nig_shp), nig_shp)
#make the soil to standared unit based using the isric correction factor 
nga_soil <- nga_soil/10
nga_clim <- raster::mask(raster::crop(clim_cov, nig_shp), nig_shp)
nga_slope <- raster::mask(raster::crop(dem_slope, nig_shp), nig_shp)
names(nga_clim) <- paste0("BIO",c(1:19))

#stack all spatial variables 
nga_cov <- stack(nga_slope, nga_soil, nga_clim)
names(nga_cov)
writeRaster(x = nga_cov, filename = "data/Nigeria/covariates/nga_cov_all.tif",
            format="GTiff",bylayer=TRUE)

writeRaster(x = nga_cov, 
            filename = paste0(out_cov,names(nga_cov)),
            format="GTiff", bylayer=TRUE)


# global GLDAS Soil Texture
# https://ldas.gsfc.nasa.gov/gldas/soils
# This data uses the FAO 16-category soil texture class 

soil_txture_class <- raster("~/Downloads/GLDASp5_soiltexture_025d.nc4")

coordinates(selected_data) <- c("longitude","latitude")
soilclass = raster::extract(soil_txture_class,selected_data, convert = T,df=T)
names(soilclass) <- c("ID", "soilID")

soil_class_map <- data_frame(soilID=c(1:16), soil_type =c("Sand", "Loamy Sand", "Sandy Loam", "Silt Loam", "Silt", "Loam", "Sandy Clay Loam", 
                    "Silty Clay Loam", "Clay Loam", "Sandy Clay", "Silty Clay", "Clay", 
                    "Organic Materials", "Water", "Bedrock", "Other"))
# Join the extracted values with their descriptions
mapped_soil_df <- soilclass %>%
  left_join(soil_class_map, by = c("soilID" = "soilID"))
