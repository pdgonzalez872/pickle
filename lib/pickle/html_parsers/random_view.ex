defmodule Pickle.RandomView do
  def build(tournaments) do
    [
      "|name|prize_money|start_date|end_date|address|city|state|zip|url|map_link|\n",
      "+++++|+++++++++++|++++++++++|++++++++|+++++++|++++|+++++|+++|+++|++++++++\n"
    ] ++
      Enum.map(tournaments, fn t ->
        "|#{t.name}|#{t.prize_money}|#{t.start_date}|#{t.end_date}|#{t.address}|#{t.city}|#{t.state}|#{t.zip}|[link](#{t.url})|[link](#{t.map_link})|\n"
      end)
  end

  def dump(to_dump) do
    to_dump
    |> Enum.join("")
    |> IO.puts()
  end
end
