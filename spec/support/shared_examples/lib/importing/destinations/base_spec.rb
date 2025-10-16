require 'rails_helper'
RSpec.shared_examples 'a importing destination base' do |options = {}|
  subject(:destination) { described_class.new(options) }
  let(:model) { Class.new(ApplicationRecord) }

  context "when write is not implemented" do
    let(:custom_destination) { Class.new(Importing::Destinations::Base) do
    end.new(model: model) }
    it "raises NotImplementedError when write is called" do
      expect { custom_destination.write(data: "sample data") }.to raise_error(NotImplementedError)
    end
  end

  context "when write is implemented" do
    let(:custom_destination) { Class.new(Importing::Destinations::Base) do
      def write(data:)
        "Written: #{data}"
      end
    end.new(model: model)}
    it "successfully writes data" do
      result = custom_destination.write(data: "sample data")
      expect(result).to eq("Written: sample data")
    end
  end

  context "when model option is missing or invalid" do
    it "raises ArgumentError if model is not provided" do
      expect { described_class.new() }.to raise_error(ArgumentError, /A valid ActiveRecord model class must be provided in :model option/)
    end

    it "raises ArgumentError if model is not an ActiveRecord class" do
      expect { described_class.new(model: "NotAClass") }.to raise_error(ArgumentError, /A valid ActiveRecord model class must be provided in :model option/)
    end
  end
end
