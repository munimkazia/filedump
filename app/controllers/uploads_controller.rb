class UploadsController < ApplicationController

  def new
    @upload = Upload.new
    @uploads = Upload.all.order(created_at: :desc)
    @user_signed_in = user_signed_in?
    @current_user = current_user
  end

  def show
    unless user_signed_in?
      render nothing: true, head: :unauthorized 
      return
    end

    @upload = Upload.find params[:id]
    send_file @upload.upload.path
    
  end

  def create
    unless user_signed_in?
      render nothing: true, head: :unauthorized 
      return
    end

    @upload = Upload.create(upload: params[:upload][:upload], username: current_user["email"])

    redirect_to '/'

  end

  def destroy
    unless user_signed_in?
      render nothing: true, head: :unauthorized 
      return
    end

    @upload = Upload.find params[:id]
    
    if current_user["admin"] != 1 && @upload.username != current_user["email"]
      render nothing: true, head: :forbidden 
      return
    end
    
    @upload.destroy

    redirect_to '/'
  end

end
