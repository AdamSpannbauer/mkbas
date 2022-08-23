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
        rel = "shortcut icon",
        href = "favicon.png"
      ),
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
          width = 7,
          background = "black",
          withSpinner(
            DT::dataTableOutput("leaderboard_dt"),
            type = 3,
            color = "white",
            color.background = RED
          ) # withSpinner
        ), # box
        box(
          width = 5,
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
          ) # fluidRow
        ), # box
        box(
          width = 5,
          background = "black",
          fluidRow(
            column(
              width = 6,
              align = "center",
              br(), br(),
              img(
                src = "discord_qrcode.png",
                width = "70%"
              )
            ),
            column(
              width = 6,
              span(
                "Join the Stat Nation Discord",
                class = "maintitle"
              )
            )
          ) # fluidRow
        ) # box
      ), # tabItem
      tabItem(
        tabName = "analysis",
        box(
          background = "black",
          plotOutput("major_chart")
        ),
        box(
          background = "black",
          plotOutput("character_chart")
        ),
        box(
          background = "black",
          plotOutput("controller_chart")
        ),
        box(
          background = "black",
          plotOutput("car_chart")
        )
      ) # tabItem
    ) # tabItems
  ) # dashboardBody
) # dashboardPage
