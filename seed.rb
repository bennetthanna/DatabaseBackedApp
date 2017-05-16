#!/usr/bin/env ruby
require 'sqlite3'

# include library
# connect to db
# execute query
# do something with the result
# close the db

# TODO: establish relationships between superheroes and villains, teams, colors and powers

db = SQLite3::Database.new("homework07.sqlite3.db")

[ "villains", "teams", "powers", "colors", "superheroes"].each do |table_name|
  db.execute("DELETE FROM #{table_name};")
  db.execute("DELETE FROM SQLITE_SEQUENCE WHERE name=\'#{table_name}\'")
end

[ "The Joker", "Bane", "Lex Luthor" ].each do |villain_name|
  db.execute("INSERT INTO villains(name) VALUES( ? );", villain_name)
end

[ "Suicide Squad", "The Avengers", "X-Men"].each do |team_name|
  db.execute("INSERT INTO teams(name) VALUES( ? );", team_name)
end

[ "Flight", "Invisibility", "X-Ray Vision", "Telpathy",
  "Time Travel", "Strength", "Immortality"].each do |superpower|
  db.execute("INSERT INTO powers(name) VALUES( ? );", superpower)
end

[ "Red", "Orange", "Yellow", "Green", 
  "Blue", "Black", "Brown"].each do |color|
  db.execute("INSERT INTO colors(name) VALUES( ? );", color)
end

[["Batman", 2, 3], ["Wonder Woman", 1, 1], ["Superman", 3, 3]].each do |superhero|
  db.execute("INSERT INTO superheroes(name, villain_id, team_id) 
              VALUES ( ?, ?, ? )", superhero)
end

[[1, 6], [1, 3], [2, 1], [2, 5], [3, 1], [3, 6]].each do |pair|
  db.execute("INSERT INTO colors_superheroes(superhero_id, color_id)
              VALUES ( ?, ? )", pair)
end

[[1, 1], [1, 6], [1, 7], [2, 2], [2, 1], [3, 1]].each do |pair|
  db.execute("INSERT INTO powers_superheroes(superhero_id, power_id)
              VALUES ( ?, ? )", pair)
end

# select_query = "SELECT * FROM villains, superheroes WHERE superheroes.villain_id = villains.id"
# results = db.execute(select_query)
# results.each do |row|
#   p row
# end

# select_query = "SELECT * FROM villains;"
# results = db.execute(select_query)
# results.each do |row|
#   p row
# end

# select_query = "SELECT * FROM teams;"
# results = db.execute(select_query)
# results.each do |row|
#   p row
# end

# select_query = "SELECT * FROM powers;"
# results = db.execute(select_query)
# results.each do |row|
#   p row
# end

# select_query = "SELECT * FROM colors;"
# results = db.execute(select_query)
# results.each do |row|
#   p row
# end

# select_query = "SELECT * FROM superheroes;"
# results = db.execute(select_query)
# results.each do |row|
#   p row
# end

db.close
