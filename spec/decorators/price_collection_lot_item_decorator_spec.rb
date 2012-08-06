# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/price_collection_lot_item_decorator'

describe PriceCollectionLotItemDecorator do
  context '#unit_price_by_proposal' do
    context 'when have unit_price_by_proposal' do
      before do
        component.stub(:unit_price_by_proposal).and_return(nil)
      end

      it 'should be nil' do
        subject.unit_price_by_proposal(nil).should be_nil
      end
    end

    context 'when have unit_price_by_proposal' do
      before do
        component.stub(:unit_price_by_proposal).and_return 330.0
      end

      it 'should applies currency' do
        subject.unit_price_by_proposal(nil).should eq '330,00'
      end
    end
  end

  context '#total_value_by_proposal' do
    context 'when total_value_by_proposal' do
      before do
        component.stub(:total_value_by_proposal).and_return(nil)
      end

      it 'should be nil' do
        subject.total_value_by_proposal(nil).should be_nil
      end
    end

    context 'when total_value_by_proposal' do
      before do
        component.stub(:total_value_by_proposal).and_return(220.0)
      end

      it 'should applies precision' do
        subject.total_value_by_proposal(nil).should eq '220,00'
      end
    end
  end
end
