

def prompt_user_action
	3.times {|time| puts "               |||               "}
	puts "Please select the number corresponding with your desired action: "
	puts "1. Enter calories consumed today"
	puts "2. Request exercises left today"
	puts "3. Request total calories burned, and pounds lost since sign up"
	puts "4. Request recommendation for common foods to eliminate"
	puts "5. Exit"
	user_choice = gets.chomp.to_i
	if user_choice == 1
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