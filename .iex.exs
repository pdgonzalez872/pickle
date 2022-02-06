# Pickle.Workflows.scrape_tournaments("https://apptour.org/the-2022-app-tour-schedule")
# Pickle.Workflows.scrape_tournaments("https://www.ppatour.com/ppa-tour")
# Pickle.Workflows.scrape_tournaments("https://usapickleball.org/events/list/?tribe_paged=1&tribe_event_display=list&tribe-bar-date=2022-01-26")

fun = fn ->
  Pickle.Workflows.scrape_tournaments("https://usapickleball.org/events/list/?tribe_paged=1&tribe_event_display=list&tribe-bar-date=2022-01-26", Pickle.UsaPickleballParser)
end
