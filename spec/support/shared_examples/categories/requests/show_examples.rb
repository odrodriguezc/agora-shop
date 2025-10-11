# This shared example group is used to test the successful display of a category
# in different formats (e.g., HTML, JSON). It includes tests for rendering the
# correct template, assigning the correct category, and returning the appropriate
# response format.
#
# @param format [Symbol] The format in which the response is expected (:html or :json).
# @example Usage with HTML format
#   it_behaves_like "shows category successfully", format: :html
# @example Usage with JSON format
#   it_behaves_like "shows category successfully", format: :json
RSpec.shared_examples "shows category successfully" do |format:|
  it "renders the show page" do
    perform_request.call
    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:show)
  end

  it "displays the correct category" do
    perform_request.call
    expect(assigns(:category)).to eq(category)
  end

  case format
  when :html
  when :json
    it "returns JSON with category details" do
      perform_request.call
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(category.id)
      expect(json_response["name"]).to eq(category.name)
    end
  else
    raise ArgumentError, "Unsupported format: #{format}"
  end
end
