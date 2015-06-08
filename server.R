library(DT)
library(shiny)
library(shinyapps)
library(ggplot2)
library(ggmap)
library(scales)
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
}
