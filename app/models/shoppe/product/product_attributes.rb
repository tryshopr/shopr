class Shoppe::Product
  
  # Relationships
  has_many :product_attributes, -> { order(:position) }, :class_name => 'Shoppe::ProductAttribute'
  
  # Attribute for providing the hash
  attr_accessor :product_attributes_array
  
  # Save the attributes after saving the record
  after_save do
    return unless product_attributes_array.is_a?(Array)
    self.product_attributes.update_from_array(product_attributes_array)
  end
  
end
