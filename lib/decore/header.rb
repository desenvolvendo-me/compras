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
# attr_header by default renders the first column as to_s of the object, but
# this behavior can be disabled through :to_s => false option, but always you
# set :to_s to false you need to choose what column will be the link to edit.
#
# Options:
#   :to_s - Boolean option, default value is true. This option enable/disable
#           the to_s as the first column with link to edit on it.
#           When setted to false :link option is required.
#
#   :link - A single field or an array of fields can be passed to it. All the
#           fields specified on this option will be the link for edit.
#           This option is optional only when :to_s option is true.
#
# Examples:
#
# #Example1 - with to_s as default and creditor as link to edit
# def WhateverDecorator
#   include Decore
#   include Decore::Header
#
#   attr_header :creditor, :year, :amount, :link => :creditor
# end
#
# #Example2 - with to_s as default and creditor and year as link
# def WhateverDecorator
#   include Decore
#   include Decore::Header
#
#   attr_header :creditor, :year, :amount, :link => [:creditor, :year]
# end
#
# #Example4 - only with to_s as link
# def WhateverDecorator
#   include Decore
#   include Decore::Header
#
#   attr_header :creditor, :year, :amount
# end
#
# #Example5 - only with to_s as link
# def WhateverDecorator
#   include Decore
#   include Decore::Header
#
#   attr_header :creditor, :year, :amount, :to_s => false, :link => :creditor
# end
module Decore
  module Header
    extend ActiveSupport::Concern

    included do
      class_attribute :_header_attributes
      class_attribute :_header_link_attributes
      class_attribute :_header_to_s
    end

    module ClassMethods
      def attr_header(*attributes)
        auto_to_s = true

        if attributes.last.is_a?(Hash)
          options = attributes.pop

          auto_to_s = options.fetch(:to_s, auto_to_s)
          link = options[:link]

          if !auto_to_s && !link
            raise ArgumentError, "Header needs link. Supply an options hash with a :link key as the last argument (e.g. attr_header :name, :year, :link => :name)."
          end

          self._header_link_attributes = Set.new(Array(link).map(&:to_sym))
        end

        self._header_attributes = Set.new(attributes.map(&:to_sym))
        self._header_to_s = auto_to_s
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

      def to_s?
        self._header_to_s
      end
    end
  end
end
