# This app will ask the user if they are a man or a woman, how old they are, 
# how much they weigh, and what their favorite exercise is. It will then allow the 
# user to enter foods that they eat, either by calories or recognized foods (and mounts of
# them). The app will then store the user information in a table, and also store the
# foods that they eat in a separate table (if the food is unrecognized the app will store
# it to be remembered later).
#
# The app will also initially ask the user if they are looking to maintain wieght or
# lose weight and their favorite exercises and foods, and provide them with
# instructions for the day for food intake & exercise.
#
# Eventually, the app will be able to give users suggestions about foods that they commonly
# eat that can be cut out of their diet (with reminders based on when they usually eat
# those foods), and give people reminders throughout the day to exercise based on their
# total food intake for the day.

require 'sqlite3'
require_relative 'sign_in'

#create user db

@users = SQLite3::Database.new("users.db")
@users.results_as_hash = true

@create_users_table = <<-USRTBL
	CREATE TABLE IF NOT EXISTS users(
	id INTEGER PRIMARY KEY,
	acctName VARCHAR(255),
	password VARCHAR(255),
	sex CHARACTER,
	age INT,
	weight INT,
	height INT,
	lose BOOLEAN,
	time INT,
	daily_cals INT
	);
USRTBL

@create_days_logged_table = <<-USRTBL
	CREATE TABLE IF NOT EXISTS days_logged(
	id INTEGER PRIMARY KEY,
	date DATE,
	food VARCHAR(255),
	amount INT,
	calories INT,
	users_id INT
	);
USRTBL

@create_favorite_exercises_table = <<-USRTBL
	CREATE TABLE IF NOT EXISTS favorite_exercises(
	id INTEGER PRIMARY KEY,
	exercise VARCHAR(255),
	avg_hr INT,
	users_id INT
	);
USRTBL


# User interface to welcome user to app and determine if the should sign in, create new acct, or exitn
def user_interface
	puts "Welcome to Virtual Personal Trainer!"
	3.times {|time| puts "               ---                  "}
	puts "Would you like to sign in or create an account?"
	puts "Enter 's' to sign in or 'c' to create an account (or 'x' to exit): "
	sign_in = gets.chomp.downcase
	while sign_in != 's' && sign_in != 'c' && sign_in != 'x'
		puts "Invalid entry, please try again: "
		sign_in = gets.chomp.downcase
	end
	if sign_in[0] == 's' 
		sign_into_acct
	elsif sign_in[0] == 'c'
		create_new_acct
	else
		exit_msg
	end
end

# Asks user for info to build new account
def create_new_acct
	puts "Please enter an account name: "
	@acctName = gets.chomp
	puts "Please enter a password: "
	@password = gets.chomp
	puts "Please enter 'M' for male or 'F' for female: "
	@sex = gets.chomp[0].upcase
	puts "Please enter your age in years: "
	@age = gets.chomp.to_i
	puts "Please enter your weight in pounds: "
	@weight = gets.chomp.to_i
	puts "Please enter your height in inches: "
	@height = gets.chomp.to_i
	puts "Do you want to lose weight? (type 'y' for yes or 'n' for no): "
	@lose = gets.chomp.downcase
	if @lose[0] == 'y'
		@lose = 'true'
		calculate_calories
	else
		@lose = 'false'
		@daily_cals = 0
		@time = 0
	end
	create_user
	prompt_user_action
end

# Method to calculate calories based on weight lost/time
def calculate_calories
	puts "How many pounds do you want to lose? "
	pounds = gets.chomp.to_i
	puts "Please enter a whole number of months you wish to lose the weight in: "
	@time = gets.chomp.to_i
	days = @time * 30
	calories = pounds * 3500
	@daily_cals = calories / days
end

# Method to create user in db based off of new user values
def create_user
	@users.execute(@create_users_table)
	@users.execute("INSERT INTO users (acctName, password, sex, age, weight, height, lose, time
		, daily_cals) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", [@acctName, @password, @sex, @age, @weight,
		@height, @lose, @time, @daily_cals])
end

# Method to provide user an exit message
def exit_msg
	3.times {|time| puts "               ---              "}
	puts "Great job today, see you tomorrow!"
end

user_interface


