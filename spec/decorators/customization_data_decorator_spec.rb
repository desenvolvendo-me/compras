# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/customization_data_decorator'

describe CustomizationDataDecorator do
  describe "#options" do
    it "returns the options array joined with commas" do
      component.stub(:options => ['foo', 'bar', 'baz'])

      expect(subject.options).to eq "foo, bar, baz"
    end

    it "returns nil if options array isn't set" do
      component.stub(:options => nil)

      expect(subject.options).to eq nil
    end

    it "returns only the values for key/value pairs" do
      component.stub(:options => [ ["1 - Foo", "1"], ["2 - Bar", "2"] ])

      expect(subject.options).to eq "1 - Foo, 2 - Bar"
    end
  end
end
