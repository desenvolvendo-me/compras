class Decorator < ActiveSupport::BasicObject
  module DataAttributes

    def formatted_data_attributes
      data_attributes.map do |attr|
        "data-#{attr.first}='#{send(attr.last)}'"
      end.join(" ")
    end

    def data_attributes
      decorator_class.data_attributes
    end

    module ClassMethods
      attr_accessor :_data_attributes

      def attr_data(attributes = {})
        self._data_attributes = attributes.to_set + (_data_attributes || {})
      end

      def data_attributes
        default_data_attributes + (_data_attributes || {})
      end

      private

      def default_data_attributes
        Set.new({:value => 'id', :label => 'to_s', :type => 'class'})
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
