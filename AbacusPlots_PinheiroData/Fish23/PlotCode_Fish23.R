#######################################################################
#######################################################################
################ Investigation of Fish # 23 ###########################
#######################################################################

### Upload Total LT data
LTData = read.csv("C:/Users/mttft/Desktop/Dissertation/Telemetry/ReceiverDownloads/2013-2017/Lake Trout/CATOS.2013-2017.Numbered.Filtered.Merged.csv")
Fish23 = subset(LTData, LTData$Number == 23)
min(Fish23$detection_timestamp_utc)
max(Fish23$detection_timestamp_utc)

Fish23.2015 = subset(Fish23, Fish23$detection_timestamp_utc <= as.POSIXct("2015-11-01") & Fish23$detection_timestamp_utc > as.POSIXct("2014-11-01"))
Fish23.2016 = subset(Fish23, Fish23$detection_timestamp_utc < as.POSIXct("2016-11-01") & Fish23$detection_timestamp_utc > as.POSIXct("2015-11-01"))
Fish23.2017 = subset(Fish23, Fish23$detection_timestamp_utc < as.POSIXct("2017-11-01") & Fish23$detection_timestamp_utc > as.POSIXct("2016-11-01"))


abacus_plot(Fish23.2015[Fish23.2015$Number == 23,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish23/23_2015.png")

abacus_plot(Fish23.2016[Fish23.2016$Number == 23,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish23/23_2016.png")
abacus_plot(Fish23.2017[Fish23.2017$Number == 23,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish23/23_2017.png")

