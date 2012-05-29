# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/price_collection_decorator'

describe PriceCollectionDecorator do
  it 'should return formatted winner_proposal_total_price' do
    component.stub(:winner_proposal_total_price).and_return(9.99)
    helpers.stub(:number_with_precision).with(9.99).and_return('R$ 9,99')

    subject.winner_proposal_total_price.should eq 'R$ 9,99'
  end
end
