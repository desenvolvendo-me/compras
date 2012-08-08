# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/price_collection_decorator'

describe PriceCollectionDecorator do
  context '#winner_proposal_total_price' do
    context 'when have winner_proposal_total_price' do
      before do
        component.stub(:winner_proposal_total_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.winner_proposal_total_price).to be_nil
      end
    end

    context 'when have winner_proposal_total_price' do
      before do
        component.stub(:winner_proposal_total_price).and_return(9.99)
      end

      it 'should applies precision' do
        expect(subject.winner_proposal_total_price).to eq '9,99'
      end
    end
  end
end
