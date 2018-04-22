
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(shiny)
library(shinythemes)
library(ggplot2)
library(data.table)
library(leaflet)
library(googleVis)
library(tidyverse)
library(shinydashboard)
library(dplyr)
 library(htmltools)
library(htmlwidgets)

shinyServer(function(input, output) {

  reactthis <- reactive({
   df<- crimes %>%
      filter(SHIFT == input$Day)
  })
  output$plot <- renderHighchart({
    df <- reactthis()[order(reactthis()$count),]

    hc <- highchart() %>%
      hc_title(text = paste0("CRIMES IN ",input$Day)) %>%
      hc_subtitle(text = "January - December 2017") %>%
      hc_xAxis(categories = df$OFFENSE) %>%
      hc_add_series(name = "Number of crimes", data = df$count, type = "bar", showInLegend = FALSE) %>%
      hc_yAxis(title = list(text = "")) %>%
      hc_credits(enabled = TRUE, text = "opendata.dc.gov",
                 href = "http://opendata.dc.gov/",
                 style = list(fontSize = "13px")) %>%
      hc_exporting(enabled = TRUE)
    hc %>% hc_add_theme(hc_theme_sandsignika())
  })
  
  reactthis <- reactive({
    crimes_shift %>%
      filter(SHIFT == input$Time)
  })
  output$plotshiftday <- renderPlot({
      ggplot(data = reactthis(), aes(x = OFFENSE, y = count, fill = OFFENSE)) +
      geom_bar(stat = 'identity') +
      guides(fill = F) +
      labs(x = 'OFFENSE', y = 'Total Number of Crimes', title = 'Total Number of Crimes per Shift')
  })
     
  
  output$plotshift <- renderPlot({
      ggplot(data = count_shift, aes(x = SHIFT, y = count, fill = SHIFT)) +
      geom_bar(stat = 'identity') +
      guides(fill = F) +
      labs(x = 'Shift', y = 'Total Number of Crimes', title = 'Total Number of Crimes per Shift')
    })
    
  output$plotcrime <- renderPlot({
      ggplot(count_crime, aes(x = OFFENSE, y = count, fill = OFFENSE)) + 
      geom_bar(stat = 'identity') +  
      theme(axis.title.x=element_blank(),
              axis.text.x=element_blank(),
              axis.ticks.x=element_blank()) +
        labs(x = '', y = 'Total Number of Crimes', title = 'Total Count of Crimes per Category')
    })
    
  output$plotdistrict <- renderPlot({
        ggplot(count_district,aes(x = DISTRICT, y = count, fill = DISTRICT)) + 
        geom_bar(stat = 'identity') +
        guides(fill = F) +
        labs(x = 'District', y = 'Total Number of Crimes', title = 'Total Number of Crimes per District')
    })
    
  
  output$total <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(-76.99952,38.90192,zoom = 11)
  })

  observe({
    proxy <- leafletProxy("total") %>%
      clearMarkers() %>%
      clearMarkerClusters() %>%
      addCircleMarkers(data = data %>%
                         filter_(ifelse(input$type == "ALL",TRUE,"`OFFENSE` == input$type")),
                       clusterOptions = markerClusterOptions(),
                       ~LONGITUDE,~LATITUDE, popup="Washington DC",color = 'Red',radius = 1)
  })
})
