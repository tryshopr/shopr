module Shoppe
  class Product
    
    # Relationships
    has_many :variants, :class_name => 'Shoppe::Product', :foreign_key => 'parent_id', :dependent => :destroy
    belongs_to :parent, :class_name => 'Shoppe::Product', :foreign_key => 'parent_id'
    
    # Validations
    validate do
      errors.add :base, "can only belong to a root product" if self.parent && self.parent.parent
    end
    
    # Scopes
    scope :root, -> { where(:parent_id => nil) }
    
    def has_variants?
      !variants.empty?
    end
    
  end
end
