# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/direct_purchase_decorator'

describe DirectPurchaseDecorator do
  it 'should return formatted total_allocations_items_value' do
    component.stub(:total_allocations_items_value).and_return(512.34)
    helpers.stub(:number_with_precision).with(512.34).and_return('512,34')

    subject.total_allocations_items_value.should eq '512,34'
  end
end
