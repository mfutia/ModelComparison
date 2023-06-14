#### ---
# Project: dynamic Brownian Bridge using 'move'
# Start Date: 2023-05-18
# Description: project description
# mhf
#### ---

###----------------------------------------------------------------------------------------------------
### Load packages
###----------------------------------------------------------------------------------------------------
library(sp)
library(sf)
library(move)
library(magrittr)
library(data.table)
library(tidyverse)
###----------------------------------------------------------------------------------------------------


###----------------------------------------------------------------------------------------------------
### Set path routes
###----------------------------------------------------------------------------------------------------
path.drive <- "C:/Users/mttft/OneDrive - University of Vermont/"
path.root <- paste0(path.drive, "Dissertation_Final/Telemetry/")
path.mvt <- paste0(path.root, "ModelComparison/")
path.detect <- paste0(path.mvt, "MergedData_MC/")
path.sim <- paste0(path.mvt, "SimulatedData_MC/")
path.rec <- paste0(path.mvt, "RecLocs_MC/")
path.filt <- paste0(path.mvt, "FilteredTelemetryData_MC/")
path.shp <- paste0(path.drive,"ArcGIS Pro 2.2/Shapefiles/LakeChamplain/")
###----------------------------------------------------------------------------------------------------


###----------------------------------------------------------------------------------------------------
### Generate functions
###----------------------------------------------------------------------------------------------------

#### ---
# FUNCTION: %!in%
# description: negate based on values in a list
#### ---

`%!in%` <- Negate(`%in%`)

# end of %!in%
#### ---
###----------------------------------------------------------------------------------------------------


###----------------------------------------------------------------------------------------------------
### Load data
###----------------------------------------------------------------------------------------------------
### Lake data
setwd(paste(path.shp, "ChamplainOutline/",sep = ""))
lc_outline <- st_read(dsn = ".",
                      layer = "VT_Lake_Champlain_extracted_from_VHDCARTO__polygon")

st_crs(lc_outline) <- 4326

# load lake region polygon
setwd(paste0(path.shp, "ChamplainRegions/"))
lc_regions <- st_read(dsn = ".",layer = "ChamplainRegions")

lc_regions_short <- lc_regions %>% 
  mutate(regions = case_when(GNIS_NAME %in% c("Inland_Sea","Gut","NE_Channel") ~ "Northeast Arm",
                             GNIS_NAME %in% "Missisquoi" ~ "Missisquoi",
                             GNIS_NAME %in% "Main_North" ~ "Main Lake North",
                             GNIS_NAME %in% "Main_Central" ~ "Main Lake Central",
                             GNIS_NAME %in% "Main_South" ~ "Main Lake South",
                             GNIS_NAME %in% "Malletts" ~ "Malletts Bay",
                             GNIS_NAME %in% "South_Lake" ~ "South Lake")) %>% 
  group_by(regions) %>% 
  summarize(geometry = sf::st_union(geometry),
            Area_sqkm = sum(AREASQKM))



### Receiver data
recs <- readRDS(paste0(path.mvt,"OriginalReceiverSummary_2013-2017_May2023.rds"))

str(recs)
summary(recs)

# summarize receiver locations
recs_short <- recs %>% 
  group_by(StationName,regions) %>% 
  summarize(deploy_lon = mean(deploy_long), deploy_lat = mean(deploy_lat)) %>% 
  ungroup() %>% 
  mutate(regions = case_when(regions %in% c("Inland Sea","Gut","NE Channel") ~ "Northeast Arm",
                             regions %in% "Missisquoi" ~ "Missisquoi",
                             regions %in% "Main North" ~ "Main Lake North",
                             regions %in% "Main Central" ~ "Main Lake Central",
                             regions %in% "Main South" ~ "Main Lake South",
                             regions %in% "Malletts" ~ "Malletts Bay",
                             regions %in% "South Lake" ~ "South Lake"))

# convert to sf object
recs_sf <- st_as_sf(x = recs_short, coords = c('deploy_lon', 'deploy_lat'), crs = 4326)


### Simulation data
sim_dets <- readRDS(paste0(path.sim, "simulated_detections_June2023.rds"))
###----------------------------------------------------------------------------------------------------


###----------------------------------------------------------------------------------------------------
### Generate random walk paths
###----------------------------------------------------------------------------------------------------
### remove timestamps with duplicate occurrences
sim_dets_nodups <- sim_dets %>% 
  group_by(animal_id) %>% 
  arrange(detection_timestamp_utc) %>% 
  mutate(time_diff = c(NA,diff(detection_timestamp_utc))) %>% 
  filter(time_diff %!in% 0) %>% 
  mutate(animal_id = as.character(animal_id)) %>% 
  arrange(animal_id) %>% 
  ungroup()

str(sim_dets_nodups)

# reduce columns for move object
station_nums <- recs_short %>% 
  dplyr::select(StationName, deploy_lat) %>% 
  arrange(deploy_lat) %>% 
  mutate(station_id = 1:nrow(recs_short), # create 
         deploy_lat = NULL)

sim_dets_short <- sim_dets_nodups %>% 
  left_join(station_nums) %>% 
  mutate(animal_id = sub('.*_', '', animal_id),
         start_region = NULL,
         StationName = NULL) %>% 
  mutate(animal_id = as.numeric(animal_id))
  

test <- sim_dets_short %>% 
  filter(animal_id %in% animal_id[1])
  

### convert data to move object
test_move <- move(x = test$deploy_lon,
                  y = test$deploy_lat,
                  time = test$detection_timestamp_utc,
                  proj = CRS("+proj=longlat +ellps=WGS84"),
                  data = test,
                  animal = test$animal_id)

# sim_ids <- unique(sim_dets_nodups$animal_id)

sim_dets_move <- move(x = sim_dets_short$deploy_lon,
                      y = sim_dets_short$deploy_lat,
                      time = as.POSIXct(sim_dets_short$detection_timestamp_utc, tz = "UTC"),
                      proj = CRS("+proj=longlat +ellps=WGS84"),
                      animal = sim_dets_short$animal_id)
###----------------------------------------------------------------------------------------------------


###----------------------------------------------------------------------------------------------------
### Run dynamic brownian bridge function
###----------------------------------------------------------------------------------------------------
# create raster of lake outline
lc_raster <- raster(lc_outline)

# transform coordinates from long/lat projection
test_trans <- spTransform(test_move,
                          CRSobj="+proj=aeqd +ellps=WGS84")
lc_trans <- spTransform(lc_raster,
                        CRSobj="+proj=aeqd +ellps=WGS84")

# run dBBMM with test data
test_dBBMM <- brownian.bridge.dyn(object = test_trans,
                                  raster = lc_raster,
                                  location.error = 12, # taken from example
                                  ext = 0.3) # default

### Code from move vignette
data2 <- spTransform(leroy[30:90,], CRSobj="+proj=aeqd +ellps=WGS84", center=TRUE)
## create a DBBMM object
dbbmm <- brownian.bridge.dyn(object=data2, location.error=12, dimSize=125, ext=1.2,
                             time.step=2, margin=15)
###----------------------------------------------------------------------------------------------------

