module ActiveResource
  module Associations
    extend ActiveSupport::Concern

    module ClassMethods
      def belongs_to(name, options = {})
        reflection = create_reflection(:belongs_to, name, options, self)

        class_eval %{
          def #{reflection.name}
            #{reflection.class_name}.find(#{reflection.foreign_key}) if #{reflection.foreign_key}
          end
        }
      end
    end
  end
end
