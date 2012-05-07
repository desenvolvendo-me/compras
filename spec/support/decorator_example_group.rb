require 'active_support/concern'

module RSpec
  module Decorator
    module DecoratorExampleGroup
      extend ActiveSupport::Concern

      included do
        metadata[:type] = :decorator

        subject do
          described_class.new(component, routes, helpers)
        end

        let :component do
          double(:component)
        end

        let :routes do
          double(:routes)
        end

        let :helpers do
          double(:helpers)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Decorator::DecoratorExampleGroup, :type => :decorator, :example_group => {
    :file_path => /spec[\\\/]decorators/
  }
end
