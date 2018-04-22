
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(jpeg)
library(shiny)
library(shinythemes)
# library(ggplot2)
# library(data.table)
library(leaflet)
# library(googleVis)
# library(tidyverse)
library(shinydashboard)
# library(googleVis)
library(dplyr)
library(htmltools)
library(htmlwidgets)
library(rcdimple)
library(highcharter)

ui<-dashboardPage(
  skin = "red",
  dashboardHeader(title = "DC Crime in 2017",titleWidth = 500),
    dashboardSidebar(
        sidebarMenu(
          menuItem("Crime Plots",icon = icon("flag"),
                   menuSubItem("Crime Count Shift",tabName = "crime_day"),
                   menuSubItem("Crimes Shift Total",tabName = "crime_shift"),
                   menuSubItem("Crime Type",tabName = "crime_type"),
                   # menuSubItem("Crime by method&crime",tabName = "crime_method"),
                   menuSubItem("Crime District",tabName = "district")),
                   # menuSubItem("District",tabName = "district")),
          menuItem("Crime Shift Analysis",tabName = "crime_shift_day",icon = icon("star")),
          menuItem("Map",tabName = "map", badgeLabel = "DC Crime", badgeColor = "green",icon = icon("globe")),
          menuItem("Info",tabName = "info", icon = icon("info"))
    )
  ),
  dashboardBody(
    
    tabItems(
      
  

      tabItem(tabName = "crime_day",
              fluidRow(
                box(selectizeInput("Day","Select Time", 
                                   c(choices), 
                                   selected = 'DAY')),
                column(7,
                       br(),
                       highchartOutput("plot",height = "500px"))
                
                )),
      tabItem(tabName = "crime_shift",
              h2("Crime Shift"),
              fluidRow(
                
                plotOutput("plotshift")
              )),
      tabItem(tabName = "crime_shift_day",
              h2("Crime Type by Time"),
              fluidRow(
                 box(selectizeInput("Time","Select Time", 
                                    c(choices), 
                                    selected = 'DAY')),
                plotOutput("plotshiftday")
                
              )),
      tabItem(tabName = "crime_type",
              h2("Crime Type"),
              fluidRow(
                                 
                plotOutput("plotcrime")
              )),
      tabItem(tabName = "district",
              h2("Crime District"),
              fluidRow(
                
                plotOutput("plotdistrict"),
                br(),
                fluidRow(img(src="/Users/districtmap.jpg"))
               
              )),
     
      tabItem(tabName = "info",
              h4("Source:DC Open Data"),
              h4("Newest Data Record Date: 2017/12/13"),
              
              h4("Author: MIN JIE"),
              h4("Email: jiem@gwu.edu")),
      tabItem(tabName = "map",
              h2("Mapping"),
              selectizeInput("type","Select Crime Type",
                             c(ALL = "ALL",choice)),
              leafletOutput("total",width = 500,height = 500))
     
    )
  )
)