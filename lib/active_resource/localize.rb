module ActiveResource
  module Localize
    extend ActiveSupport::Concern

    class Columns
      attr_reader :name, :type, :primary

      def initialize(name, type)
        @name    = name.to_s
        @type    = type.to_sym
        @primary = false
      end

      def number?
        [:integer, :float, :decimal].include? type
      end
    end

    module ClassMethods
      def columns
        @columns ||= schema.map { |k, v| Columns.new k,v }
      end

      def nested_attributes_options
        {}
      end
    end
  end
end
