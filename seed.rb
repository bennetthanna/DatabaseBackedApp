#!/usr/bin/env ruby
require 'sqlite3'

$db = SQLite3::Database.new("homework07.sqlite3.db")

def execute_single_insert_query(list, table_name)
  list.each do |value|
    $db.execute("INSERT INTO #{table_name}(name) VALUES( ? );", value)
  end
end

def execute_pair_insert_query(table_name, list, column1, column2)
  list.each do |pair|
    $db.execute("INSERT INTO #{table_name}(#{column1}, #{column2}) VALUES ( ?, ? )", pair)
  end
end

def execute_triplet_insert_query(table_name, list, column1, column2, column3)
  list.each do |triplet|
    $db.execute("INSERT INTO #{table_name}(#{column1}, #{column2}, #{column3}) VALUES ( ?, ?, ? )", triplet)
  end
end

def execute_delete_query(list)
  list.each do |value|
    $db.execute("DELETE FROM #{value};")
    $db.execute("DELETE FROM SQLITE_SEQUENCE WHERE name=\'#{value}\'")
  end
end

tables = [ "villains", "teams", "powers", "colors", "superheroes", "colors_superheroes", "powers_superheroes"]
villains = ["The Joker", "Bane", "Lex Luthor", "Voldemort", "Loki"]
teams = ["Suicide Squad", "The Avengers", "X-Men"]
powers = ["Flight", "Invisibility", "X-Ray Vision", "Telpathy", "Time Travel", "Strength", "Immortality"]
colors = ["Red", "Orange", "Yellow", "Green", "Blue", "Black", "Brown"]
colors_superheroes = [[1, 6], [1, 3], [2, 1], [2, 5], [3, 1], [3, 6]]
powers_superheroes = [[1, 1], [1, 6], [1, 7], [2, 2], [2, 1], [3, 1]]
superheroes = [["Batman", 2, 3], ["Wonder Woman", 1, 1], ["Superman", 3, 3]]

execute_delete_query(tables)
execute_single_insert_query(villains, "villains")
execute_single_insert_query(teams, "teams")
execute_single_insert_query(powers, "powers")
execute_single_insert_query(colors, "colors")
execute_pair_insert_query("colors_superheroes", colors_superheroes, "superhero_id", "color_id")
execute_pair_insert_query("powers_superheroes", powers_superheroes, "superhero_id", "power_id")
execute_triplet_insert_query("superheroes", superheroes, "name", "villain_id", "team_id")

$db.close
