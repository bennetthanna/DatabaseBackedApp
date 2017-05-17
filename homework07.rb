require 'sqlite3'

def print_options(list)
  list.each do |value|
    puts value[0].to_s + ". " + value[1].to_s
  end
end

db = SQLite3::Database.new("homework07.sqlite3.db")

tables = {1 => "superheroes", 2 => "villains", 3 => "teams", 4 => "powers", 5 => "colors"}

puts "Welcome to the superheroes archive!"

tables.each do |key, value|
  puts key.to_s + '. ' + value.capitalize
end

print "Your command: " 
table_number = gets.chomp
table_name = tables[table_number.to_i]

if table_name == "superheroes"
  results = db.execute("SELECT * FROM superheroes")
  results.each do |row|
    puts row[1]
    puts "Team: " + db.execute("SELECT teams.name FROM teams WHERE teams.id = #{row[3]}").join()
    puts "Nemesis: " + db.execute("SELECT villains.name FROM villains WHERE villains.id = #{row[2]}").join()
    puts "Powers: " + db.execute("SELECT DISTINCT powers.name FROM powers JOIN powers_superheroes
                                  ON powers.id = powers_superheroes.power_id
                                  JOIN superheroes
                                  ON #{row[0]} = powers_superheroes.superhero_id").join(", ")
    puts "Costume colors: " + db.execute("SELECT DISTINCT colors.name FROM colors JOIN colors_superheroes
                                          ON colors.id = colors_superheroes.color_id
                                          JOIN superheroes
                                          ON #{row[0]} = colors_superheroes.superhero_id").join(", ")
    puts "\n"
  end
else
  results = db.execute("SELECT * FROM #{table_name};")
  results.each do |row|
    puts row[1]
  end
end

puts "(A)dd a new " + table_name + ", or (Q)uit"
selection = gets.chomp

if selection == 'Q'
  exit
end

if selection == 'A'
  puts "Add a new #{table_name}"
  if table_name == "superheroes"
    print "Name: "
    superhero_name = gets.chomp
    # should only print out villains that are not associated with a superhero already
    # due to the uniqueness constraint
    puts "Nemesis: "
    villains = db.execute("SELECT * FROM villains LEFT JOIN superheroes ON superheroes.villain_id = villains.id
                           WHERE superheroes.villain_id IS NULL");
    print_options(villains)
    superhero_nemesis = gets.chomp
    puts "Team: "
    teams = db.execute("SELECT * FROM teams")
    print_options(teams)
    superhero_team = gets.chomp
    puts "Colors: (input as comma a comma separated string)"
    colors = db.execute("SELECT * FROM colors")
    print_options(colors)
    superhero_colors = gets.split(',')
    puts "Powers: (input as a comma separated string)"
    powers = db.execute("SELECT * FROM powers")
    print_options(powers)
    superhero_powers = gets.split(',')
    db.execute("INSERT INTO superheroes(name, villain_id, team_id) VALUES(\"#{superhero_name}\", #{superhero_nemesis}, #{superhero_team})")
    inserted_id = db.execute("SELECT id FROM superheroes WHERE name=\"#{superhero_name}\"").join()
    superhero_colors.each do |color|
      db.execute("INSERT INTO colors_superheroes(color_id, superhero_id) VALUES(#{color}, #{inserted_id})")
    end
    superhero_powers.each do |power|
      db.execute("INSERT INTO powers_superheroes(power_id, superhero_id) VALUES(#{power}, #{inserted_id})")
    end
  else
    print "Name: "
    input = gets.chomp
    db.execute("INSERT INTO #{table_name}(name) VALUES(\"#{input}\")")
  end
end




