module Shoppe
  FactoryGirl.define do
    
    factory :order, :class => Order do
      first_name          'Joe'
      last_name           'Bloggs'
      billing_address1    'Unit 9 Winchester Place'
      billing_address2    'North Street'
      billing_address3    'Poole'
      billing_address4    'Dorset'
      billing_postcode    'BH15 1NX'
      association         :billing_country, :factory => :uk
      email_address       'joe@example.com'
      phone_number        '01234 123123'
      ip_address          '127.0.0.1'
    end
    
  end
end
