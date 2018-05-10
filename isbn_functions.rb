load "./local_env.rb" if File.exist?("./local_env.rb")

def connect()
	connection = Fog::Storage.new({
	  :provider                 => 'AWS',
	  :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID'],
	  :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY'],
	  :region 					=> 'us-east-2'
	})
end


def get_file()
	bucket = connect().directories.new(key: 'isbnnumbers')

	file = bucket.files.get('isbn_numbers.csv')
	#this gets "isbn_numbers.csv" file from AWS
end


def save_file()
	bucket = connect().directories.new(key: 'isbnnumbers')

	bucket.files.create(key: "isbn_numbers.csv", body: File.open('local_isbn.csv'), public: true) #this creates a new file called "isbn_numbers.csv" in the bucket that is defined in bucket= .... with the contents of "local_isbn.csv"
end


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

def validate_is_number(num)
	check_num = ""
	for x in (0...num.length - 1)
		check_num[x] = num[x]
	end
	result = check_num =~ /\A\d+\z/ ? true : false
	return result
end


def validate_ten_number(num)
	valid = true

#setting my check sum here... if it is "x" or "X" check sum is 10 else check is converted to integer for following calculation


	check = num[num.length - 1].downcase == "x" ? 10 : num[num.length - 1].to_i

	#
	# if check.downcase == "x"
	# 	check = 10
	# else
	# 	check = check.to_i
	# end


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


	switch = true #switches from true to false to flag the correct multiplier
	multiplier = 1
	sum = 0

#main validation calculation
	for x in (0...num.length - 1) do
		if switch == true
			multiplier = 1
		else
			multiplier = 3
		end

	sum = sum + (num[x].to_i * multiplier)
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
