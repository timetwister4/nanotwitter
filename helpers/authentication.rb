require_relative '../models/user.rb'
require "byebug"


def authenticate!

		if session[:user_id] && User.where(id: session[:user_id]).exists? #if the user id saved in session does not belong to any user, also direct to general homepage
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
	if params[:email]
		u = User.find_by_email(params[:email])
	elsif params[:user]
		u = User.find_by_user_name(params[:user])
	else
		return false
	end
	if u && u.password == params[:password]
		session[:user_id] = u.id
		session[:user_name]= u.user_name
	    return session
	else
	    return nil
    end
end

# logs current user out
def log_out_now
	session[:user_id] = nil
	session[:user_name] = nil
end

def logged_in?
	if !session[:user_id].nil?
		return true
	else
		redirect '/'
	end
end
