# This shared example group tests the successful destruction of a category.
# It includes the following examples:
# - Verifies that the specified category is deleted, ensuring the Category count decreases by 1.
# - Ensures the response redirects to the categories URL after the category is destroyed.
#
# Usage:
# Include this shared example in your RSpec tests for actions that destroy a category.
# Example:
#   it_behaves_like "destroys category successfully" do
#     let(:perform_request) { -> { delete :destroy, params: { id: category.id } } }
#   end
RSpec.shared_examples "destroys category successfully" do
  it "deletes the specified category" do
    expect {
      perform_request.call
    }.to change(Category, :count).by(-1)
  end

  it "redirects to categories" do
    perform_request.call
    expect(response).to redirect_to(categories_url)
  end
end
