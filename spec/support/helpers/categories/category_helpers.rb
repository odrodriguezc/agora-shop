module CategoryHelpers
  def category_attributes(attrs = {})
    attributes_for(:category).merge(attrs)
  end

  def category_params(overrides = {})
    { category: category_attributes(overrides) }
  end

  def default_category_params
    category_params
  end

  def invalid_category_params
    category_params(
      name: ""
    )
  end
end
