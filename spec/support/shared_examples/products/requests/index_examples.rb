
# This shared example tests the behavior of an index page for products.
# It verifies that the response has an HTTP status of 200 (OK) and checks
# the content of the response based on the specified format (:html or :json).
#
# Parameters:
# - format: The format of the response to test (:html or :json).
#
# Behavior:
# - For :html format:
#   - Ensures that the response body includes the title of each product.
# - For :json format:
#   - Ensures that the response contains the correct number of products.
#   - Verifies that each product in the response includes the expected attributes
#     (id, title, and sku).
#
# Raises:
# - ArgumentError: If an unsupported format is provided.
RSpec.shared_examples "shows index page" do |format:|
  it "retrieves and displays the list of products" do
    perform_request.call
    expect(response).to have_http_status(:ok)

    case format
    when :html
      products.each do |product|
        expect(response.body).to include(product.title)
      end
    when :json
      expect(response.parsed_body.size).to eq(products.size)
      products.each_with_index do |product, index|
        expect(response.parsed_body[index]).to include(
          "id" => product.id,
          "title" => product.title,
          "sku" => product.sku
        )
      end
    else
      raise ArgumentError, "Unsupported format: #{format}"
    end
  end
end
