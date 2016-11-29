require_relative 'api.rb'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/user.rb'
require_relative 'models/tweet.rb'
require_relative 'models/follow.rb'

class client_library

def initialize 
	@user_inpunt = ''
	puts "welcome to nanotwitter's client libray"
	puts "to view commands press help" 
	while @user_inpunt != 'exit'
		print 'nt>'
		@user_input = gets.chomp 
		analyze_input(@user_input)
	end
	puts "thanks for using nanotwitter's client library"
end

def commands
	puts "note: the words after the '+' sign stand for parameters" 
	puts 'login + username (logs you into your nanotwitter account)'


end

def analyze_input(input)
	case
		when input[0] == 'login' login(input[1])
		when input[0] == 'help'  commands
		when input[0] == 'login' login(input[1])
		when input[0] == 'login' login(input[1])
	end

end

def login(name)
	unless User.where(user_name: user).exists?
		puts "username does not exists"
		
	else 
		u = User.where(user_name: user)
		input = '' 
		while input != u.password || input != 'exit' 

	end

end

def 


end