json.extract! product, :id, :title, :description, :price, :stock_quantity, :sku, :created_at, :updated_at
json.url product_url(product, format: :json)
