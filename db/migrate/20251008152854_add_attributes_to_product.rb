class AddAttributesToProduct < ActiveRecord::Migration[8.0]
  def change
    change_table :products, bulk: true do |t|
      # "0.0" string to avoid float precision issues
      t.decimal :price, precision: 10, scale: 2, null: false, default: "0.0"
      t.integer :stock_quantity, null: false, default: 0
      t.string :sku
      t.string :status, null: false, default: "draft"
    end
  end
end
