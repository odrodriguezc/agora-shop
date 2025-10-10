
# This file contains shared examples for RSpec tests related to updating products.
#
# Shared Examples:
#
# 1. "updates product successfully":
#    - Verifies that a product is updated successfully and the response is appropriate
#      based on the specified format (:html or :json).
#    - Ensures the product's attributes are updated in the database.
#    - Parameters:
#      - format: The response format (:html or :json).
#
# 2. "rejects invalid product update":
#    - Ensures that invalid product updates are rejected and appropriate validation
#      feedback is returned based on the specified format (:html or :json).
#    - Verifies that the product's attributes remain unchanged in the database.
#    - Parameters:
#      - format: The response format (:html or :json).
RSpec.shared_examples "updates product successfully" do |format:|
  let(:expected_flash_notice) { "Product was successfully updated." }

  it "updates the product and responds appropriately" do
    perform_request.call

    case format
    when :html
      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(product_url(existing_product))
      expect(flash[:notice]).to eq(expected_flash_notice)
    when :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to include(
        "id" => existing_product.id,
        "title" => "Updated Product Title",
        "price" => "19.99"
      )
    else
      raise ArgumentError, "Unsupported format: #{format}"
    end

    existing_product.reload
    expect(existing_product.title).to eq("Updated Product Title")
    expect(existing_product.price).to eq(19.99)
  end
end

RSpec.shared_examples "rejects invalid product update" do |format:|
  let(:perform_invalid_request) { -> { patch product_url(existing_product, format: format), params: invalid_params } }

  it "does not update the product and returns validation feedback" do
    perform_invalid_request.call

    case format
    when :html
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Editing product")
    when :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body).to have_key("title")
    else
      raise ArgumentError, "Unsupported format: #{format}"
    end

    existing_product.reload
    expect(existing_product.title).not_to eq("")
    expect(existing_product.price).not_to eq(-5)
  end
end
