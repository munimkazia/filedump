class UploadsController < ApplicationController

  def new
    @upload = Upload.new
    @uploads = Upload.all.order(created_at: :desc)
  end

  def show
    if session[:user] == nil
      render nothing: true, head: :unauthorized 
      return
    end

    @upload = Upload.find params[:id]
    send_file Rails.root.join('public', 'uploads', @upload["filename"])
    
  end

  def create
    if session[:user] == nil
      render nothing: true, head: :unauthorized 
      return
    end

    uploaded_io = params[:upload][:filename]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    @upload = Upload.new(filename: uploaded_io.original_filename)
    @upload.save

    redirect_to '/'

  end

  def destroy
    if session[:user] == nil
      render nothing: true, head: :unauthorized 
      return
    elsif session[:user]["admin"] != 1 
      render nothing: true, head: :forbidden
      return
    end 

    @upload = Upload.find params[:id]
    
    if @upload.user["username"] != session[:user]["username"]
      render nothing: true, head: :forbidden 
      return
    end
    
    @upload.destroy

    File.delete Rails.root.join('public', 'uploads', @upload[:filename])

    redirect_to '/'
  end

end
