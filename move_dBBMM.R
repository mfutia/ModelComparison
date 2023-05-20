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
### Load data
###----------------------------------------------------------------------------------------------------
### Lake data
setwd(paste(path.shp, "ChamplainOutline/",sep = ""))
lc_outline <- st_read(dsn = ".",
                      layer = "VT_Lake_Champlain_extracted_from_VHDCARTO__polygon")

champ <- st_as_sf(lc_outline)
st_crs(champ) <- 4326

# load lake region polygon
setwd(paste0(path.shp, "ChamplainRegions/"))
lc_regions <- st_read(dsn = ".",layer = "ChamplainRegions")



### Receiver data
recs <- readRDS(paste0(path.mvt,"OriginalReceiverSummary_2013-2017_May2023.rds"))

str(recs)
summary(recs)


# recs <- readRDS(paste0(path.rec,"TotalReceiverSummary_2013-2020_1.rds"))
# 
# str(recs)
# 
# # create new column for region
# recs_og <- recs %>% 
#   mutate(regions = case_when(StationName %in% "Crown Point" ~ "South Lake",
#                              deploy_lat > 44.10 & deploy_lat < 44.40 & Tributary %in% "Main Lake" ~ "Main Lake South",
#                              deploy_lat > 44.40 & deploy_lat < 44.56 & Tributary %in% "Main Lake" ~ "Main Lake Central",
#                              deploy_lat > 44.56 & Tributary %in% "Main Lake" ~ "Main Lake North",
#                              Tributary %!in% "Main Lake" ~ Tributary,
#                              TRUE ~ "regions")) %>% 
#   filter(deploy_date_time <= "2018-01-01" &
#            StationName %!in% c("BurlingtonBay_RangeTest","SandBarInlandSea_RangeTest")) %>% 
#   mutate(regions = factor(regions),
#          StationName = factor(StationName),
#          deploy_long = abs(deploy_long)*(-1),
#          Tributary = NULL) %>% 
#   mutate(regions = as.character(regions)) %>% 
#   mutate(regions_short = case_when(regions %in% c("Carry Bay","Missisquoi") ~ "NE Channel",
#                                    regions %in% "Northwest Arm" ~ "Main Lake North",
#                                    regions %!in% c("Carry Bay","Missisquoi","Northwest Arm") ~ regions,
#                                    TRUE ~ "regions_short")) %>% 
#   mutate(regions = factor(regions),
#          regions_short = factor(regions_short,
#                                 levels = c('NE Channel','Gut','Inland Sea','Main Lake North','Main Lake Central','Main Lake South','Malletts', 'South Lake'),
#                                 labels = c('NE Channel','Gut','Inland Sea','Main North','Main Central','Main South','Malletts', 'South Lake')))
# 
# 
# # Corrections to recs file
# recs_og$recover_date_time[recs_og$StationName %in% "Gut" & recs_og$recover_date_time == "2017-05-05"] <- "2017-06-23" # change recover time due to later detection and unknown recover date in catos log
# recs_og$deploy_date_time[recs_og$StationName %in% "Gordon" & recs_og$deploy_date_time == "2017-07-26"] <- "2016-11-02" # change deploy date due to prior failed retrieval


# summarize receiver locations
recs_short <- recs %>% 
  group_by(StationName,regions) %>% 
  summarize(deploy_lon = mean(deploy_long), deploy_lat = mean(deploy_lat)) %>% 
  ungroup()


# convert to sp object
recs_sf <- st_as_sf(x = recs_short, coords = c('deploy_lon', 'deploy_lat'), crs = 4326)


### Simulation data
sim_dets <- readRDS(paste0(path.sim, "simulated_detections_Apr2023.rds"))
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
  ungroup()

str(sim_dets_nodups)

test <- sim_dets_nodups %>% 
  filter(animal_id %in% animal_id[1])
  

### convert data to move object
test_move <- move(x = test$deploy_lon,
       y = test$deploy_lat,
       time = test$detection_timestamp_utc,
       proj = CRS("+proj=longlat +ellps=WGS84"),
       data = test,
       animal = test$animal_id)

sim_ids <- unique(sim_dets_nodups$animal_id)

lkt_move <- move(x = sim_dets_nodups$deploy_lon,
                 y = sim_dets_nodups$deploy_lat,
                 time = sim_dets_nodups$detection_timestamp_utc,
                 proj = CRS("+proj=longlat +ellps=WGS84"),
                 data = sim_dets_nodups,
                 animal = sim_ids)

###----------------------------------------------------------------------------------------------------
