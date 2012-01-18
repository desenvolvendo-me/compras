module Presenter
  # Example of usage:
  #
  #   class PersonPresenter < Presenter::Proxy
  #     def full_name
  #       "#{last_name}, #{first_name}"
  #     end
  #   end
  #
  #   person = Person.new(:first_name => "Gabriel", :last_name => "Sobrinho")
  #   person.presenter.full_name #=> "Sobrinho, Gabriel"
  class Proxy < ActiveSupport::BasicObject
    attr_accessor :object

    def initialize(object)
      self.object = object
    end

    def method_missing(method, *arguments, &block)
      object.send(method, *arguments, &block)
    end

    def respond_to?(method, include_private = false)
      object.respond_to?(method, include_private)
    end
  end
end
