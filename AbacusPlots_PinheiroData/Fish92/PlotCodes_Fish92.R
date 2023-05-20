#######################################################################
#######################################################################
################ Investigation of Fish # 92 ###########################
#######################################################################

### Upload Total LT data
LTData = read.csv("C:/Users/mttft/Desktop/Dissertation/Telemetry/ReceiverDownloads/2013-2017/CATOS.2013-2017.Numbered.Filtered.Merged.csv")
Fish92 = subset(LTData, LTData$Number == 92)
max(Fish92$detection_timestamp_utc)

Fish92.2014 = subset(Fish92, Fish92$detection_timestamp_utc <= as.POSIXct("2014-11-01"))
Fish92.2015 = subset(Fish92, Fish92$detection_timestamp_utc <= as.POSIXct("2015-11-01") & Fish92$detection_timestamp_utc > as.POSIXct("2014-11-01"))
Fish92.2016 = subset(Fish92, Fish92$detection_timestamp_utc < as.POSIXct("2016-11-01") & Fish92$detection_timestamp_utc > as.POSIXct("2015-11-01"))
Fish92.2017 = subset(Fish92, Fish92$detection_timestamp_utc < as.POSIXct("2017-11-01") & Fish92$detection_timestamp_utc > as.POSIXct("2016-11-01"))

abacus_plot(Fish92.2014[Fish92.2014$Number == 92,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/92_2014.png")

abacus_plot(Fish92.2015[Fish92.2015$Number == 92,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/92_2015.png")

abacus_plot(Fish92.2016[Fish92.2016$Number == 92,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/92_2016.png")

Fish92.WinSpr.2014 = subset(Fish92, Fish92$detection_timestamp_utc <= as.POSIXct("2014-7-15") & Fish92$detection_timestamp_utc >= as.POSIXct("2013-12-31"))
Fish92.Spring.2015 = subset(Fish92, Fish92$detection_timestamp_utc <= as.POSIXct("2015-7-15") & Fish92$detection_timestamp_utc >= as.POSIXct("2015-3-15"))
Fish92.Win.2014 = subset(Fish92, Fish92$detection_timestamp_utc <= as.POSIXct("2014-2-15") & Fish92$detection_timestamp_utc >= as.POSIXct("2014-1-15"))
Fish92.Spr.2014 = subset(Fish92, Fish92$detection_timestamp_utc <= as.POSIXct("2014-6-15") & Fish92$detection_timestamp_utc >= as.POSIXct("2014-4-1"))


abacus_plot(Fish92.WinSpr.2014[Fish92.WinSpr.2014$Number == 92,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/92_WntSpg.2014.png")
abacus_plot(Fish92.Spring.2015[Fish92.Spring.2015$Number == 92,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/92_Spring.2015.png")
abacus_plot(Fish92.Win.2014[Fish92.Win.2014$Number == 92,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/92_Winter.2014.png")
abacus_plot(Fish92.Spr.2014[Fish92.Spr.2014$Number == 92,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish92/92_Spring.2014.png")
