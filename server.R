library(DT)
library(shiny)
library(shinyapps)
library(ggplot2)
library(scales)
library(leaflet)
library(htmltools)
function(input, output) {
  output$liftTable <- DT::renderDataTable({
    
    liftData <- read.csv("liftdata.csv")
    if(!is.null(input$mgrp)){
      liftData <- liftData[liftData$MGRP %in% input$mgrp,]
    }
    
    liftData <- liftData[liftData$YearLanded<=max(input$year) & liftData$YearLanded>=min(input$year),]
    
    DT::datatable(liftData, options = list(
      dom = 'T<"clear">lfrtip'
      ))
  }
  )
  output$x3 = downloadHandler('liftExport.csv', content = function(file) {
    if(!is.null(input$mgrp)){
      liftData <- liftData[liftData$MGRP %in% input$mgrp,]
    }
    liftData <- liftData[liftData$YearLanded<=max(input$year) & liftData$YearLanded>=min(input$year),]
    write.csv(liftData, file)
  })
  output$ftPlot = renderPlot({
    liftData <- read.csv("liftdata.csv")
    if(!is.null(input$mgrp)){
      liftData <- liftData[liftData$MGRP %in% input$mgrp,]
    }
    liftData <- liftData[liftData$YearLanded<=max(input$year) & liftData$YearLanded>=min(input$year),]
    ggplot(liftData, aes(x=MGRP, y=RoundPounds, fill=MGRP)) + geom_bar(stat="identity") + scale_y_continuous(labels = comma) + theme(axis.text.x = element_text(angle = 90, vjust = .5))
  }
  )
  output$tagmapPlot <- renderLeaflet({
   tag <- read.csv("WA_Tag_Recap_data3.csv")
   leaflet(tag) %>%
   addTiles() %>%
     
     addCircleMarkers(
       clusterOptions = markerClusterOptions()
     )
  })
  output$ESAmap <- renderLeaflet({
    tag <- read.csv("WA_Tag_Recap_data3.csv")
    leaflet(tag) %>%
      addProviderTiles("Acetate.terrain") %>%
      addCircles( lng=-122.822570, lat=47.305177, radius = 1, popup = "<strong>Date: </strong>5/21/2015<br><strong>Project: </strong>ROV<br><strong>Length: </strong>45<br><img src = 'http://www.nmfs.noaa.gov/pr/images/fish/yelloweyerockfish_adfg.jpg'>" ) %>%
      addCircles( lng=-122.822570, lat=48.305177, radius = 1, popup = "<strong>Date: </strong>5/1/2015<br><strong>Project: </strong>ROV<br><strong>Length: </strong>40<br><iframe width='480' height='270' src='https://www.youtube.com/embed/0zy6ouqWJ9I' frameborder='0' allowfullscreen></iframe>" )
    
      
  })
}
