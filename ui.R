library(shiny)
library(ggplot2)
liftData <- read.csv("liftdata.csv", header=TRUE)

fluidPage(
  fluidRow(
    h2("Fish Ticket Explorer"),
    column(3,h4("Time Filters"),
           sliderInput('year','Year Landed',min = min(liftData$YearLanded), max = max(liftData$YearLanded), value = c(min(liftData$YearLanded),max(liftData$YearLanded)),step = 1, sep ="" )),
    column(3,h4("Species Filters"),
           selectInput('mgrp', 'Management Group', levels(factor(liftData$MGRP)), multiple = TRUE, selectize= TRUE)),
    column(3,h4("Area Filters")),
    column(3,h4("Gear Filters")),
    dataTableOutput('liftTable')
  )
)
