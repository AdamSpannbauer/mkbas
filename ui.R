library(shiny)
library(DT)

ui <- fluidPage(
  tags$head(
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "style.css"
    )
  ),
  DT::dataTableOutput("leaderboard_dt")
)
