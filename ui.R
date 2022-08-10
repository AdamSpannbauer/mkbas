library(shiny)
library(DT)

ui <- fluidPage(
  DT::dataTableOutput("leaderboard_dt")
)
