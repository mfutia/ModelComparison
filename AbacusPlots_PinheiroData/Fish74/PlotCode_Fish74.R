#######################################################################
#######################################################################
################ Investigation of Fish # 74 ###########################
#######################################################################

### Upload Total LT data
LTData = read.csv("C:/Users/mttft/Desktop/Dissertation/Telemetry/ReceiverDownloads/2013-2017/CATOS.2013-2017.Numbered.Filtered.Merged.csv")
Fish74 = subset(LTData, LTData$Number == 74)
min(Fish74$detection_timestamp_utc)
max(Fish74$detection_timestamp_utc)

Fish74.2014 = subset(Fish74, Fish74$detection_timestamp_utc <= as.POSIXct("2014-11-01"))
Fish74.2015 = subset(Fish74, Fish74$detection_timestamp_utc <= as.POSIXct("2015-11-01") & Fish74$detection_timestamp_utc > as.POSIXct("2014-11-01"))
Fish74.2016 = subset(Fish74, Fish74$detection_timestamp_utc < as.POSIXct("2016-11-01") & Fish74$detection_timestamp_utc > as.POSIXct("2015-11-01"))

abacus_plot(Fish74.2014[Fish74.2014$Number == 74,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish74/74_2014.png")

abacus_plot(Fish74.2015[Fish74.2015$Number == 74,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish74/74_2015.png")

abacus_plot(Fish74.2016[Fish74.2016$Number == 74,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish74/74_2016.png")
