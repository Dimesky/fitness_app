

def prompt_user_action
	3.times {|time| puts "               |||               "}
	puts "Please select the number corresponding with your desired action: "
	puts "1. Enter calories consumed today"
	puts "2. Enter favorite exercises"
	puts "3. Request to display information based on day selected"
	puts "4. Exit"
	user_choice = gets.chomp.to_i
	if user_choice == 1
		#method to enter calories
		enter_calories
	elsif user_choice == 2
		#method to enter exercises
		enter_exercises
	elsif user_choice == 3
		#method to request exercise and food to cut based on date
		request_data
	elsif user_choice == 4
		exit_msg
	else
		puts "You have made an invalid selection -"
		prompt_user_action
	end
end

def enter_calories
	@food_hash = {}
	food_cals = nil
	while food_cals != 'x'
		puts "Please enter the food and calories in the form of 'food, amount, calories' where 'amount' is the amount in ounces of food (type 'x' when finished): "
		food_cals = gets.chomp
		food_cal_split = food_cals.split(',')
		if food_cals != 'x' && food_cal_split.length == 3
			@food = food_cal_split[0]
			@amount = food_cal_split[1]
			@cals = food_cal_split[2]
			@food_hash[food_cal_split[0]] = [food_cal_split[1], food_cal_split[2]]
			log_calories
		elsif food_cal_split.length != 3 && food_cals != 'x'
			puts "Invalid entry, please try again"
		end
	end
	if food_cals == 'x'
		puts "You entered: "
		puts "\n"
		@food_hash.each do |food, amount_and_cals|
			puts "Food: #{food}"
			puts "-----------------"
			puts "Amount: #{amount_and_cals[0]} oz"
			puts "Calories: #{amount_and_cals[1]} calories"
			puts "\n"
		end
	end
	prompt_user_action
end

def log_calories
	current_user_id = @users.execute("SELECT id FROM users WHERE acctName='#{@acctName}'")
	current_user_id = current_user_id[0]['id']
	time = Time.new.to_a
	time = time[4].to_s + "-" + time[3].to_s + "-" + time[5].to_s
	@users.execute(@create_days_logged_table)
	@users.execute("INSERT INTO days_logged (date, food, amount, calories, users_id) VALUES (?, ?, ?,
		?, ?)", [time, @food, @amount, @cals, current_user_id])
end

def enter_exercises
	@exercise_hash = {}
	exercises = nil
	while exercises != 'x'
		puts "Please enter your favorits exercises and avg heart rate of the exercise in the form of 'exercise, heart rate' (or type 'x' to quit): "
		exercises = gets.chomp
		exercise_split = exercises.split(',')
		if exercises != 'x'
			@exercise = exercise_split[0]
			@avg_hr = exercise_split[1]
			@exercise_hash[@exercise] = @avg_hr
			log_exercises
		end
	end
	if exercises == 'x'
		puts "You entered: "
		puts "\n"
		@exercise_hash.each do |exercise, hr|
			puts "Exercise: #{exercise}"
			puts "------------------"
			puts "AVG HR: #{hr}"
			puts "\n"
		end
	end
	prompt_user_action
end

def log_exercises
	current_user_id = @users.execute("SELECT id FROM users WHERE acctName='#{@acctName}'")
	current_user_id = current_user_id[0]['id']
	@users.execute(@create_favorite_exercises_table)
	@users.execute("INSERT INTO favorite_exercises (exercise, avg_hr, users_id) VALUES (?, ?, ?)", [@exercise, @avg_hr, current_user_id])
end

def request_data
	puts "Please enter a date in the format of 'day-month-year': "
	request_date = gets.chomp
	usr_date_food = @users.execute("SELECT days_logged.food
		, days_logged.amount, days_logged.calories FROM users JOIN days_logged 
		ON users.id = days_logged.users_id WHERE acctName = '#{@acctName}' OR date = '#{request_date}';")
	10.times {|time| puts "\n"}
	puts "********************************************************************"
	puts "On #{request_date} you ate: "
	usr_date_food.each do |datefood|
		puts "#{datefood['food']}"
	end
	total_cals = 0
	usr_date_food.each do |datefood|
		total_cals += datefood['calories']
	end
	calories_left_to_burn = total_cals - calculate_bmr
	calory_surplus = calories_left_to_burn + @daily_cals
	puts "For a total of #{total_cals} calories"
	if calory_surplus <= 0
		puts "Calories you need to lose per day: #{@daily_cals}"
		puts "Your resting metabolic rate: #{calculate_bmr} cal"
		puts "You don't need to change anything...Great job!!!"
	else
		cals_over = total_cals - (@daily_cals + calculate_bmr)
		puts "You needed to burn #{cals_over.abs} additional calories!"
	end
	puts "********************************************************************"
	10.times {|time| puts "\n"}
	prompt_user_action
end

def calculate_bmr
	if @sex == 'M'
		bmr = (((6.25 * @weight) + (12.7 * @height) - (6.76 * @age) + 66) * 1.1)
	elsif @sex == 'F'
		bmr = (((4.35 * @weight) + (4.7 * @height) - (4.68 * @age) + 655) * 1.1)
	end
end







