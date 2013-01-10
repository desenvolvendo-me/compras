require 'spec_helper'

describe TradingItem do
  describe 'validations' do
    subject do
      TradingItem.make!(:item_pregao_presencial)
    end

    context 'with both minimum_reductions' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 1.0,
          :minimum_reduction_percent => 1.0)
      end

      it "validates if minimum percent is zero if minimum_value is present" do
        subject.valid?

        expect(subject.errors[:minimum_reduction_value]).to include "deve ser igual a 0.0"
      end

      it "validates if minimum value is zero if minimum_percent is present" do
        subject.valid?

        expect(subject.errors[:minimum_reduction_percent]).to include "deve ser igual a 0.0"
      end

      it "validates if reduction percent is less than or equal to 100" do
        subject.minimum_reduction_percent = 101.0
        subject.valid?

        expect(subject.errors[:minimum_reduction_percent]).to include "deve ser menor ou igual a 100"
      end
    end

    context 'with no minimum_reduction_percent nor minimum_reduction_value' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 0.0,
          :minimum_reduction_percent => 0.0)
      end

      it 'validates at least one minimum_reduction' do
        subject.valid?

        expect(subject.errors[:minimum_reduction_percent]).to include "um dos campos precisa ser preenchido"
        expect(subject.errors[:minimum_reduction_value]).to include "um dos campos precisa ser preenchido"
      end
    end

    context 'with minimum_reduction_percent' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 0.0,
          :minimum_reduction_percent => 10.0)
      end

      it 'does not validate at least one minimum_reduction when have minimum_reduction_percent' do
        subject.valid?

        expect(subject.errors[:minimum_reduction_value]).to_not include "um dos campos precisa ser preenchido"
        expect(subject.errors[:minimum_reduction_percent]).to_not include "um dos campos precisa ser preenchido"
      end
    end

    context 'with minimum_reduction_percent' do
      subject do
        TradingItem.make!(:item_pregao_presencial,
          :minimum_reduction_value => 10.0,
          :minimum_reduction_percent => 0.0)
      end

      it 'does not validate at least one minimum_reduction when have minimum_reduction_value' do
        subject.valid?

        expect(subject.errors[:minimum_reduction_percent]).to_not include "um dos campos precisa ser preenchido"
        expect(subject.errors[:minimum_reduction_value]).to_not include "um dos campos precisa ser preenchido"
      end
    end
  end

  describe '#bidders_for_negociation_by_lowest_proposal' do
    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:bidder1) { trading.bidders.first }
    let(:bidder2) { trading.bidders.second }
    let(:bidder3) { trading.bidders.last }

    subject { trading.trading_items.first }

    before do
      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :amount => 1000.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder2.id,
        :trading_item_id => subject.id,
        :amount => 999.6,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :amount => 998.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder1.id,
        :trading_item_id => subject.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder2.id,
        :trading_item_id => subject.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :amount => 997.0,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :bidder_id => bidder3.id,
        :trading_item_id => subject.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)
    end

    context 'when not ignoring bids with proposal' do
      it 'should returns all bidders for negotiation when it does not have a negotiation' do
        expect(subject.bidders_for_negociation_by_lowest_proposal).to include(bidder1)
      end

      it 'should not show bidders that already have negotiation' do
        TradingItemBid.create!(
          :round => 0,
          :bidder_id => bidder1.id,
          :trading_item_id => subject.id,
          :stage => TradingItemBidStage::NEGOTIATION,
          :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

        expect(subject.bidders_for_negociation_by_lowest_proposal).to eq []
      end
    end

    context 'when ignoring bids with proposal' do
      it 'should returns all bidders for negotiation when it does not have a negotiation' do
        expect(subject.bidders_for_negociation_by_lowest_proposal(true)).to include(bidder1)
      end

      it 'should show bidders that already have negotiation too' do
        TradingItemBid.create!(
          :round => 0,
          :bidder_id => bidder1.id,
          :trading_item_id => subject.id,
          :stage => TradingItemBidStage::NEGOTIATION,
          :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

        expect(subject.bidders_for_negociation_by_lowest_proposal(true)).to include(bidder1)
      end
    end
  end
end
