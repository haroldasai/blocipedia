require 'random_data'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Users
if ENV["random"]

	5.times do
	  User.create!(
	    email:    RandomData.random_email,
	    password: RandomData.random_sentence
	  )
	end
	users = User.all


	# Create Posts
	50.times do

	  wiki = Wiki.create!(
	    user:   users.sample,
	    title:  RandomData.random_sentence,
	    body:   RandomData.random_paragraph
	  )

	end

end

if ENV["faker"]
	1.times do
	  User.create!(
	    email:    Faker::Internet.unique.email,
	    password: Faker::Crypto.md5
	  )
	end
	users = User.all

  1.times do
	  wiki = Wiki.create!(
	    user:   users.sample,
	    title:  Faker::Music.unique.instrument,
	    body:   Faker::HarryPotter.unique.quote
	  )
	end
end	

#wikis = wiki.all

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} users created"