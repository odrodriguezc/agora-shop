module DevelopmentSeeds
  class ProductSeeder
    def self.run
      new.run
    end

    def run
      5.times do |i|
        Product.find_or_create_by!(title: "Product #{i + 1}") do |product|
          product.description = "This is a description for Product #{i + 1}."
          product.category = i.even? ? Category.first : Category.last
          product.price = (i + 1) * 10.0
          product.stock_quantity = (i + 1) * 5
          product.sku = "SKU#{1000 + i}"
          product.status = "published"
        end
      end
      puts "Seeded sample products"
    end
  end
end
