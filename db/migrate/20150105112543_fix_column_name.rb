class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :uploads, :uploaded, :created_at
  end
end
