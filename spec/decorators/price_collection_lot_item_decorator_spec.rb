# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/price_collection_lot_item_decorator'

describe PriceCollectionLotItemDecorator do
  context '#unit_price_by_price_collection_and_creditor' do
    before do
      component.stub(:unit_price_by_price_collection_and_creditor).and_return(330.0)
    end

    it 'should applies currency' do
      subject.unit_price_by_price_collection_and_creditor(nil, nil).should eq '330,00'
    end
  end

  context '#total_value_by_price_collection_and_creditor' do
    before do
      component.stub(:total_value_by_price_collection_and_creditor).and_return(220.0)
    end

    it 'should applies precision' do
      subject.total_value_by_price_collection_and_creditor(nil, nil).should eq '220,00'
    end
  end
end
