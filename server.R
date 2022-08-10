library(shiny)
library(DT)

server <- function(input, output, session) {
  leaderboard_df <- reactivePoll(
    intervalMillis = GOOGLE_SHEETS_POLL_SECS * 1000,
    session = session,
    checkFunc = read_sheets_df,
    valueFunc = read_sheets_df
  )

  output$leaderboard_dt <- DT::renderDataTable({
    display_cols <- c("name", "major", "time")
    display_col_names <- c("Name", "Major", "Time")

    display_df <- leaderboard_df()
    fastest_times <- aggregate(seconds ~ name + major, display_df, min)

    fastest_times <- merge(
      fastest_times,
      display_df,
      by = c("name", "major", "seconds")
    )

    fastest_times <- fastest_times[order(fastest_times$seconds), ]

    fastest_times <- fastest_times[, display_cols]
    names(fastest_times) <- display_col_names
    rownames(fastest_times) <- NULL
    fastest_times
  })
}
