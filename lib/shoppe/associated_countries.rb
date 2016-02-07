module Shoppe
  module AssociatedCountries
    def self.included(base)
      base.serialize :country_ids, Array
      base.before_validation { self.country_ids = country_ids.map(&:to_i).select { |i| i > 0 } if country_ids.is_a?(Array) }
    end

    def country?(id)
      id = id.id if id.is_a?(Shoppe::Country)
      country_ids.is_a?(Array) && country_ids.include?(id.to_i)
    end

    def countries
      return [] unless country_ids.is_a?(Array) && !country_ids.empty?
      Shoppe::Country.where(id: country_ids)
    end
  end
end
