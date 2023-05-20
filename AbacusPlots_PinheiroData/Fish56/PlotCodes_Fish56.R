#######################################################################
#######################################################################
################ Investigation of Fish # 56 ###########################
#######################################################################

### Upload Total LT data
LTData = read.csv("C:/Users/mttft/Desktop/Dissertation/Telemetry/ReceiverDownloads/2013-2017/CATOS.2013-2017.Numbered.Filtered.Merged.csv")
Fish56 = subset(LTData, LTData$Number == 56)
min(Fish56$detection_timestamp_utc)
max(Fish56$detection_timestamp_utc)

Fish56.2014 = subset(Fish56, Fish56$detection_timestamp_utc <= as.POSIXct("2014-11-01"))
Fish56.2015 = subset(Fish56, Fish56$detection_timestamp_utc <= as.POSIXct("2015-11-01") & Fish56$detection_timestamp_utc > as.POSIXct("2014-11-01"))
Fish56.2016 = subset(Fish56, Fish56$detection_timestamp_utc < as.POSIXct("2016-11-01") & Fish56$detection_timestamp_utc > as.POSIXct("2015-11-01"))
Fish56.2017 = subset(Fish56, Fish56$detection_timestamp_utc < as.POSIXct("2017-11-01") & Fish56$detection_timestamp_utc > as.POSIXct("2016-11-01"))

abacus_plot(Fish56.2015[Fish56.2015$Number == 56,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish56/56_2015.png")

abacus_plot(Fish56.2016[Fish56.2016$Number == 56,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish56/56_2016.png")

abacus_plot(Fish56.2017[Fish56.2017$Number == 56,],
            location_col = "receiver.location",
            locations = Rec,
            out_file = "C:/Users/mttft/Desktop/Dissertation/Telemetry/Abacus_Plots/Fish56/56_2017.png")

#####Code below copied from fish 92 file
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
