class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
	  @title = @user.name
  end
  
  def new
    @user = User.new
  	@title = "Register"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
	    flash[:success] = "Welcome to Xchange-u!"
      redirect_to @user
    else
      @title = "Register"
      @user.password =""
      @user.password_confirmation =""
      render 'new'
    end
  end
end
