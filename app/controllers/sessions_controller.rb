class SessionsController < ApplicationController
  def new
  end
  
  def create 
    #  all the emails are saved downcase in the DB
    user = User.find_by(email: params[:session][:email].downcase) 
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        # Log the user in and redirect to the user's show page.
        login user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user  # rails convert user to user_url(user)
      else
        message = "Account not activated"
        message += "Check your email for the activation link"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'WAA ba khona ta zyeeeer'
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
end
