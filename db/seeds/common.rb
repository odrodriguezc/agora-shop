# Data required across all environments.
Dir[Rails.root.join('db/seeds/support/common_*.rb')].sort.each { |path| load path }

CommonSeeds::RoleSeeder.run
