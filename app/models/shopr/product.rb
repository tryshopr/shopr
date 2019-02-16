require 'roo'

module Shopr
  class Product < ApplicationRecord
    # Add dependencies for products
    require_dependency 'shopr/product/product_attributes'
    require_dependency 'shopr/product/variants'

    # Attachments for this product
    has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Shopr::Attachment'

    # The product's categorizations
    #
    # @return [Shopr::ProductCategorization]
    has_many :product_categorizations, dependent: :destroy, class_name: 'Shopr::ProductCategorization', inverse_of: :product
    # The product's categories
    #
    # @return [Shopr::ProductCategory]
    has_many :product_categories, class_name: 'Shopr::ProductCategory', through: :product_categorizations

    # The product's tax rate
    #
    # @return [Shopr::TaxRate]
    belongs_to :tax_rate, class_name: 'Shopr::TaxRate'

    # Ordered items which are associated with this product
    has_many :order_items, dependent: :restrict_with_exception, class_name: 'Shopr::OrderItem', as: :ordered_item

    # Orders which have ordered this product
    has_many :orders, through: :order_items, class_name: 'Shopr::Order'

    # Stock level adjustments for this product
    has_many :stock_level_adjustments, dependent: :destroy, class_name: 'Shopr::StockLevelAdjustment', as: :item

    # Validations
    with_options if: proc { |p| p.parent.nil? } do
      validate :has_at_least_one_product_category
      validates :description, presence: true
      validates :short_description, presence: true
    end
    validates :name, presence: true
    validates :permalink, presence: true, uniqueness: true, permalink: true
    validates :sku, presence: true
    validates :weight, numericality: true
    validates :price, numericality: true
    validates :cost_price, numericality: true, allow_blank: true

    # Before validation, set the permalink if we don't already have one
    before_validation { self.permalink = name.parameterize if permalink.blank? && name.is_a?(String) }

    # All active products
    scope :active, -> { where(active: true) }

    # All featured products
    scope :featured, -> { where(featured: true) }

    scope :ordered, -> { order(:name) }

    # def attachments=(attrs)
    #   if attrs['default_image']['file'].present? then attachments.build(attrs['default_image']) end
    #   if attrs['data_sheet']['file'].present? then attachments.build(attrs['data_sheet']) end

    #   if attrs['extra']['file'].present? then attrs['extra']['file'].each { |attr| attachments.build(file: attr, parent_id: attrs['extra']['parent_id'], parent_type: attrs['extra']['parent_type']) } end
    # end

    # Return the name of the product
    #
    # @return [String]
    def full_name
      parent ? "#{parent.name} (#{name})" : name
    end

    # Is this product orderable?
    #
    # @return [Boolean]
    def orderable?
      return false unless active?
      return false if has_variants?

      true
    end

    # The price for the product
    #
    # @return [BigDecimal]
    def price
      # self.default_variant ? self.default_variant.price : read_attribute(:price)
      default_variant ? default_variant.price : self[:price]
    end

    # Is this product currently in stock?
    #
    # @return [Boolean]
    def in_stock?
      default_variant ? default_variant.in_stock? : (stock_control? ? stock > 0 : true)
    end

    # Return the total number of items currently in stock
    #
    # @return [Fixnum]
    def stock
      stock_level_adjustments.sum(:adjustment)
    end

    # Return the first product category
    #
    # @return [Shopr::ProductCategory]
    def product_category
      product_categories.first
    rescue StandardError
      nil
    end

    # Return attachment for the default_image role
    #
    # @return [String]
    def default_image
      attachments.for('default_image')
    end

    # Set attachment for the default_image role
    def default_image_file=(file)
      attachments.build(file: file, role: 'default_image')
    end

    # Return attachment for the data_sheet role
    #
    # @return [String]
    def data_sheet
      attachments.for('data_sheet')
    end

    # Search for products which include the given attributes and return an active record
    # scope of these products. Chainable with other scopes and with_attributes methods.
    # For example:
    #
    #   Shopr::Product.active.with_attribute('Manufacturer', 'Apple').with_attribute('Model', ['Macbook', 'iPhone'])
    #
    # @return [Enumerable]
    def self.with_attributes(key, values)
      product_ids = Shopr::ProductAttribute.searchable.where(key: key, value: values).pluck(:product_id).uniq
      where(id: product_ids)
    end

    # Imports products from a spreadsheet file
    # Example:
    #
    #   Shopr:Product.import("path/to/file.csv")
    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      spreadsheet.default_sheet = spreadsheet.sheets.first
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        # Don't import products where the name is blank
        next if row['name'].nil?

        if product = find_by(name: row['name'])
          # Dont import products with the same name but update quantities
          qty = row['qty'].to_i
          if qty > 0
            product.stock_level_adjustments.create!(description: I18n.t('shopr.import'), adjustment: qty)
          end
        else
          product = new
          product.name = row['name']
          product.sku = row['sku']
          product.description = row['description']
          product.short_description = row['short_description']
          product.weight = row['weight']
          product.price = row['price'].nil? ? 0 : row['price']
          product.permalink = row['permalink']

          product.product_categories << begin
            Shopr::ProductCategory.find_or_initialize_by(name: row['category_name'])
          end

          product.save!

          qty = row['qty'].to_i
          if qty > 0
            product.stock_level_adjustments.create!(description: I18n.t('shopr.import'), adjustment: qty)
          end
        end
      end
    end

    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
      when '.csv' then Roo::CSV.new(file.path)
      when '.xls' then Roo::Excel.new(file.path)
      when '.xlsx' then Roo::Excelx.new(file.path)
      else raise I18n.t('shopr.imports.errors.unknown_format', filename: File.original_filename)
      end
    end

    private

    # Validates

    def has_at_least_one_product_category
      errors.add(:base, 'must add at least one product category') if product_categories.blank?
    end
  end
end
