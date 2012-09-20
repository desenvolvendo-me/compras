# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/price_registration_item_decorator'

describe PriceRegistrationItemDecorator do

  context '#unit_price' do
    it "returns the localized unit price" do
      component.stub(:unit_price).and_return(10.5)

      expect(subject.unit_price).to eq "10,50"
    end

    it "returns nil if unit price is nil" do
      component.stub(:unit_price).and_return(nil)

      expect(subject.unit_price).to be_nil
    end
  end
end
