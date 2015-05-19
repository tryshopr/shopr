module Shoppe
  FactoryGirl.define do

    factory :product_category, :class => ProductCategory do
      name 'Product Category'
    end

    factory :phones_category, :class => ProductCategory do
      name 'Phones'
    end

    factory :accessories_category, :class => ProductCategory do
      name 'Accessories'
    end

    factory :software_category, :class => ProductCategory do
      name 'Software'
    end

    factory :parent_category_with_child, :class => ProductCategory do
      name 'Parent Product Category 1'

      after(:create) { |parent| create(:product_category, parent: parent) }
    end
  end
end
