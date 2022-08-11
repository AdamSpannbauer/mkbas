library(shiny)
library(shinydashboard)
library(DT)


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
          DT::dataTableOutput("leaderboard_dt")
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
                width = "100%",
                src = "mkspin.gif"
              )
            )
          )
        )
      ),
      tabItem(
        tabName = "analysis",
        h2("Coming soon...")
      )
    ) # tabItems
  ) # dashboardBody
) # dashboardPage
