class AddAttachmentUploadToUploads < ActiveRecord::Migration
  def self.up
    change_table :uploads do |t|
      t.attachment :upload
    end
    remove_column :uploads, :filename
    Upload.delete_all
  end

  def self.down
    remove_attachment :uploads, :upload
    add_column :uploads, :filename, :string
  end
end
