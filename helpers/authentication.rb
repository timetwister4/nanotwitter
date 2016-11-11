require_relative '../models/user.rb'
require "byebug"

def authenticate!
	 #when we solve the require relative problem write the line: unless session[:user_id] && User.where(id: session[:user_id])
		if session[:user_id] #&& User.where(id: session[:user_id]).exists? #if the user id saved in session does not belong to any user, also direct to general homepage
			true
		else
			session[:original_request] = request.path_info
			false
		end
end

def current_user
	current_user_id = session[:user_id]
	return nil if current_user_id.nil?
	User.find(current_user_id)
end


def login (params)
	u = User.find_by_email(params[:email])
  if u && u.password == params[:password] #User.where(&: params[:email], password: params[:password]).exists?
	   #u = User.where(email: params[:email], password: params[:password])
     @user = u #u[0] #in order to become the array of fields
     session[:user_id] = @user.id
     session[:expires_at] = Time.current + 10.minutes
     return session
  else
    return nil
  end
end

	def log_out_now
		session.clear
	end


	def logged_in?
		!session[:user_id].nil?
	end

	def redirect_to_original_request

	end
