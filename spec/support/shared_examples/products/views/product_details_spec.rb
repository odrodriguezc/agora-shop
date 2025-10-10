
# This shared example tests the rendering of product details for a given set of products.
# It ensures that the key attributes of each product are displayed correctly in the rendered view.
#
# @param products [Array<Product>] (default: []) A list of product objects to be tested.
#
# Example usage:
#   it_behaves_like "displays product details", products: [product1, product2]
#
# Expectations:
# - For each product in the `products` array:
#   - The partial "products/product" is rendered with the product as a local variable.
#   - The DOM element with the product's ID (generated using `ActionView::RecordIdentifier.dom_id`) is present.
#   - The product's title, description, price, stock quantity, and SKU are displayed within the DOM element.
RSpec.shared_examples "displays product details" do |products: []|
  it "renders the product's key attributes" do
    Array(products).each do |p|
      render partial: "products/product", locals: { product: p }

      dom_id = ActionView::RecordIdentifier.dom_id(p)

      assert_select "##{dom_id}" do
        assert_select "p", text: /#{Regexp.escape(p.title)}/
        assert_select "p", text: /#{Regexp.escape(p.description)}/
        assert_select "p", text: /#{Regexp.escape(p.price)}/
        assert_select "p", text: /#{Regexp.escape(p.stock_quantity.to_s)}/
        assert_select "p", text: /#{Regexp.escape(p.sku)}/
      end
    end
  end
end
