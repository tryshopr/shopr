module Shoppe
  module ViewHelpers
    
    # Returns currency values with the currency unit as specified by the Shoppe settings
    def number_to_currency(number, options = {})
      options[:unit] ||= Shoppe.settings.currency_unit
      super
    end

    # Returns a number of kilograms with the appropriate suffix
    def number_to_weight(kg)
      "#{kg}#{t('shoppe.helpers.number_to_weight.kg', :default => 'kg')}"
    end
    
  end
end
