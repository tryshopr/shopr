# The Shopr::Country model stores countries which can be used for delivery & billing
# addresses for orders.
#
# You can use the Shopr::CountryImporter to import a pre-defined list of countries
# into your database. This automatically happens when you run the 'shopr:setup'
# rake task.

module Shopr
  class Country < ApplicationRecord
    # All orders which have this country set as their billing country
    has_many :billed_orders, dependent: :restrict_with_exception, class_name: 'Shopr::Order', foreign_key: 'billing_country_id'

    # All orders which have this country set as their delivery country
    has_many :delivered_orders, dependent: :restrict_with_exception, class_name: 'Shopr::Order', foreign_key: 'delivery_country_id'

    # All countries ordered by their name asending
    scope :ordered, -> { order(name: :asc) }

    # Validations
    validates :name, presence: true
  end
end
