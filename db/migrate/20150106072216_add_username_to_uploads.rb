class AddUsernameToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :username, :string
  end
end
