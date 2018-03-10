class UsersController < ApplicationController
  # logged_in_user is a methode that we call always before edit and update
  before_action :logged_in_user, only: [:index ,:edit, :update , :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page] ).where(activated: true)
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    redirect_to root_url unless @user.activated?
  end
  
  def create
    @user = User.new(user_params) 
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # login @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user #this line redirect to the current  /users/id that has been created
    else
      render 'new'
    end 
  end 
    
  def edit 
    @user = User.find(params[:id])
  end
  
  def update 
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy 
    @user = User.find(params[:id]).destroy
     flash[:success] = "Profile Deleted"
     redirect_to users_url
  end
  
    private
    
    #strong parameters 
    def user_params
      params.require(:user).permit(:name , :email , :password , :password_confirmation)
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please login first"
        redirect_to login_path
      end
    end
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
