class Session < ApplicationRecord
  include HasPublicUuid

  belongs_to :user
end
