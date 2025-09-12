module HasPublicUuid
  extend ActiveSupport::Concern

  # Use uuid as the parameter in URLs instead of the default id
  included do
    def to_param
      uuid
    end
  end
end
