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
  end
end
