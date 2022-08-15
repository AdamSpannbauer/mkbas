library(shiny)
library(shinydashboard)
library(DT)
library(shinycssloaders)
library(shinyjs)

ui <- dashboardPage(
  title = "BAS MK8",
  skin = "red",
  dashboardHeader(
    title = span(
      "BAS MK8",
      style = "font-family: goshaLight"
    )
  ), # dashboardHeader
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        text = "Leaderboard",
        tabName = "leaderboard",
        icon = icon("flag-checkered")
      ),
      menuItem(
        text = "Analysis",
        tabName = "analysis",
        icon = icon("chart-bar")
      )
    ) # sidebarMenu
  ), # dashboardSidebar
  dashboardBody(
    useShinyjs(),
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "style.css"
      )
    ),
    tabItems(
      tabItem(
        tabName = "leaderboard",
        box(
          background = "black",
          withSpinner(
            DT::dataTableOutput("leaderboard_dt"),
            type = 3,
            color = "white",
            color.background = RED
          )
        ),
        box(
          align = "right",
          background = "black",
          fluidRow(
            column(
              width = 6,
              span(
                "Business Analytics Society",
                class = "maintitle"
              )
            ),
            column(
              width = 6,
              img(
                # style = "position: relative",
                class = "gif",
                width = "100%",
                src = "mkspin.gif"
              )
            )
          )
        )
      ),
      tabItem(
        tabName = "analysis",
        box(
          background = "black",
          plotOutput("controller_chart")
        ),
        box(
          background = "black",
          plotOutput("character_chart")
        ),
      )
    ) # tabItems
  ) # dashboardBody
) # dashboardPage
