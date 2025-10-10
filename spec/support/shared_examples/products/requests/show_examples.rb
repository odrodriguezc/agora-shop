# This shared example tests the successful retrieval and display of product details
# for a given response format (:html or :json).
#
# @param format [Symbol] The response format to test (:html or :json).
#   - :html: Verifies that the product title is included in the response body.
#   - :json: Verifies that the response body contains the product's attributes
#            such as id, title, description, price, stock_quantity, and sku.
#
# Usage:
#   include_examples "shows product successfully", format: :html
#   include_examples "shows product successfully", format: :json
#
# Raises:
#   ArgumentError: If an unsupported format is provided.

RSpec.shared_examples "shows product successfully" do |format:|
  it "retrieves and displays the product details" do
    perform_request.call
    expect(response).to have_http_status(:ok)

    case format
    when :html
      expect(response.body).to include(product.title)
    when :json
      expect(response.parsed_body).to include(
        "id" => product.id,
        "title" => product.title,
        "description" => product.description,
        "price" => product.price.to_s,
        "stock_quantity" => product.stock_quantity,
        "sku" => product.sku
      )
    else
      raise ArgumentError, "Unsupported format: #{format}"
    end
  end
end
