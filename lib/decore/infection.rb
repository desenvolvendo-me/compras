require 'active_support/core_ext/string/inflections'

module Decore
  module Infection
    def decorator
      if self.class == Class
        decorator = "#{self.name}Decorator".constantize
      else
        decorator = "#{self.class.name}Decorator".constantize
        decorator.new(self)
      end
    end

    def decorated?
      decorator_name = self.class == Class ? "#{self.name}Decorator" : "#{self.class.name}Decorator"
      decorator_name.safe_constantize
    end
  end
end
