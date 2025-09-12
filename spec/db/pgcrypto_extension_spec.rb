require 'rails_helper'

RSpec.describe "PostgreSQL pgcrypto extension", type: :db do
  context "when checking for pgcrypto extension" do
    it "has pgcrypto extension enabled" do
      # Query PostgreSQL's system catalogs to check if the extension is enabled
      result = ActiveRecord::Base.connection.execute(
        "SELECT 1 FROM pg_extension WHERE extname = 'pgcrypto'"
        )

        # The extension is enabled if the query returns any rows
        expect(result.any?).to be(true), "The pgcrypto extension is not enabled in the database"
    end
  end
end
