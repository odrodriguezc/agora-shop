# This shared example group is used to test the behavior of the "categories index" action
# in a controller. It verifies that the response is correct and that the categories are
# properly displayed or returned in the specified format.
#
# @param format [Symbol] The format of the response (:html or :json).
#
# Example usage:
#   it_behaves_like "shows categories", format: :html
#   it_behaves_like "shows categories", format: :json
#
# Expectations:
# - For both formats:
#   - The request renders the index page with an HTTP status of 200 (OK).
#   - The `@categories` instance variable contains the expected categories.
# - For :html format:
#   - No additional expectations are defined.
# - For :json format:
#   - The response body contains a JSON array with the list of categories.
#   - Each category in the JSON response matches the expected attributes (id, name).
#
# Raises:
# - ArgumentError if an unsupported format is provided.
RSpec.shared_examples "shows categories" do |format:|
  it "renders the index page" do
    perform_request.call
    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:index)
  end
  it "displays all categories" do
    perform_request.call
    expect(assigns(:categories)).to match_array(categories)
  end

  case format
  when :html
  when :json
    it "returns JSON with categories list" do
      perform_request.call
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(categories.size)
      categories.each_with_index do |category, index|
        expect(json_response[index]["id"]).to eq(category.id)
        expect(json_response[index]["name"]).to eq(category.name)
      end
    end
  else
    raise ArgumentError, "Unsupported format: #{format}"
  end
end
