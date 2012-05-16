# Example of usage:
#
#   class PersonDecorator < Decorator
#     def full_name
#       "#{last_name}, #{first_name}"
#     end
#
#     def path
#       routes.person_path(component)
#     end
#
#     def balance
#       helpers.number_to_currency(super)
#     end
#   end
#
#   person = Person.new(:first_name => "Gabriel", :last_name => "Sobrinho")
#   person.decorator.full_name #=> "Sobrinho, Gabriel"
class Decorator < ActiveSupport::BasicObject
  include ::Decorator::Summary
  include ::Decorator::Infection
  include ::Decorator::ModalAttributes

  attr_accessor :original_component, :component, :routes, :helpers

  def initialize(component, routes = ::Rails.application.routes.url_helpers, helpers = ::ApplicationController.helpers)
    self.original_component = component
    self.component = component.respond_to?(:localized) ? component.localized : component
    self.routes = routes
    self.helpers = helpers
  end

  def method_missing(method, *arguments, &block)
    component.send(method, *arguments, &block)
  end

  def respond_to?(method, include_private = false)
    component.respond_to?(method, include_private)
  end
end
