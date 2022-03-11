# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Mood.all.each do |mood|
  mood.destroy if mood.user_id.nil?
end

Mood.create(name: "Romantic", query: "romantic")
Mood.create(name: "Party with friends", query: "good for groups")
Mood.create(name: "Pizza time", query: "pizza")
Mood.create(name: "On a budget", max_price: 2)
Mood.create(name: "Fitness", query: "healthy")
Mood.create(name: "Itadakimasu!", query: "japanese")
