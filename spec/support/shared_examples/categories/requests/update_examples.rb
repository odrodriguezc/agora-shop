# This file contains shared examples for testing the behavior of updating a category
# in different formats (:html and :json) within RSpec request specs.
#
# Shared Examples:
#
# 1. "updates category successfully":
#    - Verifies that a category is updated successfully and the response is appropriate
#      based on the specified format.
#    - Parameters:
#      - format: The response format (:html or :json).
#    - Expectations:
#      - For :html:
#        - Response status is :see_other or :found.
#        - Redirects to the updated category's URL.
#        - Flash notice confirms the update.
#      - For :json:
#        - Response status is :ok.
#        - Response body includes the updated category's details.
#      - The category's name is updated in the database.
#
# 2. "rejects invalid category update":
#    - Verifies that an invalid category update is rejected and appropriate validation
#      feedback is returned based on the specified format.
#    - Parameters:
#      - format: The response format (:html or :json).
#    - Expectations:
#      - For :html:
#        - Response status is :unprocessable_entity.
#        - Response body includes the "Editing category" form.
#      - For :json:
#        - Response status is :unprocessable_entity.
#        - Response body includes validation errors for the "name" field.
#      - The category's name remains unchanged in the database.
#
# Usage:
# Include these shared examples in your RSpec request specs to test category update
# functionality for both valid and invalid scenarios across different formats.
RSpec.shared_examples "updates category successfully" do |format:|
  let(:expected_flash_notice) { "Category was successfully updated." }

  it "updates the category and responds appropriately" do
    perform_request.call

    case format
    when :html
      expect(response).to have_http_status(:see_other).or have_http_status(:found)
      expect(response).to redirect_to(category_url(existing_category))
      expect(flash[:notice]).to eq(expected_flash_notice)
    when :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include(
        "id" => existing_category.id,
        "name" => "Updated Category Name"
      )
    else
      raise ArgumentError, "Unsupported format: #{format}"
    end

    existing_category.reload
    expect(existing_category.name).to eq("Updated Category Name")
  end
end

RSpec.shared_examples "rejects invalid category update" do |format:|
  let(:perform_invalid_request) { -> { patch category_url(existing_category, format: format), params: invalid_params } }

  it "does not update the category and returns validation feedback" do
    perform_invalid_request.call

    case format
    when :html
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Editing category")
    when :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body).to have_key("name")
    else
      raise ArgumentError, "Unsupported format: #{format}"
    end

    existing_category.reload
    expect(existing_category.name).not_to eq("")
  end
end
