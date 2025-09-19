# Seeds entry point. Loads common data and environment-specific data.
common_seed = Rails.root.join('db/seeds/common.rb')
load common_seed if File.exist?(common_seed)

env_seed = Rails.root.join("db/seeds/#{Rails.env}.rb")
load env_seed if File.exist?(env_seed)
