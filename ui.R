library(DT)
library(shiny)
library(ggplot2)
liftData <- read.csv("liftdata.csv")

navbarPage("Marine Fish Science Data Dashboard",
  tabPanel("Home"),
  navbarMenu("Fish Ticket",
    tabPanel("Data Explorer",
              fluidRow(
                column(3,
                       sliderInput('year', 'Year Landed', min = min(liftData$YearLanded), max = max(liftData$YearLanded), value= c(max(liftData$YearLanded)-5,max(liftData$YearLanded) ), sep="", step = 1)
                ),
                column(3,
                selectInput('mgrp', 'Management Group', levels(factor(liftData$MGRP)), multiple = TRUE))),
              tabsetPanel(
                tabPanel("Data", 
                  fluidRow( p(class = 'text-left', downloadButton('x3', 'Download Filtered Fish Ticket Data')),
                            
                  DT::dataTableOutput('liftTable'))),
                tabPanel("Plot",
                         plotOutput('ftPlot'))
              )
              
    )
  )
)