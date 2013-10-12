# encoding: UTF-8

# delivery services

ds = Shoppe::DeliveryService.create!(:name => "Royal Mail (1st class)", :code => 'RMFC', :courier => 'Royal Mail', :tracking_url => 'http://royalmail.com/track/{{consignment_number}}')
ds.delivery_service_prices.create!(:min_weight => 0, :max_weight => 0.050, :price => 0.60, :tax_rate => 0.0)


ds = Shoppe::DeliveryService.create!(:name => "Royal Mail (signed for)", :code => 'RMSF', :courier => 'Royal Mail', :tracking_url => 'http://royalmail.com/track/{{consignment_number}}')
ds.delivery_service_prices.create!(:min_weight => 0, :max_weight => 1, :price => 5.0, :tax_rate => 20.0)
ds.delivery_service_prices.create!(:min_weight => 1, :max_weight => 5, :price => 8.0, :tax_rate => 20.0)
ds.delivery_service_prices.create!(:min_weight => 5, :max_weight => 10, :price => 10.0, :tax_rate => 20.0)
ds.delivery_service_prices.create!(:min_weight => 10, :max_weight => 25, :price => 12.0, :tax_rate => 20.0)
ds.delivery_service_prices.create!(:min_weight => 25, :max_weight => 50, :price => 16.25, :tax_rate => 20.0)

ds = Shoppe::DeliveryService.create!(:name => "Next Day Delivery (before 4pm)",  :default => true, :code => 'ND16', :courier => 'UPS', :tracking_url => 'http://trackingurl.com/track/{{consignment_number}}')
ds.delivery_service_prices.create!(:min_weight => 0, :max_weight => 1, :price => 7.0, :tax_rate => 20.0)
ds.delivery_service_prices.create!(:min_weight => 1, :max_weight => 5, :price => 9.0, :tax_rate => 20.0)
ds.delivery_service_prices.create!(:min_weight => 5, :max_weight => 20, :price => 11.50, :tax_rate => 20.0)

ds = Shoppe::DeliveryService.create!(:name => "Next Day Delivery (before 10am)", :code => 'NS10', :courier => 'UPS', :tracking_url => 'http://trackingurl.com/track/{{consignment_number}}')
ds.delivery_service_prices.create!(:min_weight => 0, :max_weight => 1, :price => 17.0, :tax_rate => 20.0)
ds.delivery_service_prices.create!(:min_weight => 1, :max_weight => 5, :price => 19.0, :tax_rate => 20.0)
ds.delivery_service_prices.create!(:min_weight => 5, :max_weight => 20, :price => 27.0, :tax_rate => 20.0)

ds = Shoppe::DeliveryService.create!(:name => "Saturday Delivery", :code => 'NDSA16', :courier => 'UPS', :tracking_url => 'http://trackingurl.com/track/{{consignment_number}}')
ds.delivery_service_prices.create!(:min_weight => 0, :max_weight => 1, :price => 27.0, :tax_rate => 20.0)
ds.delivery_service_prices.create!(:min_weight => 1, :max_weight => 5, :price => 29.0, :tax_rate => 20.0)
ds.delivery_service_prices.create!(:min_weight => 5, :max_weight => 20, :price => 37.0, :tax_rate => 20.0)

# categories
cat1 = Shoppe::ProductCategory.create!(:name => 'VoIP Phones')
cat2 = Shoppe::ProductCategory.create!(:name => 'VoIP Accessories')
cat3 = Shoppe::ProductCategory.create!(:name => 'Network Eqipment')

def get_file(name, content_type = 'image/jpeg')
  file = ActionDispatch::Http::UploadedFile.new(:tempfile => File.open(File.join(Shoppe.root, 'db', 'seeds_data', name), 'rb'))
  file.original_filename = name
  file.content_type = content_type
  file
end

lorem = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

pro = cat1.products.create!(:title => 'Yealink T20P', :sku => 'YL-SIP-T20P', :description => lorem, :short_description => 'If cheap & cheerful is what you’re after, the Yealink T20P is what you’re looking for.', :weight => 1.119, :price => 54.99, :tax_rate => 20.0, :stock => 20, :featured => true)
pro.default_image_file = get_file('t20p.jpg')
pro.save!
pro.product_attributes.update_from_hash('Manufacturer' => 'Yealink', 'Model' => 'T20P', 'Colour' => 'Black', 'Lines' => '3', 'Colour Screen' => 'No', 'Power over ethernet' => 'Yes')

pro = cat1.products.create!(:title => 'Yealink T22P', :sku => 'YL-SIP-T22P', :description => lorem, :short_description => lorem, :weight => 1.419, :price => 64.99, :tax_rate => 20.0, :stock => 12)
pro.default_image_file = get_file('t22p.jpg')
pro.save!
pro.product_attributes.update_from_hash('Manufacturer' => 'Yealink', 'Model' => 'T20P', 'Colour' => 'Black', 'Lines' => '3', 'Colour Screen' => 'No', 'Power over ethernet' => 'Yes')

