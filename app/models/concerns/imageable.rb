
# Imageable concern provides image attachment functionality to models.
#
# This concern adds multiple image attachments with validation and variant generation
# capabilities to any ActiveRecord model that includes it.
#
# @example Including in a model
#   class Product < ApplicationRecord
#     include Imageable
#   end
#
# Constants:
#   ALLOWED_CONTENT_TYPES - Array of permitted image MIME types
#   MAX_IMAGE_SIZE_MB - Maximum file size limit (5 megabytes)
#   IMAGE_VARIANTS - Hash defining image variant dimensions:
#     - thumb: 100x100px
#     - small: 200x200px
#     - medium: 400x400px
#     - large: 800x800px
#
# Added Associations:
#   - images: has_many_attached with configured variants
#
# Added Validations:
#   - Content type must be PNG, JPEG, GIF, or WebP
#   - File size must be less than 5MB
#
# Instance Methods:
#   @method has_images?
#     @return [Boolean] true if model has attached images
#
#   @method images_count
#     @return [Integer] number of attached images
#
#   @method primary_image
#     @return [ActiveStorage::Attachment, nil] first attached image or nil
#
#   @method primary_thumb
#     @return [ActiveStorage::Variant, nil] thumbnail variant of primary image
#
#   @method primary_small
#     @return [ActiveStorage::Variant, nil] small variant of primary image
#
#   @method primary_medium
#     @return [ActiveStorage::Variant, nil] medium variant of primary image
#
#   @method primary_large
#     @return [ActiveStorage::Variant, nil] large variant of primary image
module Imageable
  extend ActiveSupport::Concern

  ALLOWED_CONTENT_TYPES = [ "image/png", "image/jpeg", "image/gif", "image/webp" ].freeze
  MAX_IMAGE_SIZE_MB = 5.megabytes

  IMAGE_VARIANTS = {
    thumb: { resize_to_limit: [ 100, 100 ] },
    small: { resize_to_limit: [ 200, 200 ] },
    medium: { resize_to_limit: [ 400, 400 ] },
    large: { resize_to_limit: [ 800, 800 ] }
  }

  included do
    has_many_attached :images, dependent: :destroy do |attachable|
      IMAGE_VARIANTS.each do |variant_name, processing_options|
        attachable.variant variant_name, **processing_options
      end
    end

    validates(
      :images,
      content_type: { in: ALLOWED_CONTENT_TYPES, message: "must be a valid image format (PNG, JPG, JPEG, GIF, WEBP)" },
      size: { less_than: MAX_IMAGE_SIZE_MB, message: "is too large. Maximum size allowed is #{MAX_IMAGE_SIZE_MB} MB." }
    )
  end

  def has_images?
    images.attached?
  end

  def images_count
    images.count
  end

  def primary_image
    images.first if has_images?
  end

  IMAGE_VARIANTS.keys.each do |variant_name|
    define_method("primary_#{variant_name}") do
      primary_image&.variant(variant_name) if has_images?
    end
  end
end
