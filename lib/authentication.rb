module Authentication
  def authenticate!
    unless session[:user]
      session[:original_request] = request.path_info
      redirect '/login'
    end
  end
end
