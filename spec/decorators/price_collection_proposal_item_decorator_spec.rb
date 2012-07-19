require 'decorator_helper'
require 'app/decorators/price_collection_proposal_item_decorator'

describe PriceCollectionProposalItemDecorator do
  context '#total_price' do
    before do
      component.stub(:total_price).and_return(500.0)
      helpers.stub(:number_with_precision).with(500.0).and_return("500,00")
    end

    it 'should applies precision' do
      subject.total_price.should eq "500,00"
    end
  end
end
