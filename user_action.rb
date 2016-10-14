

def prompt_user_action
	3.times {|time| puts "               |||               "}
	puts "Please select the number corresponding with your desired action: "
	puts "1. Enter calories consumed today"
	puts "2. Enter favorite exercises"
	puts "3. Request exercise recommendation for today"
	puts "4. Request recommendation for common foods to eliminate for today"
	puts "5. Exit"
	user_choice = gets.chomp.to_i
	if user_choice == 1
		enter_calories
		#method to enter calories
	elsif user_choice == 2
		#method to request exercises
	elsif user_choice == 3
		#method to request total calories burned and weight lost
	elsif user_choice == 4
		#method to request foods to quit
	elsif user_choice == 5
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
		if food_cals != 'x'
			@food = food_cal_split[0]
			@amount = food_cal_split[1]
			@cals = food_cal_split[2]
			@food_hash[food_cal_split[0]] = [food_cal_split[1], food_cal_split[2]]
			log_calories
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




