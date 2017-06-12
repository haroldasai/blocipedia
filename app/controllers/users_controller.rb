class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    authorize @user
    session[:return_to] ||= request.referrer
  end

  def downgrade
  	@user = User.find(params[:id])
  	@user.role = 0

    @user.wikis.each do |wiki|
      wiki.update_attribute(:private, false)
    end  

  	if @user.save
      flash[:notice] = "You've been downgraded to a standard user. All your private wikis became public."
      redirect_to @user
    else
      flash.now[:alert] = "Error downgrade your subscription. Please try again."
      redirect_to @user
    end
  end	

end