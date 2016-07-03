module Shopr
  class ProductCategorization < ActiveRecord::Base
    self.table_name = 'shopr_product_categorizations'

    # Links back
    belongs_to :product, class_name: 'Shopr::Product'
    belongs_to :product_category, class_name: 'Shopr::ProductCategory'

    # Validations
    validates :product, :product_category, presence: true
  end
end
