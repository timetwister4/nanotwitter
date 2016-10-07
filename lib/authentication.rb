require_relative 'models/user.rb'
require_relative 'models/tweet.rb'

module Authentication
  def authenticate!
    unless session[:user]
      session[:original_request] = request.path_info
      redirect '/login'
    end
  end

  def exist?(email,pass)
  	 User.where(email: email, password: pass)
  end
end
