class UploadsController < ApplicationController

  def new
    @upload = Upload.new
    @uploads = Upload.all.order(created_at: :desc)
    @admin = 1 if session[:user] && session[:user]["admin"] == 1
  end

  def create
    uploaded_io = params[:upload][:filename]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    @upload = Upload.new(filename: uploaded_io.original_filename)
    @upload.save

    redirect_to '/'

  end

  def destroy
    @upload = Upload.find params[:id]
    @upload.destroy

    File.delete Rails.root.join('public', 'uploads', @upload[:filename])

    redirect_to '/'
  end

end
