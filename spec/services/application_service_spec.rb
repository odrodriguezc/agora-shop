require 'rails_helper'

RSpec.describe ApplicationService, type: :service do
  describe "#call" do
    it "raises NotImplementedError when child class does not implement call" do
      service_class = Class.new(ApplicationService)
      expect { service_class.call }.to raise_error(NotImplementedError)
    end
  end
  describe "#fail!" do
    it "raises ServiceError with message, status and context" do
      service_class = Class.new(ApplicationService) do
        def call
          fail!("custom message", status: :bad_request, context: { detail: "extra info" })
        end
      end

      expect { service_class.call }.to raise_error do |error|
        expect(error).to be_a(ApplicationService::ServiceError)
        expect(error.message).to eq("custom message")
        expect(error.status).to eq(:bad_request)
        expect(error.context).to eq({ detail: "extra info" })
      end
    end

    it "defaults status to :internal_server_error and context to empty hash" do
      service_class = Class.new(ApplicationService) do
        def call
          fail!("default error")
        end
      end

      expect { service_class.call }.to raise_error do |error|
        expect(error).to be_a(ApplicationService::ServiceError)
        expect(error.message).to eq("default error")
        expect(error.status).to eq(:internal_server_error)
        expect(error.context).to eq({})
      end
    end
  end

  describe "#success" do
    it "returns provided payload" do
      service_class = Class.new(ApplicationService) do
        def call
          success("all good")
        end
      end

      result = service_class.call
      expect(result).to eq("all good")
    end

    it "returns true when no payload is provided" do
      service_class = Class.new(ApplicationService) do
        def call
          success
        end
      end

      result = service_class.call
      expect(result).to be true
    end
  end

  describe "ServiceError" do
    it "defines ServiceError as a subclass of StandardError" do
      expect(ApplicationService::ServiceError).to be < StandardError
    end
  end
end
