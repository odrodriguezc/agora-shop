# The `Users::Onboard` service is responsible for managing the onboarding process
# for a user. It ensures that all necessary steps are executed in a consistent
# and organized manner. The onboarding process includes:
#
# - Assigning a default role to the user by invoking `Users::AssignDefaultRole`.
# - Sending a welcome email to the user by invoking `Users::SendWelcomeEmail`.
#
# This service is designed to encapsulate the onboarding logic, making it easier
# to maintain and extend in the future.
# The `Users::Onboard` service is responsible for handling the onboarding process
# for a user. It performs the following actions:
# - Sends a welcome email to the user by invoking `Users::SendWelcomeEmail`.
#
# This service is intended to encapsulate the logic for onboarding a user,
# ensuring that all necessary steps are performed in a consistent manner.
module Users
  class Onboard < Users::Base
    def call
      Users::AssignDefaultRole.call(user)
      Users::SendWelcomeEmail.call(user)
    end
  end
end
