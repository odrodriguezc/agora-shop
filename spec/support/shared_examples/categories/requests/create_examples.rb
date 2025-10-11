# This file contains shared examples for RSpec tests related to creating categories.
#
# Shared Examples:
#
# 1. "creates category successfully":
#    - Verifies that a category is successfully created and the response is appropriate.
#    - Parameters:
#      - format: The response format (:html or :json).
#    - Behavior:
#      - For :html format:
#        - Expects the response to redirect to the created category's URL.
#        - Expects a success flash message.
#      - For :json format:
#        - Expects the response to have HTTP status 201 (created).
#        - Expects the response headers to include the location of the created category.
#        - Expects the response body to include the created category's ID.
#      - Raises an error for unsupported formats.
#
# 2. "rejects invalid category":
#    - Verifies that a category is not created when invalid parameters are provided.
#    - Parameters:
#      - format: The response format (:html or :json).
#    - Behavior:
#      - Ensures the category count does not change.
#      - Expects the response to have HTTP status 422 (unprocessable entity).
#      - Raises an error for unsupported formats.
RSpec.shared_examples "creates category successfully" do |format:|
  it "creates a category and responds appropriately" do
    expect {
      post categories_url(format: format, params: valid_params)
    }.to change(Category, :count).by(1)

    case format
    when :html
      expect(response).to redirect_to(category_url(Category.last))
      expect(flash[:notice]).to eq("Category was successfully created.")
    when :json
      expect(response).to have_http_status(:created)
      expect(response.headers['Location']).to eq(category_url(Category.last))
      expect(response.parsed_body).to include("id" => Category.last.id)
    else
      raise ArgumentError, "Unsupported format: #{format}"
    end
  end
end

RSpec.shared_examples "rejects invalid category" do |format:|
  it "does not create a category and returns validation feedback" do
    expect {
      post categories_url(format: format, params: invalid_params)
    }.not_to change(Category, :count)

    raise ArgumentError, "Unsupported format: #{format}" unless [ :html, :json ].include?(format)
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