pro = cat1.products.create!(:title => 'Yealink T26P', :sku => 'YL-SIP-T26P', :description => lorem, :short_description => lorem, :weight => 2.23, :price => 88.99, :tax_rate => 20.0, :stock => 5)
pro.default_image_file = get_file('t26p.jpg')
pro.save!
pro.product_attributes.update_from_hash('Manufacturer' => 'Yealink', 'Model' => 'T20P', 'Colour' => 'Black', 'Lines' => '6', 'Colour Screen' => 'No', 'Power over ethernet' => 'Yes')

pro = cat1.products.create!(:title => 'Yealink T46GN', :sku => 'YL-SIP-T46GN', :description => lorem, :short_description => 'Colourful, sharp, fast & down right sexy. The Yealink T46P will make your scream!', :weight => 2.23, :price => 149.99, :tax_rate => 20.0, :stock => 5, :featured => true)
pro.default_image_file = get_file('t46gn.jpg')
pro.save!
pro.product_attributes.update_from_hash('Manufacturer' => 'Yealink', 'Model' => 'T20P', 'Colour' => 'Black', 'Lines' => '4', 'Colour Screen' => 'Yes', 'Power over ethernet' => 'Yes')

pro = cat1.products.create!(:title => 'Snom 870 (Grey)', :sku => 'SM-870-GREY', :description => lorem, :short_description => 'The perfect & beautiful VoIP phone for the discerning professional desk.', :weight => 2.4, :price => 235.00, :tax_rate => 20.0, :stock => 2)
pro.default_image_file = get_file('snom-870-grey.jpg')
pro.save!
pro.product_attributes.update_from_hash('Manufacturer' => 'Snom', 'Model' => '870', 'Colour' => 'Grey', 'Lines' => '10', 'Colour Screen' => 'Yes', 'Power over ethernet' => 'Yes')

pro = cat1.products.create!(:title => 'Snom 870 (Black)', :sku => 'SM-870-BLK', :description => lorem, :short_description => 'The perfect & beautiful VoIP phone for the discerning professional desk.', :weight => 2.4, :price => 235.00, :tax_rate => 20.0, :stock => 0, :featured => true)
pro.default_image_file = get_file('snom-870-blk.jpg')
pro.save!
pro.product_attributes.update_from_hash('Manufacturer' => 'Snom', 'Model' => '870', 'Colour' => 'Black', 'Lines' => '10', 'Colour Screen' => 'Yes', 'Power over ethernet' => 'Yes')

pro = cat2.products.create!(:title => 'Yealink Mono Headset', :sku => 'YL-YHS32', :description => lorem, :short_description => 'If you\'re often on the phone, this headset will make your life 100x easier. Guaranteed*.', :weight => 0.890, :price => 34.99, :tax_rate => 20.0, :stock => 3, :featured => true)
pro.default_image_file = get_file('yhs32.jpg')
pro.save!
pro.product_attributes.update_from_hash('Manufacturer' => 'Yealink', 'Model' => 'YHS32')

pro = cat2.products.create!(:title => 'Snom Wired Headset (MM2)', :sku => 'SM-MM2', :description => lorem, :short_description => lorem, :weight => 0.780, :price => 38.00, :tax_rate => 20.0, :stock => 0)
pro.default_image_file = get_file('snom-mm2.jpg')
pro.save!
pro.product_attributes.update_from_hash('Manufacturer' => 'Snom', 'Model' => 'MM2')

pro = cat2.products.create!(:title => 'Snom Wired Headset (MM3)', :sku => 'SM-MM3', :description => lorem, :short_description => lorem, :weight => 0.780, :price => 38.00, :tax_rate => 20.0, :stock => 1)
pro.default_image_file = get_file('snom-mm2.jpg')
pro.save!
pro.product_attributes.update_from_hash('Manufacturer' => 'Snom', 'Model' => 'MM3')

pro = cat1.products.create!(:title => 'Yealink W52P', :sku => 'TL-SIP-W52P', :description => lorem, :short_description => 'Wireless SIP phones are hard to come by but this beauty from Yealink is fab.', :weight => 1.280, :price => 99.99, :tax_rate => 20.0, :stock => 1, :featured => true)
pro.default_image_file = get_file('w52p.jpg')
pro.save!
pro.product_attributes.update_from_hash('Manufacturer' => 'Yealink', 'Model' => 'W52P', 'Colour' => 'Black', 'Lines' => '4', 'Colour Screen' => 'Yes', 'Power over ethernet' => 'Base unit only')
