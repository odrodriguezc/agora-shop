
# This file contains shared examples for RSpec tests related to creating products.
#
# Shared Examples:
#
# 1. "creates product successfully":
#    - Verifies that a product is created successfully and the response is appropriate.
#    - Parameters:
#      - format: The response format (:html or :json).
#    - Behavior:
#      - For :html format:
#        - Expects the response to redirect to the created product's URL.
#        - Expects a success flash message.
#      - For :json format:
#        - Expects the response to have HTTP status :created.
#        - Expects the response headers to include the location of the created product.
#        - Expects the response body to include the created product's ID.
#      - Raises an error for unsupported formats.
#
# 2. "rejects invalid product":
#    - Verifies that a product is not created when invalid parameters are provided.
#    - Parameters:
#      - format: The response format (:html or :json).
#    - Behavior:
#      - Ensures no change in the Product count.
#      - Expects the response to have HTTP status :unprocessable_entity.
#      - Raises an error for unsupported formats.
RSpec.shared_examples "creates product successfully" do |format:|
  it "creates a product and responds appropriately" do
    expect {
      post products_url(format: format, params: valid_params)
    }.to change(Product, :count).by(1)

    case format
    when :html
      expect(response).to redirect_to(product_url(created_product))
      expect(flash[:notice]).to eq("Product was successfully created.")
    when :json
      expect(response).to have_http_status(:created)
      expect(response.headers['Location']).to eq(product_url(created_product))
      expect(response.parsed_body).to include("id" => created_product.id)
    else
      raise ArgumentError, "Unsupported format: #{format}"
    end
  end
end

RSpec.shared_examples "rejects invalid product" do |format:|
  it "does not create a product and returns validation feedback" do
    expect {
      post products_url(format: format, params: invalid_params)
    }.not_to change(Product, :count)

    raise ArgumentError, "Unsupported format: #{format}" unless [ :html, :json ].include?(format)
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
