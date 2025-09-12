class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # uuid attribute is used for public URLs instead of the numeric id
  include HasPublicUuid
end
