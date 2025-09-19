module CommonSeeds
  class RoleSeeder
    DEFAULT_ROLES = %w[admin guest customer].freeze

    def self.run
      new.run
    end

    def run
      DEFAULT_ROLES.each do |role_name|
        Role.find_or_create_by!(name: role_name)
      end
      puts "Seeded default roles: #{DEFAULT_ROLES.join(', ')}"
    end
  end
end
