# Pickle

Project that parses pickleball tournament webpages so we have a database with
all of them.

These are the 3 websites I found that are interesting to parse, there may be more:
- USA Pickeball: https://usapickleball.org/events/list/
- PPA Tour: https://www.ppatour.com/
- APP Tour: https://apptour.org/

## Usage

Boot up an iex session:

```
iex -S mix
```

And fetch some tournaments:

```elixir
Pickle.Workflows.scrape_all_tournaments()
```

You can then look at the different tournaments:

```
pickle_dev=# select name, start_date, state, prize_money from tournaments where prize_money > 0 order by start_date asc limit 10;
                  name                   | start_date | state | prize_money 
-----------------------------------------+------------+-------+-------------
 Mesa Open                               | 2022-01-13 | AZ    |          75
 APP Masters                             | 2022-01-18 | FL    |          75
 APP $15k Next Gen – Oklahoma City       | 2022-02-04 | OK    |          15
 Foot Solutions Arizona Grand Slam       | 2022-02-16 |       |         120
 Punta Gorda                             | 2022-02-23 | FL    |          40
 Ororo PPA Indoor National Championships | 2022-02-24 |       |         120
 Plantation Open                         | 2022-03-02 | FL    |          40
 APP $40k Plantation Open                | 2022-03-02 | FL    |          40
 PPA Riverland Open                      | 2022-03-10 |       |         120
 Delray Beach Pickleball Open            | 2022-03-15 | FL    |          60
(10 rows)
```

Or, if you don't want to run the app and just want to play with the data, you can set a local postgres instance as follows:
- make sure you have postgres on your local machine, won't go into detail how here.
- `psql -U postgres -h localhost -c 'create database pickle_dev;'`
- `psql -d pickle_dev -U postgres -h localhost -f pickle_tournaments.sql`

If you don't want to do any of that and just want a csv of the data, check `tournaments.csv`.

Here is a link to a viewable sheet:
https://docs.google.com/spreadsheets/d/1sRqymNxp-wVNQV_DxP0thV3vOgtpMU5rXEeBaxx4V8Q/edit?usp=sharing
