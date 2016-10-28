#require_relative '/models/user.rb'

def authenticate!
	 #when we solve the require relative problem write the line: unless session[:user_id] && User.where(id: session[:user_id])
		unless session[:user_id]
			session[:original_request] = request.path_info
			#redirect '/login'#should not do this
			false
		else
			session
		end
end

def current_user
	current_user_id = session[:user_id]
	return nil if current_user_id.nil?
	User.find(current_user_id)
end

	def log_out_now
		session.clear
	end


	def logged_in?
		!session[:user_id].nil?
	end

	def redirect_to_original_request

	end
