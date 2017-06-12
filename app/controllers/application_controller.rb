class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #before_action :authenticate_user!
  
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
  	if current_user.present?
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to user_path(current_user)
  	else	
      flash[:alert] = "You need to sign up to perform this action."
      redirect_to(new_user_registration_path)
    end 
  end
end
