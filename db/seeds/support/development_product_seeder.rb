module DevelopmentSeeds
  class ProductSeeder
    def self.run
      new.run
    end

    def run
      5.times do |i|
        Product.find_or_create_by!(title: "Product #{i + 1}") do |product|
          product.description = "This is a description for Product #{i + 1}."
        end
      end
      puts "Seeded sample products"
    end
  end
end
