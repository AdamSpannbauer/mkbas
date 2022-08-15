library(shiny)
library(DT)
library(plotly)
library(ggplot2)
library(shinyjs)

server <- function(input, output, session) {
  runjs("toggleCodePosition();")

  google_sheets_df <- reactivePoll(
    intervalMillis = GOOGLE_SHEETS_POLL_SECS * 1000,
    session = session,
    checkFunc = read_sheets_df,
    valueFunc = read_sheets_df
  ) # reactivePoll

  leaderboard_df <- reactive({
    display_cols <- c("name", "major", "time")
    display_col_names <- c("Name", "Major", "Time")

    # min time per name + major
    leaderboard_df <- aggregate(
      seconds ~ name + major,
      data = google_sheets_df(),
      FUN = min
    )

    # Get back demo info and sort
    leaderboard_df <- merge(
      leaderboard_df,
      google_sheets_df(),
      by = c("name", "major", "seconds")
    )
    leaderboard_df <- leaderboard_df[order(leaderboard_df$seconds), ]

    # Pretty up
    leaderboard_df <- leaderboard_df[, display_cols]
    names(leaderboard_df) <- display_col_names
    rownames(leaderboard_df) <- NULL

    leaderboard_df
  })

  output$leaderboard_dt <- DT::renderDataTable(
    leaderboard_df(),
    options = list(
      iDisplayLength = 10,
      bLengthChange = 0
    )
  ) # renderDataTable

  output$controller_chart <- renderPlot({
    summary_df <- aggregate(
      seconds ~ controller,
      data = google_sheets_df(),
      FUN = mean_and_se
    )
    summary_df <- do.call(data.frame, summary_df)
    summary_df <- summary_df[order(summary_df$seconds.mean), ]
    summary_df$controller <- factor(summary_df$controller, levels = summary_df$controller)

    p <- ggplot(summary_df, aes(controller, seconds.mean)) +
      geom_bar(stat = "identity", fill = RED) +
      geom_errorbar(
        aes(
          ymin = seconds.mean - seconds.se,
          ymax = seconds.mean + seconds.se
        ),
        color = "white",
        width = .2
      ) +
      labs(x = "Controller", y = "Seconds", title = "Which controller is fastest??") +
      theme_mk()

    p
  })

  output$character_chart <- renderPlot({
    summary_df <- aggregate(
      seconds ~ character,
      data = google_sheets_df(),
      FUN = mean_and_se
    )
    summary_df <- do.call(data.frame, summary_df)
    summary_df <- summary_df[order(summary_df$seconds.mean), ]
    summary_df$character <- factor(summary_df$character, levels = summary_df$character)

    p <- ggplot(summary_df, aes(character, seconds.mean)) +
      geom_bar(stat = "identity", fill = RED) +
      geom_errorbar(
        aes(
          ymin = seconds.mean - seconds.se,
          ymax = seconds.mean + seconds.se
        ),
        color = "white",
        width = .2
      ) +
      labs(x = "Character", y = "Seconds", title = "Which character is fastest??") +
      theme_mk()

    p
  })
}
