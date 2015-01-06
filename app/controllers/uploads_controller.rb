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
    send_file Rails.root.join('public', 'uploads', @upload["filename"])
    
  end

  def create
    unless user_signed_in?
      render nothing: true, head: :unauthorized 
      return
    end

    uploaded_io = params[:upload][:filename]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    @upload = Upload.new(filename: uploaded_io.original_filename)
    @upload.username = current_user["email"]
    @upload.save

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

    File.delete Rails.root.join('public', 'uploads', @upload[:filename])

    redirect_to '/'
  end

end
