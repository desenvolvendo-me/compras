require 'decorator_helper'
require 'app/decorators/price_collection_proposal_decorator'

describe PriceCollectionProposalDecorator do
  let :date do
    Date.new(2012, 12, 1)
  end

  context '#price_collection_date' do
    before do
      component.stub(:price_collection_date).and_return(date)
      helpers.stub(:l).with(date).and_return('01/12/2012')
    end

    it 'should localize' do
      subject.price_collection_date.should eq '01/12/2012'
    end
  end

  context '#item_total_value_by_lot' do
    before do
      component.stub(:item_total_value_by_lot).with(1).and_return(500.0)
      helpers.stub(:number_with_precision).with(500.0).and_return("500,00")
    end

    it 'should applies precision' do
      subject.item_total_value_by_lot(1).should eq "500,00"
    end
  end
end
