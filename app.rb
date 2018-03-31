require 'rubygems'
require 'fog'
require 'csv'
require "sinatra"
require_relative "isbn_functions"
enable :sessions


get "/" do
	session[:isbn] = Array.new
	erb :welcome
end


get "/input" do
	CSV.foreach("local_isbn.csv") do |row|
		if row[2] == session[:f_name] && row[3] == session[:l_name]
			session[:message] = "Previous numbers you have checked: "
		end
	end
	session[:message] = "Previous numbers you have checked:"
	session[:f_name] = params[:f_name]
	session[:l_name] = params[:l_name]

	erb :input
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

		result = validate_is_number(num)

		if is_valid == true && result == true
			is_valid = "Valid"
		else
			is_valid = "Invalid"
		end

	session[:isbn] << [num, is_valid, session[:f_name], session[:l_name]]
	erb :input
end


post "/index" do

		#replace contents of local_isbn.csv with contents of AWS isbn_numbers.csv
		aws_file = get_file()
		contents = aws_file.body

	 	File.open('local_isbn.csv', "w+") do |file|
	    file.puts(contents)
	    file.close
		end

		#push the contents of session[:isbn] into the local_isbn.csv file
		session[:isbn].each do |info|
			num = info[0]
			is_valid = info[1]
			f_name = info[2]
			l_name = info[3]

			File.open('local_isbn.csv', "a+") do |file|
		    	file.puts("#{num},#{is_valid},#{f_name},#{l_name}\n")
			end

		end

		save_file() #save local file to AWS bucket

	redirect "/index"

end


get "/index" do

	erb :index


end

get "/again" do
	session[:isbn] = []
	erb :input

end
