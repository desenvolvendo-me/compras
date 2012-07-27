require 'decorator_helper'
require 'app/decorators/price_collection_proposal_item_decorator'

describe PriceCollectionProposalItemDecorator do
  context '#total_price' do
    context 'when do not have total_price' do
      before do
        component.stub(:total_price).and_return(nil)
      end

      it 'should be nil' do
        subject.total_price.should be_nil
      end
    end

    context 'when have total_price' do
      before do
        component.stub(:total_price).and_return(500.0)
      end

      it 'should applies precision' do
        subject.total_price.should eq "500,00"
      end
    end
  end

  context '#unit_price' do
    context 'when do not have unit_price' do
      before do
        component.stub(:unit_price).and_return(nil)
      end

      it 'should be nil' do
        subject.unit_price.should be_nil
      end
    end

    context 'when have unit_price' do
      before do
        component.stub(:unit_price).and_return(500.0)
      end

      it 'should applies precision' do
        subject.unit_price.should eq "500,00"
      end
    end
  end
end
