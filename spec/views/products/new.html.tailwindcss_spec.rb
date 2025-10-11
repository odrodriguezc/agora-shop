require 'rails_helper'

RSpec.describe "products/new", type: :view do
  let(:product) { build(:product) }

  before do
    assign(:product, product)
    assign(:categories, create_list(:category, 3))
  end

  subject(:render_view) { render }

  it "renders new product form" do
    render_view
    expect(rendered).to have_selector("form[action='#{products_path}'][method='post']")
  end
end
