require 'rails_helper'

RSpec.describe "products/index", type: :view do
  before do
    assign(:products, products)
  end

  it_behaves_like "displays product details" do
    let(:products) { create_list(:product, 3) }
  end
end
