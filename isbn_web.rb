require "sinatra"
enable :sessions
require "csv"

def prepare(num)

#preparing the number by getting rid of spaces
	puts "This is the number #{num}"
	num.delete!(" ")
	num.delete!("-")
	return num
end


def validate_length(num)
	puts "hit the validate length function"
	valid = false

	if num.length == 10 || num.length == 13
		valid = true
	end

	return valid
end


def validate_ten_number(num)
	valid = true

#setting my check sum here... if it is "x" or "X" check sum is 10 else check is converted to integer for following calculation
	check = num[num.length - 1]

	if check == "x" || check =="X"
		check = 10
	else
		check = check.to_i
	end


#performing validation math

# counter will represent the num's "position (1-length) which
# will be multiplied by char which is the actual integer value of the num
# num.length - 2 is used to account for the index shift AND the fact that the last digit in num is the check sum
	counter = 1
	sum = 0
	for x in (0..num.length - 2) do
		char = num[x].to_i
		sum = sum + (char * counter)
		counter +=1 
	end

#final comparison for validation
	sum = sum % 11
	if sum == check
		valid = true
	else
		valid = false
	end

	return valid

end

def validate_13_number(num)

#defining the check value
	check = num[num.length - 1]
	check = check.to_i

#deleting the last digit for easier calculation
	num[num.length - 1] = ""

	switch = true #switches from true to false to flag the correct multiplier
	multiplier = 1
	sum = 0

#main validation calculation
	num.each_char do |char|
		if switch == true 
			multiplier = 1
		else
			multiplier = 3
		end

	sum = sum + (char.to_i * multiplier)
		switch = !switch
	end


	sum = (10 - (sum % 10)) % 10



	if sum == check
		valid = true
	else
		valid = false
	end


	return valid
end

############################################################################
	
get "/" do
	session[:isbn] = []
	erb :welcome
end

get "/input" do
	session[:f_name] = params[:f_name]
	session[:l_name] = params[:l_name]

	
	# 
	erb :input
	# redirect "/input"
end

post "/input" do

		num = params[:isbn]
		prepared = prepare(num)

		length_valid = validate_length(prepared)
			if length_valid == false
				is_valid = false
			elsif prepared.length == 10
				is_valid = validate_ten_number(prepared)
			elsif prepared.length == 13
				is_valid = validate_13_number(prepared)
			end

			if is_valid == true
				then is_valid = "Valid"
			else
				is_valid = "Invalid"
			end

		session[:isbn] << [[params[:isbn], is_valid], session[:f_name], session[:l_name]]
	erb :input

end

post "/index" do


	session[:isbn].each do |info|
		num = info[0][0]
		is_valid = info[0][1]
		f_name = info[1]
		l_name = info[2]
		CSV.open("isbn_numbers.csv", "a+") do |csv|

		csv << [num, is_valid, f_name, l_name]
		end
	end

	redirect "/index"
end



get "/index" do




erb :index

end










#arn:aws:s3:::isbnnumbers















