library(shiny)
library(shinyapps)
library(ggplot2)
function(input, output) {
 
  output$liftTable <- renderDataTable({
    liftData <- read.csv("liftdata.csv", header=TRUE)
    if(!is.null(input$mgrp)){
    liftData<- liftData[liftData$MGRP %in% input$mgrp,]
    }
    liftData<- liftData[liftData$YearLanded >= min(input$year) & liftData$YearLanded <= max(input$year),]
    liftData
    })
}
