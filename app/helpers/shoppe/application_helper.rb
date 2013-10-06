module Shoppe::ApplicationHelper
  
  def number_to_currency(number, options = {})
    options[:unit] ||= Shoppe.config[:currency_unit]
    super
  end
  
end
