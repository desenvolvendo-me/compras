module Presenter
  # Example of usage:
  #
  #   class PersonPresenter < Presenter::Proxy
  #     attr_modal :first_name, :last_name
  #     attr_data 'value' => :id, 'label' => :to_s, 'type' => :class, 'first-name' => :first_name
  #
  #     def full_name
  #       "#{last_name}, #{first_name}"
  #     end
  #
  #     def path
  #       routes.person_path(object)
  #     end
  #
  #     def balance
  #       helpers.number_to_currency(object.balance)
  #     end
  #   end
  #
  #   person = Person.new(:first_name => "Gabriel", :last_name => "Sobrinho")
  #   person.presenter.full_name #=> "Sobrinho, Gabriel"
  #   person.presenter.modal_attributes #=> #<Set: {"first_name", "last_name"}>
  #   person.presenter.data_attributes #=> #<Set: {["value", "id"], ["type", "class"], ["first-name" => "first_name"]}>
  class Proxy < ActiveSupport::BasicObject
    class << self
      attr_accessor :_modal_attributes, :_data_attributes

      def attr_modal(*attributes)
        self._modal_attributes = Set.new(attributes.map { |a| a.to_s }) + (_modal_attributes || [])
      end

      def modal_attributes
        _modal_attributes
      end

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

    attr_accessor :original_object, :object, :routes, :helpers

    def initialize(object, routes = ::Rails.application.routes.url_helpers, helpers = ::ApplicationController.helpers)
      self.original_object = object
      self.object = object.respond_to?(:localized) ? object.localized : object
      self.routes = routes
      self.helpers = helpers
    end

    def method_missing(method, *arguments, &block)
      object.send(method, *arguments, &block)
    end

    def respond_to?(method, include_private = false)
      object.respond_to?(method, include_private)
    end

    def modal_attributes
      presenter_class.modal_attributes || object_class.accessible_attributes.to_set
    end

    def data_attributes
      presenter_class.data_attributes
    end

    def summary; end

    def summary?
      summary.present?
    end

    private

    def object_class
      object.class
    end

    def presenter_class
      "#{object_class}Presenter".constantize
    end
  end
end
