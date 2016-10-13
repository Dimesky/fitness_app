# This app will ask the user if they are a man or a woman, how old they are, 
# how much they weigh, and what their favorite exercise is. It will then allow the 
# user to enter foods that they eat, either by calories or recognized foods (and mounts of
# them). The app will then store the user information in a table, and also store the
# foods that they eat in a separate table (if the food is unrecognized the app will store
# it to be remembered later).
#
# The app will also initially ask the user if they are looking to maintain wieght, 
# lose weight, or gain weight, and their favorite exercises and foods, andprovide them with
# instructions for the day for food intake & exercise.
#
# Eventually, the app will be able to give users suggestions about foods that they commonly
# eat that can be cut out of their diet (with reminders based on when they usually eat
# those foods), and give people reminders throughout the day to exercise based on their
# total food intake for the day.

require 'sqlite3'

#create user db

users = SQLite3::Database.new("users.db")
users.results_as_hash = true

@sign_in = nil

def user_interface 
	puts "Welcome to Virtual Personal Trainer!"
	3.times {|time| puts "               ---                  "}
	puts "Would you like to sign in or create an account?"
	puts "Enter 'y' to sign in or 'c' to create an account: "
	@sign_in = gets.chomp.downcase
		if @sign_in[0] == 'y'
			sign_into_acct
		else
			create_new_acct
		end
end

