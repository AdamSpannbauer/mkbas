library(shiny)
library(shinydashboard)
library(DT)
library(shinycssloaders)
# library(shinyjs)
library(shinyWidgets)
library(plotly)

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
      id = "sidebar",
      menuItem(
        text = "Leaderboard",
        tabName = "leaderboard",
        icon = icon("flag-checkered")
      ),
      menuItem(
        text = "Distributions",
        tabName = "dists",
        icon = icon("chart-area")
      ),
      menuItem(
        text = "Major Comparison",
        tabName = "analysis",
        icon = icon("chart-bar")
      ),
      shiny::conditionalPanel(
        condition = "input.sidebar === 'analysis' || input.sidebar === 'dists'",
        div(
          align = "center",
          hr(),
          prettySwitch(
            inputId = "use_minutes",
            value = TRUE,
            label = "Use minutes",
            status = "success",
            fill = TRUE
          )
        )
      ),
      div(
        id = "ba-interest",
        align = "center",
        br(), "Join the BAS Society Discord!", br(), br(),
        img(
          src = "bas-discord-qr-code.png",
          width = "80%"
        ), br(), br()
      )
    ) # sidebarMenu
  ), # dashboardSidebar
  dashboardBody(
    # useShinyjs(),
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
              width = 5,
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
          background = "black",
          withSpinner(
            plotlyOutput("year_comparison_plot"),
            type = 3,
            color = "white",
            color.background = RED
          ) # withSpinner
        ),
        box(
          background = "black",
          withSpinner(
            DT::dataTableOutput("major_comparison_plot"),
            type = 3,
            color = "white",
            color.background = RED
          ) # withSpinner
        )
      ), # tabItem
      tabItem(
        tabName = "dists",
        column(
          width = 12, align = "center",
          box(
            background = "black",
            plotOutput("overall_disthist")
          ),
          box(
            background = "black",
            plotOutput("overall_distdens")
          ),
          box(
            background = "black",
            plotOutput("overall_distbox")
          )
        )
      ),
      tabItem(
        tabName = "analysis",
        box(
          background = "black",
          width = 6,
          plotOutput("major_times_chart")
        ),
        box(
          background = "black",
          width = 6,
          plotOutput("major_count_chart")
        )
      ) # tabItem
    ) # tabItems
  ) # dashboardBody
) # dashboardPage
