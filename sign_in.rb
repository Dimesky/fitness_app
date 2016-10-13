

def sign_into_acct
	@login = false
	@found = false
	puts "Please enter your username: "
	user = gets.chomp
	usernames = @users.execute("SELECT acctName, password FROM users")
	usernames.each do |username|
		if username['acctName'] == user
			puts "Please enter your password: "
			until @pass == username['password']
				@pass = gets.chomp
				if @pass == username['password']
				@login = true
				elsif @pass == 'x'
					exit_msg
					break
				elsif @pass != username['password']
					puts "Incorrect password, please try again or type 'x' to exit: "
				end
			end
			@found = true
		end
	end
	if @found == false
		puts "Incorrect username. Type 's' to try again or 'c' to create an account: "
		second_try = gets.chomp[0].downcase
		if second_try == 's'
			sign_into_acct
		else
			create_new_acct
		end
	elsif @found == true && @login == true
		puts "Welcome, #{user}!"
		#put method for asking what they want to do here
	end
end