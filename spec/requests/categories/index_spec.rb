
require 'rails_helper'

RSpec.describe "GET /categories", type: :request do
  let(:perform_request) { -> { get categories_url(format: request_format) } }
  let!(:categories) { create_list(:category, 3) } # Ensure categories are created before each test

  context "when format is HTML" do
    let(:request_format) { :html }
    context "when user is not authenticated" do
      include_context "as unauthenticated user"
      it_behaves_like "shows categories", format: :html
    end
    context "when user is a guest" do
      include_context "as guest user"
      it_behaves_like "shows categories", format: :html
    end

    context "when user is a admin user" do
      include_context "as admin user"
      it_behaves_like "shows categories", format: :html
    end
  end

  context "when format is JSON" do
    let(:request_format) { :json }
    context "when user is not authenticated" do
      include_context "as unauthenticated user"
      it_behaves_like "shows categories", format: :json
    end
    context "when user is a guest" do
      include_context "as guest user"
      it_behaves_like "shows categories", format: :json
    end
    context "when user is a admin user" do
      include_context "as admin user"
      it_behaves_like "shows categories", format: :json
    end
  end
end
