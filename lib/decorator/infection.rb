class Decorator < ActiveSupport::BasicObject
  module Infection
    def decorator
      decorator_class.new(self)
    end

    def decorator_class
      "#{self.class.name}Decorator".constantize
    end

    def decorator?
      "#{self.class.name}Decorator".safe_constantize
    end
  end
end
