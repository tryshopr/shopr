module Shoppe
  FactoryGirl.define do
    
    factory :yealink_t22p, :class => Product do
      name                'Yealink T22P'
      sku                 'YT22P'
      short_description   'An awesome phone which you will absolutely love to use.'
      description         'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      price               100.00
      cost_price          50.00
      weight              1.000
      stock_control       true
      association         :product_category,    :factory => :phones_category
      association         :tax_rate,            :factory => :standard_tax
    end
    
    factory :snom_870, :class => Product do
      name                'Snom 870'
      sku                 'SN870'
      short_description   'An awesome phone which you will absolutely love to use.'
      description         'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      price               200.00
      cost_price          100.00
      weight              1.350
      stock_control       true
      association         :product_category,    :factory => :phones_category
      association         :tax_rate,            :factory => :standard_tax
    end

    factory :yealink_headset, :class => Product do
      name                'Yealink Headset'
      sku                 'YHS32'
      short_description   'An awesome headset which you will absolutely love to use.'
      description         'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      price               40.00
      cost_price          20.00
      weight              0.600
      stock_control       true
      association         :product_category,    :factory => :accessories_category
      association         :tax_rate,            :factory => :standard_tax
    end

    factory :software_product, :class => Product do
      name                'Software Product'
      sku                 'SP'
      short_description   'An awesome piece of software which can be purchased.'
      description         'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      price               500.00
      cost_price          10.00
      weight              0.0
      stock_control       false
      association         :product_category,    :factory => :software_category
      association         :tax_rate,            :factory => :standard_tax
    end
  
  end
end
