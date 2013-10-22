module Shoppe
  module Errors
    class UnorderableItem < Error
      
      def initialize(options)
        @options = options
      end
      
    end
  end
end