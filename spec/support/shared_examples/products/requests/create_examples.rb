

# This file contains shared examples for testing product creation requests in RSpec.
#
# Shared Examples:
#
# 1. "creates product successfully with out category":
#    - Tests the successful creation of a product without a category.
#    - Parameters:
#      - `format:`: The response format (:html or :json).
#    - Verifies:
#      - Product count increases by 1.
#      - Response behavior based on the format:
#        - :html: Redirects to the product URL with a success flash message.
#        - :json: Returns HTTP status 201 (created) with the product's location and ID.
#      - Raises an error for unsupported formats.
#
# 2. "creates product successfully with category":
#    - Tests the successful creation of a product with an associated category.
#    - Parameters:
#      - `format:`: The response format (:html or :json).
#    - Verifies:
#      - Product count increases by 1.
#      - The created product is associated with the specified category.
#      - Response behavior based on the format:
#        - :html: Redirects to the product URL.
#        - :json: Returns HTTP status 201 (created) with the category ID.
#      - Raises an error for unsupported formats.
#
# 3. "rejects invalid product":
#    - Tests the rejection of invalid product creation requests.
#    - Parameters:
#      - `format:`: The response format (:html or :json).
#    - Verifies:
#      - Product count does not change.
#      - Response has HTTP status 422 (unprocessable entity).
#      - Raises an error for unsupported formats.
RSpec.shared_examples "creates product successfully with out category" do |format:|
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

RSpec.shared_examples "creates product successfully with category" do |format:|
  it "creates a product and responds appropriately" do
    category # ensure category is created
    valid_params[:product][:category_id] = category.id
    expect {
      post products_url(format: format, params: valid_params)
    }.to change(Product, :count).by(1)
    created_product.reload

    expect(created_product.category).to eq(category)
    case format
    when :html
      expect(response).to redirect_to(product_url(created_product))
    when :json
      expect(response).to have_http_status(:created)
      expect(response.parsed_body).to include("category_id" => category.id)
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
