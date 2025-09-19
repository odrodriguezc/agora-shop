# Development-only sample data to make local testing easier.
Dir[Rails.root.join('db/seeds/support/**/*.rb')].sort.each { |path| load path }

DevelopmentSeeds::UserSeeder.run
DevelopmentSeeds::ProductSeeder.run
