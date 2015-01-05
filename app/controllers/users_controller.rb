class UsersController < ApplicationController

  def show_login
    if session[:user]
      redirect_to '/'
    end

    if params[:err]
      @error = 1
    else
      @error = 0
    end
  end

  def login
    username = params[:username]
    password = params[:password]
    @user = User.find_by(username: username).try(:authenticate, password)
    if @user == false
      redirect_to '/users/login?err=1'
    else 
      session[:user] = @user
      redirect_to '/'  
    end


  end

  def logout
    session.delete :user
    redirect_to '/'
  end

end
