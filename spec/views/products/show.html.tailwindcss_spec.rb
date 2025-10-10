require 'rails_helper'

RSpec.describe "products/show", type: :view do
  let(:product) { create(:product) }
  let(:products) { [ product ] }

  before do
    assign(:product, product)
  end

  subject(:render_view) { render }

  it "renders the page title" do
    render_view
    expect(rendered).to have_content("Showing product")
  end

  it "renders the edit product link" do
    render_view
    expect(rendered).to have_link("Edit this product", href: edit_product_path(product))
  end

  it "renders the back to products link" do
    render_view
    expect(rendered).to have_link("Back to products", href: products_path)
  end

  it "renders the destroy product button" do
    render_view
    expect(rendered).to have_selector("form[action='#{product_path(product)}'][method='post']") do |form|
      expect(form).to have_selector("button", text: "Destroy this product")
    end
  end

  it_behaves_like "displays product details" do
    let(:products) { products }
  end
end
