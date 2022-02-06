# Pickle

Project that parses pickleball tournament webpages so we have a database with
all of them.

These are the 3 websites I found that are interesting to parse, there may be more:
- USA Pickeball: https://usapickleball.org/events/list/
- PPA Tour: https://www.ppatour.com/
- APP Tour: https://apptour.org/

## Usage

```elixir
Pickle.Workflows.parse_tournament_website(url)
```
