class AddUuidToSession < ActiveRecord::Migration[8.0]
  def change
    add_column :sessions, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_index :sessions, :uuid, unique: true
  end
end
