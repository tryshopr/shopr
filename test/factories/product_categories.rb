module Shoppe
  FactoryGirl.define do

    factory :phones_category, :class => ProductCategory do
      name 'Phones'
    end
    
    factory :accessories_category, :class => ProductCategory do
      name 'Accessories'
    end
    
    factory :software_category, :class => ProductCategory do
      name 'Software'
    end

  end
end
