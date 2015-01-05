class UploadsController < ApplicationController

  def new
    @upload = Upload.new
    @uploads = Upload.all.order(created_at: :desc).limit(5)
  end

  def create
    uploaded_io = params[:upload][:filename]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    @upload = Upload.new(filename: uploaded_io.original_filename)
    @upload.save

  end

  

end
