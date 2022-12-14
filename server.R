library(shiny)
library(DT)
library(plotly)
library(ggplot2)
library(shinyjs)

server <- function(input, output, session) {
  # runjs("toggleCodePosition();")

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

  time_units <- reactive({
    if (input$use_minutes) {
      list(col = "minutes", label = "Minutes", binwidth = 8 / 60)
    } else {
      list(col = "seconds", label = "Seconds", binwidth = 8)
    }
  })

  output$overall_disthist <- renderPlot({
    p <- ggplot(google_sheets_df(), aes_string(x = time_units()$col)) +
      geom_histogram(fill = RED, binwidth = time_units()$binwidth) +
      labs(
        title = "Distribution of all times",
        x = time_units()$label,
        y = "Count"
      ) +
      theme_mk()

    p
  })

  output$overall_distdens <- renderPlot({
    p <- ggplot(google_sheets_df(), aes_string(x = time_units()$col)) +
      geom_density(fill = RED) +
      labs(
        title = "Distribution of all times",
        x = time_units()$label,
        y = "Density"
      ) +
      theme_mk()

    p
  })

  output$overall_distbox <- renderPlot({
    p <- ggplot(google_sheets_df(), aes_string(x = time_units()$col)) +
      geom_boxplot(fill = RED, color = "white") +
      labs(
        title = "Distribution of all times",
        x = time_units()$label,
        y = "Density"
      ) +
      theme_mk()

    p
  })

  output$major_times_chart <- renderPlot({
    p <- mean_and_se_bar_plot(
      google_sheets_df(),
      x = "major", y = time_units()$col,
      reverse_sort = TRUE
    ) +
      labs(
        x = "Major",
        y = paste(time_units()$label, "(bigger bar is worse)"),
        title = "Which major is fastest??",
      ) +
      theme_mk() +
      coord_flip()

    p
  })

  output$major_count_chart <- renderPlot({
    times_df <- aggregate(
      seconds ~ major,
      google_sheets_df(),
      mean
    )
    times_df <- times_df[order(-times_df$seconds), ]

    plot_df <- aggregate(
      id ~ major,
      google_sheets_df(),
      length
    )
    names(plot_df)[2] <- "n"
    plot_df$major <- factor(plot_df$major, levels = times_df$major)
    plot_df <- plot_df[!is.na(plot_df$major), ]

    p <- ggplot(plot_df, aes(x = n, y = major)) +
      geom_col(fill = RED, stat = "identity") +
      labs(
        x = "Count",
        y = "",
        title = "Players per major"
      ) +
      scale_x_continuous(breaks = c(2, 4, 6, 8, 10)) +
      scale_y_discrete(position = "right") +
      theme_mk()

    p
  })
}
