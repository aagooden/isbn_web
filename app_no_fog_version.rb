require 'rubygems'
require 'aws-sdk'
require 'csv'
require "sinatra"
require_relative "isbn_functions"
enable :sessions

	
get "/" do
	session[:isbn] = Array.new
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

		session[:isbn] << [num, is_valid, session[:f_name], session[:l_name]]
	erb :input

end

post "/index" do

	$text_array = Array.new
	text = get_b()
	session[:isbn].each do |info|
		num = info[0]
		is_valid = info[1]
		f_name = info[2]
		l_name = info[3]
		text = text + "#{num},#{is_valid},#{f_name},#{l_name}\n"
		
	end

	push_b(text) #send text to AWS bucket


		#pull whole csv file from bucket and put into array for index 
	s3 = Aws::S3::Client.new
	resp = s3.get_object(bucket: 'isbnnumbers', key:'isbn_numbers.csv')
	all_numbers = resp.body

	CSV.parse(all_numbers) do |row|
		if row == [] || row == [" "]
		else
		$text_array.push(row)
	end
	end

	redirect "/index"
end


get "/index" do

	erb :index

end












