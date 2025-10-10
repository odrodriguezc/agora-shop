module ProductHelpers
  def product_attributes(attrs = {})
    attributes_for(:product).merge(attrs)
  end

  def product_params(overrides = {})
    { product: product_attributes(overrides) }
  end

  def default_product_params
    product_params
  end

  def invalid_product_params
    product_params(
      title: "",
      sku: "",
      price: -1,
      stock_quantity: -5
    )
  end
end
