module Shoppe
  module AssociatedCountries
    
    def self.included(base)
      base.serialize :country_ids, Array
      base.before_validation { self.country_ids = self.country_ids.map(&:to_i).select { |i| i > 0} if self.country_ids.is_a?(Array) }
    end
    
    def country?(id)
      id = id.id if id.is_a?(Shoppe::Country)
      self.country_ids.is_a?(Array) && self.country_ids.include?(id.to_i)
    end
    
    def countries
      return [] unless self.country_ids.is_a?(Array) && !self.country_ids.empty?
      Shoppe::Country.where(:id => self.country_ids)
    end
    
  end
end