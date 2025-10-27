require 'csv'
path = File.expand_path("../data/imports/products_to_import.csv", __dir__)
CSV.open(path, "wb") do |csv|
  csv << [ "id", "Title", "Description", "Price",  "Stock Quantity", "external_id" ]
  (1..1000).each do |i|
    i += 1000
    csv << [ i, "Product I-#{i}", "Description for Product #{i}", "#{i * 10}.99", "#{i * 100}", "aaa-#{i.to_s.rjust(3, '0')}" ]
  end
end
