class RemoveUuidFromSession < ActiveRecord::Migration[8.0]
  def change
    remove_column :sessions, :uuid, :string
  end
end
