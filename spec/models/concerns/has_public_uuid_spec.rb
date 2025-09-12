RSpec.shared_examples "has public uuid", type: :model do
  # This shared example assumes that the model including this concern has a `uuid` attribute
  # It also assumes that the uuid is generated using pgcrypto's gen_random_uuid function

  describe "has uuid attribute" do
    it "responds to uuid" do
      expect(model_instance).to respond_to(:uuid)
    end

    it "to_params methods returns the uuid" do
      expect(model_instance.to_param).to eq(model_instance.uuid)
    end
  end
end
