# This module adds the feature to store the header_attributes at the decorator.
#
# The header_attributes are used to render a different partial at index view
# and it will render the list of resources with columns with headers specified
# at decorator through attr_header method.
#
# If this module is not included at decorator, the index view will act as
# expected, in other words, like it was originaly. This prevents the need of
# change overwritten _list.html.erb partials.
#
# The link options is required and it is responsible to set what column will be
# the link for edit the record.
#
# Examples:
#
# #Example1
# def WhateverDecorator
#   include Decore
#   include Decore::Header
#
#   attr_header :creditor, :year, :amount, :link => :creditor
# end
#
# #Example2
# def WhateverDecorator
#   include Decore
#   include Decore::Header
#
#   attr_header :creditor, :year, :amount, :link => [:creditor, :year]
# end

module Decore
  module Header
    extend ActiveSupport::Concern

    included do
      class_attribute :_header_attributes
      class_attribute :_header_link_attributes
    end

    module ClassMethods
      def attr_header(*attributes)
        options = attributes.pop

        unless options.is_a?(Hash) && link = options[:link]
          raise ArgumentError, "Header needs link. Supply an options hash with a :link key as the last argument (e.g. attr_header :name, :year, :link => :name)."
        end

        self._header_link_attributes = Set.new(Array(link).map(&:to_sym))
        self._header_attributes = Set.new(attributes.map(&:to_sym))
      end

      def header_attributes
        self._header_attributes || []
      end

      def header_link_attributes
        self._header_link_attributes || []
      end

      def link?(field)
        self.header_link_attributes.include?(field)
      end

      def headers?
        self.header_attributes.any?
      end
    end
  end
end
