require 'rails_helper'

RSpec.describe Imageable, type: :model do
  # Create a proper stub class before the tests run
  before(:all) do
    # Create a test table in the database
    ActiveRecord::Schema.define do
      create_table :test_imageable_models, force: true do |t|
        t.string :name
        t.timestamps
      end
    end

    # Define the stub class
    class TestImageableModel < ApplicationRecord
      include Imageable
    end
  end

  # Clean up after all tests
  after(:all) do
    ActiveRecord::Schema.define do
      drop_table :test_imageable_models, if_exists: true
    end

    # Remove the class constant
    Object.send(:remove_const, :TestImageableModel) if defined?(TestImageableModel)
  end

  # Clean up records after each test
  after(:each) do
    TestImageableModel.destroy_all
  end

  let(:test_instance) { TestImageableModel.create!(name: 'Test') }

  describe 'constants' do
    it 'defines ALLOWED_CONTENT_TYPES' do
      expect(Imageable::ALLOWED_CONTENT_TYPES).to eq([ "image/png", "image/jpeg", "image/gif", "image/webp" ])
    end

    it 'defines MAX_IMAGE_SIZE_MB' do
      expect(Imageable::MAX_IMAGE_SIZE_MB).to eq(5.megabytes)
    end

    it 'defines IMAGE_VARIANTS' do
      expect(Imageable::IMAGE_VARIANTS).to include(
        thumb: { resize_to_limit: [ 100, 100 ] },
        small: { resize_to_limit: [ 200, 200 ] },
        medium: { resize_to_limit: [ 400, 400 ] },
        large: { resize_to_limit: [ 800, 800 ] }
      )
    end
  end

  describe 'associations' do
    it 'has many attached images' do
      expect(test_instance).to respond_to(:images)
      expect(test_instance.images).to be_a(ActiveStorage::Attached::Many)
    end
  end

  describe 'validations' do
    it 'validates content type' do
      file = fixture_file_upload('spec/fixtures/files/test.txt', 'text/plain')
      test_instance.images.attach(file)
      test_instance.valid?
      expect(test_instance).not_to be_valid
      expect(test_instance.errors[:images]).to include("must be a valid image format (PNG, JPG, JPEG, GIF, WEBP)")
    end

    it 'validates file size' do
      large_file = Tempfile.new([ 'large_image', '.jpg' ])
      large_file.write('x' * 6.megabytes)
      large_file.rewind

      uploaded_file = ActionDispatch::Http::UploadedFile.new(
        tempfile: large_file,
        filename: 'large_image.jpg',
        type: 'image/jpeg'
      )
      test_instance.images.attach(uploaded_file)
      test_instance.valid?
      expect(test_instance).not_to be_valid
      expect(test_instance.errors[:images]).to be_present
    end
  end

  describe '#has_images?' do
    context 'when images are attached' do
      it 'returns true' do
        file = fixture_file_upload('spec/fixtures/files/test_image.jpg', 'image/jpeg')
        test_instance.images.attach(file)
        expect(test_instance.has_images?).to be true
      end
    end

    context 'when no images are attached' do
      it 'returns false' do
        expect(test_instance.has_images?).to be false
      end
    end
  end

  describe '#images_count' do
    it 'returns 0 when no images are attached' do
      expect(test_instance.images_count).to eq(0)
    end

    it 'returns the correct count when images are attached' do
      file1 = fixture_file_upload('spec/fixtures/files/test_image.jpg', 'image/jpeg')
      file2 = fixture_file_upload('spec/fixtures/files/test_image.jpg', 'image/jpeg')
      test_instance.images.attach([ file1, file2 ])
      expect(test_instance.images_count).to eq(2)
    end
  end

  describe '#primary_image' do
    context 'when images are attached' do
      it 'returns the first image' do
        file = fixture_file_upload('spec/fixtures/files/test_image.jpg', 'image/jpeg')
        test_instance.images.attach(file)
        expect(test_instance.primary_image).to eq(test_instance.images.first)
      end
    end

    context 'when no images are attached' do
      it 'returns nil' do
        expect(test_instance.primary_image).to be_nil
      end
    end
  end

 describe 'dynamic variant methods' do
   it 'defines methods :primary_thubm, :primary_small, :primary_medium, :primary_large' do
     [ :primary_thumb, :primary_small, :primary_medium, :primary_large ].each do |method_name|
       expect(test_instance).to respond_to(method_name)
     end
   end
    context 'with attached images' do
      let(:file) { fixture_file_upload('spec/fixtures/files/test_image.jpg', 'image/jpeg') }

      before { test_instance.images.attach(file) }

      it 'primary_thumb returns a variant' do
        expect(test_instance.primary_thumb).to be_present
      end
    end

    context 'without attached images' do
      it 'primary_thumb returns nil' do
        expect(test_instance.primary_thumb).to be_nil
      end
    end
  end
end
