class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params) 
    
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user #this line redirect to the current  /users/id that has been created
    else
      render 'new'
    end 
  end 
    
    private
    
    #strong parameters 
    def user_params
      params.require(:user).permit(:name , :email , :password , :password_confirmation)
    end
    
  
end
