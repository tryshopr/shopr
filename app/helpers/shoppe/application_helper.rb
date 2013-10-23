module Shoppe::ApplicationHelper
  
  # Return all currencies with the currency provided by the Shoppe
  # configuration file.
  def number_to_currency(number, options = {})
    options[:unit] ||= Shoppe.config[:currency_unit]
    super
  end
  
  def number_to_weight(kg)
    "#{kg}#{t('shoppe.helpers.number_to_weight.kg', :default => 'kg')}"
  end
  
end
