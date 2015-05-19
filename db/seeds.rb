# encoding: UTF-8

# tax rates
tax_rate = Shoppe::TaxRate.create!(:name => "Standard VAT", :rate => 20.0)
exempt_tax = Shoppe::TaxRate.create!(:name => "Exempt VAT", :rate => 0.0)

# delivery services

ds = Shoppe::DeliveryService.create!(:name => "Next Day Delivery", :code => 'ND16', :courier => 'AnyCourier', :tracking_url => 'http://trackingurl.com/track/{{consignment_number}}')
ds.delivery_service_prices.create!(:code => 'Parcel', :min_weight => 0, :max_weight => 1, :price => 5.0, :cost_price => 4.50, :tax_rate => tax_rate)
ds.delivery_service_prices.create!(:code => 'Parcel', :min_weight => 1, :max_weight => 5, :price => 8.0, :cost_price => 7.5, :tax_rate => tax_rate)
ds.delivery_service_prices.create!(:code => 'Parcel', :min_weight => 5, :max_weight => 20, :price => 10.0, :cost_price => 9.50, :tax_rate => tax_rate)

ds = Shoppe::DeliveryService.create!(:name => "Saturday Delivery", :code => 'NDSA16', :courier => 'AnyCourier', :tracking_url => 'http://trackingurl.com/track/{{consignment_number}}')
ds.delivery_service_prices.create!(:code => 'Parcel', :min_weight => 0, :max_weight => 1, :price => 27.0, :cost_price => 24.00, :tax_rate => tax_rate)
ds.delivery_service_prices.create!(:code => 'Parcel', :min_weight => 1, :max_weight => 5, :price => 29.0, :cost_price => 20.00, :tax_rate => tax_rate)
ds.delivery_service_prices.create!(:code => 'Parcel', :min_weight => 5, :max_weight => 20, :price => 37.0, :cost_price => 32.00,:tax_rate => tax_rate)

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

pro = Shoppe::Product.new(:name => 'Yealink T20P', :sku => 'YL-SIP-T20P', :description => lorem, :short_description => 'If cheap & cheerful is what you’re after, the Yealink T20P is what you’re looking for.', :weight => 1.119, :price => 54.99, :cost_price => 44.99, :tax_rate => tax_rate, :featured => true)
pro.product_category_ids = cat1.id
pro.default_image_file = get_file('t20p.jpg')
pro.save!
pro.stock_level_adjustments.create(:description => 'Initial Stock', :adjustment => 17)
pro.product_attributes.create!(:key => 'Manufacturer', :value => 'Yealink', :position => 1)
pro.product_attributes.create!(:key => 'Model', :value => 'T20P', :position => 1)
pro.product_attributes.create!(:key => 'Colour', :value => 'Black', :position => 1)
pro.product_attributes.create!(:key => 'Lines', :value => '3', :position => 1)
pro.product_attributes.create!(:key => 'Colour Screen?', :value => 'No', :position => 1)
pro.product_attributes.create!(:key => 'Power over ethernet?', :value => 'Yes', :position => 1)

pro = Shoppe::Product.new(:name => 'Yealink T22P', :sku => 'YL-SIP-T22P', :description => lorem, :short_description => lorem, :weight => 1.419, :price => 64.99, :cost_price => 56.99, :tax_rate => tax_rate)
pro.product_category_ids = cat1.id
pro.default_image_file = get_file('t22p.jpg')
pro.save!
pro.stock_level_adjustments.create(:description => 'Initial Stock', :adjustment => 200)
pro.product_attributes.create!(:key => 'Manufacturer', :value => 'Yealink', :position => 1)
pro.product_attributes.create!(:key => 'Model', :value => 'T22P', :position => 1)
pro.product_attributes.create!(:key => 'Colour', :value => 'Black', :position => 1)
pro.product_attributes.create!(:key => 'Lines', :value => '4', :position => 1)
pro.product_attributes.create!(:key => 'Colour Screen?', :value => 'No', :position => 1)
pro.product_attributes.create!(:key => 'Power over ethernet?', :value => 'Yes', :position => 1)


pro = Shoppe::Product.new(:name => 'Yealink T26P', :sku => 'YL-SIP-T26P', :description => lorem, :short_description => lorem, :weight => 2.23, :price => 88.99, :cost_price => 78.99, :tax_rate => tax_rate)
pro.product_category_ids = cat1.id
pro.default_image_file = get_file('t26p.jpg')
pro.save!
pro.stock_level_adjustments.create(:description => 'Initial Stock', :adjustment => 100)
pro.product_attributes.create!(:key => 'Manufacturer', :value => 'Yealink', :position => 1)
pro.product_attributes.create!(:key => 'Model', :value => 'T26P', :position => 1)
pro.product_attributes.create!(:key => 'Colour', :value => 'Black', :position => 1)
pro.product_attributes.create!(:key => 'Lines', :value => '6', :position => 1)
pro.product_attributes.create!(:key => 'Colour Screen?', :value => 'No', :position => 1)
pro.product_attributes.create!(:key => 'Power over ethernet?', :value => 'Yes', :position => 1)

