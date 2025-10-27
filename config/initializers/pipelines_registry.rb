Rails.application.config.to_prepare do
  # Pipeline: ProductsFromCSVToLogger
  Importing::Pipelines::Registry.register(
    Importing::Pipelines::ProductsFromCSVToLogger::REGISTER_KEY,
    Importing::Pipelines::ProductsFromCSVToLogger
  )

  # Pippeline: ProductsFromCSVToDatabase
  Importing::Pipelines::Registry.register(
    Importing::Pipelines::ProductsFromCSVToDatabase::REGISTER_KEY,
    Importing::Pipelines::ProductsFromCSVToDatabase
  )
end
