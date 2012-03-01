module Rcqrs
  module Serialization
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def from_json(json)
        parsed = JSON.parse(json)
        self.new(parsed)
      end
    end
  end
end
