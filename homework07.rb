require 'sqlite3'

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
  select_query = "SELECT * FROM #{table_name};"
  results = db.execute(select_query)
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
    # print "Name: "
    # superhero_name = gets.chomp
    puts "Nemesis: "
    villains = db.execute("SELECT * FROM villains")
    villains.each do |villain|
      puts villain[0].to_s + ". " + villain[1].to_s
    end
    # superhero_nemesis = gets.chomp
    puts "Colors: "
    colors = db.execute("SELECT * FROM colors")
    colors.each do |color|
      puts color[0].to_s + ". " + color[1].to_s
    end
    puts "Powers: "
    powers = db.execute("SELECT * FROM powers")
    powers.each do |power|
      puts power[0].to_s + ". " + power[1].to_s
    end
  else
    print "Name: "
    input = gets.chomp
    db.execute("INSERT INTO #{table_name}(name) VALUES(\"#{input}\")")
  end
end




