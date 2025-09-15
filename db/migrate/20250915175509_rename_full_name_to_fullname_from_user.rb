class RenameFullNameToFullnameFromUser < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :full_name, :fullname
  end
end
