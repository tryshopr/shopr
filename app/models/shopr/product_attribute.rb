module Shopr
  class ProductAttribute < ApplicationRecord
    # Validations
    validates :key, presence: true

    # The associated product
    #
    # @return [Shopr::Product]
    belongs_to :product, class_name: 'Shopr::Product'

    # All attributes which are searchable
    scope :searchable, -> { where(searchable: true) }

    # All attributes which are public
    scope :publicly_accessible, -> { where(public: true) }

    # Return the available options as a hash
    #
    # @return [Hash]
    def self.grouped_hash
      all.group_by(&:key).each_with_object({}) do |(key, attributes), h|
        h[key] = attributes.map(&:value).uniq
      end
    end

    # Create/update attributes for a product based on the provided hash of
    # keys & values.
    #
    # @param array [Array]
    def self.update_from_array(array)
      existing_keys = pluck(:key)
      index = 0
      array.each do |hash|
        next if hash['key'].blank?

        index += 1
        params = hash.merge(searchable: hash['searchable'].to_s == '1',
                            public: hash['public'].to_s == '1',
                            position: index)
        if existing_attr = where(key: hash['key']).first
          if hash['value'].blank?
            existing_attr.destroy
            index -= 1
          else
            existing_attr.update(params)
          end
        else
          attribute = create(params)
        end
      end
      where(key: existing_keys - array.map { |h| h['key'] }).delete_all
      true
    end

    def self.public
      ActiveSupport::Deprecation.warn('The use of Shopr::ProductAttribute.public is deprecated. use Shopr::ProductAttribute.publicly_accessible.')
      publicly_accessible
    end
  end
end
