require 'active_support/concern'
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
# Params:
#   :attributes - A list of symbols that represents the methods in the header.
#   :options    - The Hash options used to refine the headers.
#                 :link - A single field or an array of fields can be passed to it.
#                         All the fields specified on this option will be the
#                         link for edit.
#
# Examples:
#
#   # Example1 - with creditor as link to edit
#
#   def WhateverDecorator
#     include Decore
#     include Decore::Header
#
#     attr_header :creditor, :year, :amount, :link => :creditor
#   end
#
#   # Example2 - with creditor and year as link
#
#   def WhateverDecorator
#     include Decore
#     include Decore::Header
#
#     attr_header :creditor, :year, :amount, :link => [:creditor, :year]
#   end
#
#   # Example3 - the first header will be the link with the link was not defined
#
#   def WhateverDecorator
#     include Decore
#     include Decore::Header
#
#     attr_header :creditor, :year, :amount
#   end
#
module Decore
  module Header
    extend ActiveSupport::Concern

    included do
      class_attribute :_header_attributes
      class_attribute :_header_link_attributes
    end

    module ClassMethods
      def attr_header(*attributes)
        if attributes.last.is_a?(Hash)
          options = attributes.pop

          link = options[:link]

          self._header_link_attributes = Set.new(Array(link).map(&:to_sym))
        end

        self._header_attributes = Set.new(attributes.map(&:to_sym))
      end

      def header_attributes
        self._header_attributes || Set.new([])
      end

      def header_link_attributes
        self._header_link_attributes || Set.new(Array(header_attributes.first))
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
