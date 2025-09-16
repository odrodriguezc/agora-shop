class AddColumnsToProducts < ActiveRecord::Migration[8.0]
  def change
    rename_column :products, :name, :title, null: false

    add_column :products, :description, :text
    add_column :products, :brand, :string
    add_column :products, :category, :string
    add_column :products, :price, :decimal, precision: 10, scale: 2
    add_column :products, :stock_quantity, :integer, default: 0
    add_column :products, :upc, :string
  end
end
