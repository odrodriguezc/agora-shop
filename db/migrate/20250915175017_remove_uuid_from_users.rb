class RemoveUuidFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :uuid, :string
  end
end
