#######################################################################
#######################################################################
################ Investigation of Fish # 60 ###########################
#######################################################################

### Upload Total LT data
LTData = read.csv("C:/Users/mttft/Desktop/Dissertation/Telemetry/ReceiverDownloads/2013-2017/CATOS.2013-2017.Numbered.Filtered.Merged.csv")
Fish60 = subset(LTData, LTData$Number == 60)
min(Fish60$detection_timestamp_utc)
max(Fish60$detection_timestamp_utc)

Fish60.2015 = subset(Fish60, Fish60$detection_timestamp_utc <= as.POSIXct("2015-11-01") & Fish60$detection_timestamp_utc > as.POSIXct("2014-11-01"))
Fish60.2016 = subset(Fish60, Fish60$detection_timestamp_utc < as.POSIXct("2016-11-01") & Fish60$detection_timestamp_utc > as.POSIXct("2015-11-01"))
Fish60.2017 = subset(Fish60, Fish60$detection_timestamp_utc < as.POSIXct("2017-11-01") & Fish60$detection_timestamp_utc > as.POSIXct("2016-11-01"))

abacus_plot(Fish60.2015[Fish60.2015$Number == 60,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish60/60_2015.png")

abacus_plot(Fish60.2016[Fish60.2016$Number == 60,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish60/60_2016.png")

abacus_plot(Fish60.2017[Fish60.2017$Number == 60,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish60/60_2017.png")
