require 'decorator_helper'
require 'app/decorators/price_collection_proposal_decorator'

describe PriceCollectionProposalDecorator do
  let :date do
    Date.new(2012, 12, 1)
  end

  context '#price_collection_date' do
    context 'when do not have price_collection_date' do
      before do
        component.stub(:price_collection_date).and_return(nil)
      end

      it 'should be nil' do
        subject.price_collection_date.should be_nil
      end
    end

    context 'when have price_collection_date' do
      before do
        component.stub(:price_collection_date).and_return(date)
      end

      it 'should localize' do
        subject.price_collection_date.should eq '01/12/2012'
      end
    end
  end

  context '#item_total_value_by_lot' do
    context 'when do not have item_total_value_by_lot' do
      before do
        component.stub(:item_total_value_by_lot).with(1).and_return(nil)
      end

      it 'should be nil' do
        subject.item_total_value_by_lot(1).should be_nil
      end
    end

    context 'when have item_total_value_by_lot' do
      before do
        component.stub(:item_total_value_by_lot).with(1).and_return(500.0)
      end

      it 'should applies precision' do
        subject.item_total_value_by_lot(1).should eq "500,00"
      end
    end
  end
end
