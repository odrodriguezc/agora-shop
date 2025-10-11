module DevelopmentSeeds
  class CategorySeeder
    def self.run
      new.run
    end

    def run
      2.times do |i|
        Category.find_or_create_by!(name: "Category #{i + 1}") do |category|
          category.description = "This is a description for Category #{i + 1}."
        end
      end
      puts "Seeded sample categories"
    end
  end
end
