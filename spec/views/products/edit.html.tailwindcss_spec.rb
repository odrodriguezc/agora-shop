require 'rails_helper'

RSpec.describe "products/edit", type: :view do
  let(:product) { create(:product) }

  before do
    assign(:product, product)
    assign(:categories, create_list(:category, 3))
  end


  it "renders the edit product form" do
    render

    assert_select "form[action=?][method=?]", product_path(product), "post" do
    end
  end
end
