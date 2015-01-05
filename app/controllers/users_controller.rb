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
    @user = User.where "username = :user and password = :pass", { user: username, pass: password }
    puts @user
    if @user.length > 0
      session[:user] = @user[0]
      redirect_to '/'
    else
      redirect_to '/users/login?err=1'
    end


  end

  def logout
    session.delete :user
    redirect_to '/'
  end

end
