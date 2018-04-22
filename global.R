
# This is the user-interface definition of a Shiny web application.
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
library(shinythemes)
# library(ggplot2)
# library(data.table)


data <- read.csv("/Users/jiemin/Desktop/G32693115/Crime_Incidents_in_2017.csv",header = T)
 
count_crime <- data %>% group_by(OFFENSE) %>% summarise(count = n())
count_shift <- data %>%  group_by(SHIFT) %>% summarise(count = n()) 
count_district <- data %>% group_by(DISTRICT) %>% summarise(count = n())
choice <- unique(as.character(count_crime$OFFENSE))
choice2 <- unique(as.character(count_shift$SHIFT))

crimes<- data %>% group_by(SHIFT,OFFENSE) %>% summarise(count = n())
crimes_shift<- data %>% group_by(SHIFT,OFFENSE) %>% summarise(count = n())
choices<-levels(crimes$SHIFT)
