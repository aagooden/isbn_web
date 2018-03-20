load "./local_env.rb" if File.exist?("./local_env.rb")

def push_b(text)
  Aws::S3::Client.new(
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
   )
 
	file = "isbn_numbers.csv"
	bucket = 'isbnnumbers'
	s3 = Aws::S3::Resource.new(region: 'us-east-2')
	obj = s3.bucket(bucket).object(file)

	obj.put(body: text + "\n")

end

def get_b()
  	s3 = Aws::S3::Client.new
	resp = s3.get_object(bucket: 'isbnnumbers', key:'isbn_numbers.csv')

	text = resp.body.read

	return text

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