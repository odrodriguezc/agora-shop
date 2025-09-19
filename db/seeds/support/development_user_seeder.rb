module DevelopmentSeeds
  class UserSeeder
    def self.run
      new.run
    end

    def run
      master_user = seed_master_user
      assign_admin_role(master_user)
      seed_dummy_users
    end

    private

    def seed_master_user
      User.find_or_create_by!(email_address: "master@example.com") do |user|
        user.full_name = "master"
        user.password = "password_123"
      end.tap do
        puts "Seeded master user (email_address: master@example.com)"
      end
    end

    def assign_admin_role(master_user)
      return if master_user.has_role?(:admin)

      master_user.add_role(:admin)
      puts "Seeded admin role to master user"
    end

    def seed_dummy_users
      [:one, :two, :three].each do |dummy_user|
        User.find_or_create_by!(email_address: "#{dummy_user}@example.com") do |user|
          user.full_name = dummy_user.to_s.capitalize
          user.password = "password_123"
        end
      end
      puts "Seeded dummy users"
    end
  end
end