pro = Shoppe::Product.new(:name => 'Yealink T46GN', :sku => 'YL-SIP-T46GN', :description => lorem, :short_description => 'Colourful, sharp, fast & down right sexy. The Yealink T46P will make your scream!', :weight => 2.23, :price => 149.99, :cost_price => 139.99, :tax_rate => tax_rate, :featured => true)
pro.product_category_ids = cat1.id
pro.default_image_file = get_file('t46gn.jpg')
pro.save!
pro.stock_level_adjustments.create(:description => 'Initial Stock', :adjustment => 10)
pro.product_attributes.create!(:key => 'Manufacturer', :value => 'Yealink', :position => 1)
pro.product_attributes.create!(:key => 'Model', :value => 'T46GN', :position => 1)
pro.product_attributes.create!(:key => 'Colour', :value => 'Black', :position => 1)
pro.product_attributes.create!(:key => 'Lines', :value => '4', :position => 1)
pro.product_attributes.create!(:key => 'Colour Screen?', :value => 'Yes', :position => 1)
pro.product_attributes.create!(:key => 'Power over ethernet?', :value => 'Yes', :position => 1)

pro = Shoppe::Product.new(:name => 'Snom 870', :sku => 'SM-870', :description => lorem, :short_description => 'The perfect & beautiful VoIP phone for the discerning professional desk.', :featured => true)
pro.product_category_ids = cat1.id
pro.default_image_file = get_file('snom-870-grey.jpg')
pro.save!
pro.product_attributes.create!(:key => 'Manufacturer', :value => 'Snom', :position => 1)
pro.product_attributes.create!(:key => 'Model', :value => '870', :position => 1)
pro.product_attributes.create!(:key => 'Colour', :value => 'Grey', :position => 1)
pro.product_attributes.create!(:key => 'Lines', :value => '10', :position => 1)
pro.product_attributes.create!(:key => 'Colour Screen?', :value => 'Yes', :position => 1)
pro.product_attributes.create!(:key => 'Power over ethernet?', :value => 'Yes', :position => 1)

v1 = pro.variants.create(:name => "White/Grey", :sku => "SM-870-GREY", :price => 230.00, :cost_price => 220, :tax_rate => tax_rate, :weight => 1.35, :default => true)
v1.default_image_file = get_file('snom-870-grey.jpg')
v1.save!
v1.stock_level_adjustments.create(:description => 'Initial Stock', :adjustment => 4)


v2 = pro.variants.create(:name => "Black", :sku => "SM-870-BLK", :price => 230.00, :cost_price => 220, :tax_rate => tax_rate, :weight => 1.35)
v2.default_image_file = get_file('snom-870-blk.jpg')
v2.save!
v2.stock_level_adjustments.create(:description => 'Initial Stock', :adjustment => 2)


pro = Shoppe::Product.new(:name => 'Yealink Mono Headset', :sku => 'YL-YHS32', :description => lorem, :short_description => 'If you\'re often on the phone, this headset will make your life 100x easier. Guaranteed*.', :weight => 0.890, :price => 34.99, :cost_price => 24.99, :tax_rate => tax_rate, :featured => true)
pro.product_category_ids = cat2.id
pro.default_image_file = get_file('yhs32.jpg')
pro.save!
pro.product_attributes.create!(:key => 'Manufacturer', :value => 'Yealink', :position => 1)
pro.product_attributes.create!(:key => 'Model', :value => 'YHS32', :position => 1)

pro = Shoppe::Product.new(:name => 'Snom Wired Headset (MM2)', :sku => 'SM-MM2', :description => lorem, :short_description => lorem, :weight => 0.780, :price => 38.00, :cost_price => 30, :tax_rate => tax_rate)
pro.product_category_ids = cat2.id
pro.default_image_file = get_file('snom-mm2.jpg')
pro.save!
pro.stock_level_adjustments.create(:description => 'Initial Stock', :adjustment => 7)
pro.product_attributes.create!(:key => 'Manufacturer', :value => 'Snom', :position => 1)
pro.product_attributes.create!(:key => 'Model', :value => 'MM2', :position => 1)

pro = Shoppe::Product.new(:name => 'Snom Wired Headset (MM3)', :sku => 'SM-MM3', :description => lorem, :short_description => lorem, :weight => 0.780, :price => 38.00, :cost_price => 30, :tax_rate => tax_rate)
pro.product_category_ids = cat2.id
pro.default_image_file = get_file('snom-mm2.jpg')
pro.save!
pro.stock_level_adjustments.create(:description => 'Initial Stock', :adjustment => 5)
pro.product_attributes.create!(:key => 'Manufacturer', :value => 'Snom', :position => 1)
pro.product_attributes.create!(:key => 'Model', :value => 'MM3', :position => 1)

pro = Shoppe::Product.new(:name => 'Yealink W52P', :sku => 'TL-SIP-W52P', :description => lorem, :short_description => 'Wireless SIP phones are hard to come by but this beauty from Yealink is fab.', :weight => 1.280, :price => 99.99, :cost_price => 89.99, :tax_rate => tax_rate, :featured => true)
pro.product_category_ids = cat1.id
pro.default_image_file = get_file('w52p.jpg')
pro.save!
pro.stock_level_adjustments.create(:description => 'Initial Stock', :adjustment => 10)
pro.product_attributes.create!(:key => 'Manufacturer', :value => 'Snom', :position => 1)
pro.product_attributes.create!(:key => 'Model', :value => 'W52P', :position => 1)
pro.product_attributes.create!(:key => 'Lines', :value => '3', :position => 1)
pro.product_attributes.create!(:key => 'Colour Screen?', :value => 'Yes', :position => 1)
pro.product_attributes.create!(:key => 'Power over ethernet?', :value => 'No', :position => 1)
