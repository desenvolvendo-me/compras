module Presenter
  # Example of usage:
  #
  #   class PersonPresenter < Presenter::Proxy
  #     def full_name
  #       "#{last_name}, #{first_name}"
  #     end
  #
  #     def path
  #       routes.person_path(object)
  #     end
  #   end
  #
  #   person = Person.new(:first_name => "Gabriel", :last_name => "Sobrinho")
  #   person.presenter.full_name #=> "Sobrinho, Gabriel"
  class Proxy < ActiveSupport::BasicObject
    attr_accessor :object, :routes

    def initialize(object, routes = ::Rails.application.routes.url_helpers)
      self.object = object
      self.routes = routes
    end

    def method_missing(method, *arguments, &block)
      object.send(method, *arguments, &block)
    end

    def respond_to?(method, include_private = false)
      object.respond_to?(method, include_private)
    end
  end
end
