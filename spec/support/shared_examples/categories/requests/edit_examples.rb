# This shared example group is used to test the behavior of the "edit category" page.
# It ensures that the page renders successfully and displays the correct category.
#
# @param format [Symbol] (optional) The format in which the request is made (e.g., :html, :json).
#
# Example usage:
# RSpec.describe "CategoriesController", type: :request do
#   include_examples "shows edit category page", format: :html do
#     let(:perform_request) { -> { get edit_category_path(category) } }
#     let(:created_category) { create(:category) }
#   end
# end
RSpec.shared_examples "shows edit category page" do |format:|
  let(:category) { created_category }
  it "renders the edit page" do
    perform_request.call
    expect(response).to have_http_status(:ok)
    expect(response).to render_template(:edit)
  end

  it "displays the correct category" do
    perform_request.call
    expect(assigns(:category)).to eq(category)
  end
end
