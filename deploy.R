library(shinyapps)
library(RODBC)
library(shiny)
library(scales)
shinyapps::setAccountInfo(name='weyland',
                          token='EE0C1E69AA303117FE3164CC41591030',
                          secret='Ip57DB6UsJYuWtSMv6zk6VVNSedtUmDfEy6bcM6F')
setwd("C:/Users/Phillip/Documents/R Projects/ShinyApps/MFS")
liftCxn <- odbcDriverConnect('driver=SQL Server;server=busprod.dfw.wa.lcl\\busprod;database=lift2000;trusted_connection=true')
PhilsLiFtCxn <- odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=//ssv.wa.lcl/dfw files/FP/FishMgmt/Weyland/WeylandToKari/LiFT.accdb")  
liftData<-  sqlQuery(liftCxn,   'SELECT  Batch_Year as [YearLanded], s.Species_Code as [MarketCode], species_code_desc as [MarketName], g.gear_code as [GearCode], g.gear_desc as [GearName], ca.Catch_Area_Code as [CatchAreaCode], ca.Catch_area_desc as [CatchAreaName],  Port_Code as [PortCode], Fisher_Type_Code,  Ticket_Data_Source_Code, sum(Rptd_Price_Amt*Rptd_Lbs_Qty) as [SaleAmount], sum(Rptd_Lbs_Qty) as [ReportedPounds], sum(round_lbs_qty) as [RoundPounds]  
                     FROM FISH_TICKET  ft
                     INNER JOIN fish_ticket_detail ftd
                     ON ftd.fish_ticket_id = ft.fish_ticket_id
                     INNER JOIN species_lut s 
                     on s.species_code = ftd.species_code
                     LEFT JOIN gear_lut g
                     on ftd.gear_code = g.gear_code
                     LEFT JOIN catch_area_lut ca
                     on ftd.catch_area_code = ca.catch_area_code
                     
                     GROUP BY Batch_Year, s.Species_Code, species_code_desc, g.gear_code, g.gear_desc, ca.Catch_Area_Code, ca.Catch_area_desc,  Port_Code, Fisher_Type_Code,  Ticket_Data_Source_Code'
)
area <- sqlQuery(PhilsLiFtCxn, 'SELECT Catch_Area_Code, CatchAreaBodyOfWater from LiFT_CatchArea') 
market <- sqlQuery(PhilsLiFtCxn, 'SELECT LiFT_MarketCode, MGRP from LiFT_PacFIN_Market') 
port <- sqlQuery(PhilsLiFtCxn, 'SELECT LiFT_PortCode, PortBodyOfWater from LiFT_PacFINPort') 
liftData <- merge(liftData,area, by.x = "CatchAreaCode", by.y = "Catch_Area_Code", all.x = TRUE)
liftData <- merge(liftData,market, by.x = "MarketCode", by.y = "LiFT_MarketCode", all.x = TRUE)
liftData <- merge(liftData,port, by.x = "PortCode", by.y = "LiFT_PortCode", all.x = TRUE)
liftData$SaleAmount <- scales::dollar(liftData$SaleAmount)
liftData<-liftData[c("YearLanded", "PortCode", "PortBodyOfWater", "MarketCode", "MarketName" , "MGRP"   ,"CatchAreaCode", 
           "CatchAreaName", "CatchAreaBodyOfWater" , "GearCode", "GearName",  "Fisher_Type_Code" , 
           "Ticket_Data_Source_Code", "SaleAmount" , "ReportedPounds" ,  "RoundPounds")]
write.csv(liftData, file = "liftdata.csv", row.names=FALSE)
shinyapps::setAccountInfo(name='wdfw', token='C36065A8B904A2461716CC5A8869263F', secret='1AKUrO8TO4WueOPp4hmmGDxL0ixDkBYGkgrgETZB')
deployApp("C:/Users/Phillip/Documents/R Projects/ShinyApps/MFS", account = "wdfw", appName = "MFSReporting")

