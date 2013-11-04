module Shoppe
  FactoryGirl.define do
    
    factory :standard_tax, :class => TaxRate do
      name          'Standard Tax'
      rate          20.0
    end
    
    factory :exempt_tax, :class => TaxRate do
      name          'Exempt Tax'
      rate          0.0
    end
    
  end
end
