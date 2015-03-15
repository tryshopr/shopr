module Shoppe
  FactoryGirl.define do
    
    factory :delivery_price, :class => DeliveryServicePrice do
      price           5.0
      cost_price      2.50
      code            'PACK'
      min_weight      0
      max_weight      1
      association     :tax_rate,          :factory => :standard_tax
      association     :delivery_service,  :factory => :delivery_service
    end
    
    factory :delivery_service, :class => DeliveryService do
      name           'Next Day Delivery'
      code           'ND'
      default        true
      active         true
      courier        'UPS'
      tracking_url   'http://sometrackingsite.com/{{consignment_number}}/{{billing_postcode}}/{{delivery_postcode}}'

      factory :delivery_service_with_prices do
        transient do
          country_ids []
        end
        
        after(:create) do |service, evaluator|
          country_ids = evaluator.country_ids
          FactoryGirl.create(:delivery_price, :delivery_service => service, :country_ids => country_ids)
          FactoryGirl.create(:delivery_price, :delivery_service => service, :min_weight => 1, :max_weight => 10, :price => 8.0, :cost_price => 4.0, :country_ids => country_ids)
          FactoryGirl.create(:delivery_price, :delivery_service => service, :min_weight => 10, :max_weight => 50, :price => 12.0, :cost_price => 6.0, :country_ids => country_ids)
        end
      end
    end

    factory :saturday_delivery, :parent => :delivery_service do
      name            'Saturday Delivery'
      code            'SD'
      default         false
      factory :saturday_delivery_with_prices do
        after(:create) do |service, evaluator|
          FactoryGirl.create(:delivery_price, :delivery_service => service, :price => 15.0)
          FactoryGirl.create(:delivery_price, :delivery_service => service, :min_weight => 1, :max_weight => 10, :price => 18.0, :cost_price => 14.0)
          FactoryGirl.create(:delivery_price, :delivery_service => service, :min_weight => 10, :max_weight => 50, :price => 22.0, :cost_price => 16.0)
        end
      end
    end

    factory :first_class_post, :class => DeliveryService do
      name           'First Class Post'
      code           'RMFS'
      default        false
      active         true
      courier        'Royal Mail'
      factory :first_class_post_with_prices do
        after(:create) do |service, evaluator|
          FactoryGirl.create(:delivery_price, :delivery_service => service, :min_weight => 0, :max_weight => 0.1, :price => 1.0, :cost_price => 0.50)
        end
      end
    end
    
  end
end
