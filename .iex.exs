fun = fn ->
  Pickle.Workflows.scrape_tournaments(
    "https://apptour.org/the-2022-app-tour-schedule",
    Pickle.APPParser
  )

  # Req.get!("https://apptour.org/the-2022-app-tour-schedule")
end
