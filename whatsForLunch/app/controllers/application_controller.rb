class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

#below is suggested to be in HomeController... do we want
#it here, or in UserController?

  def search
    parameters = { user: params[:user], limit: 1 }
    render json: Yelp.client.search(‘//location//’, parameters)
  end

#***params[:term] I guess will be equal
#to whatever array we wind up with?

  def current_user
    return unless session[:user_id]
    @current_user ||= User.where(session[:user_id]).first
  end

end
