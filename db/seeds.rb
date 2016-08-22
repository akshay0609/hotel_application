# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

room_category = [
    {category_type:"Deluxe Rooms",facility:"Queen size Bed",price:7000},
    {category_type:"Luxury Rooms",facility:"Queen size Bed and pool facing",price:8500},
    {category_type:"Luxury Suites",facility:"King Size Bed and Pool Facing",price:12000},
    {category_type:"Presidential Suites",facility:"King Size Bed, Pool Facing with a Gym",price:20000}
]

room_category.each do |category|
  Category.create!(category)
end

"A".upto("D") do |room|
  1.upto(5) { |room_number| Room.create!(room_id: "#{room} #{room_number}", category_id: 1) }
end

"A".upto("D") do |room|
  6.upto(10) { |room_number| Room.create!(room_id: "#{room} #{room_number}", category_id: 2) }
end

11.upto(20) { |room_number| Room.create!(room_id: "D #{room_number}", category_id: 3) }

1.upto(2) { |room_number| Room.create!(room_id: "E #{room_number}", category_id: 3) }

3.upto(10) { |room_number| Room.create!(room_id: "E #{room_number}", category_id: 4) }
