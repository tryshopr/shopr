module Shoppe
  class NavigationManager
    
    def self.managers
      @managers ||= []
    end
    
    def self.create(identifier)
      managers << self.new(identifier.to_s)
    end
    
    def self.build(identifier, &block)
      manager = self.new(identifier.to_s)
      manager.instance_eval(&block) if block_given?
      managers << manager
    end
    
    def self.find(identifier)
      managers.select { |m| m.identifier == identifier.to_s }.first
    end
    
    def self.render(identifier)
      find(identifier).try(:to_html)
    end
    
    attr_reader :identifier
    
    def initialize(identifier)
      @identifier = identifier
    end
    
    def items
      @items ||= []
    end
    
    def add_item(identifier, options = {}, &block)
      item                  = NavigationItem.new
      item.manager          = self
      item.identifier       = identifier.to_s
      item.url              = options[:url]             if options[:url]
      item.link_options     = options[:link_options]    if options[:link_options]
      item.active_if        = block                     if block_given?
      items << item
    end
    
    def remove_item(identifier)
      items.delete_if { |i| i.identifier.to_s == identifier.to_s }
    end
    
    class NavigationItem
      attr_accessor :manager
      attr_accessor :identifier
      attr_accessor :url
      attr_accessor :link_options
      attr_accessor :active_if
      
      def description
        I18n.translate("shoppe.navigation.#{manager.identifier}.#{identifier}")
      end
      
      def url(request = nil)
        (@url.is_a?(Proc) && request && request.instance_eval(&@url) ) ||
        @url ||
        Shoppe::Engine.routes.url_helpers.send("#{identifier}_path")
      end
      
      def active?(request)
        if active_if.is_a?(Proc)
          request.instance_eval(&active_if) == true
        elsif active_nav_var = request.instance_variable_get('@active_nav')
          active_nav_var.to_s == identifier
        end
      end
      
      def link_options
        @link_options ||= {}
      end
    end
    
  end
end
