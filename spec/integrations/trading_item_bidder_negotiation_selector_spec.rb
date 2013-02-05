require 'spec_helper'

describe TradingItemBidderNegotiationSelector do
  subject do
    described_class.new(trading_item)
  end

  let(:bidder1) { Bidder.make!(:licitante) }
  let(:bidder2) { Bidder.make!(:licitante_sobrinho) }
  let(:bidder_benefited1) { Bidder.make!(:licitante_com_proposta_3) }
  let(:bidder_benefited2) { Bidder.make!(:me_pregao) }
  let(:trading_item) { trading.items.first }

  let(:licitation_process) do
    LicitationProcess.make!(:pregao_presencial,
      :bidders => [bidder1, bidder2, bidder_benefited1, bidder_benefited2])
  end

  let(:trading) do
    Trading.make!(:pregao_presencial, :licitation_process => licitation_process)
  end

  context 'with proposals activated' do
    before do
      trading_item.update_column(:proposals_activated_at, DateTime.now)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 1000.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder_benefited1.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder_benefited2.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder_benefited1.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder_benefited2.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)
    end

    context 'without negotiation' do
      describe '#bidders_selected' do
        it 'should returns all bidders not selected' do
          expect(subject.bidders_selected).to eq [bidder1]
        end
      end

      describe '#remaining_bidders' do
        it 'should return the not selected bidder' do
          expect(subject.remaining_bidders).to eq [bidder1]
        end
      end
    end

    context 'with negotiation' do
      before do
        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder1.id,
          :amount => 80.0,
          :stage => TradingItemBidStage::NEGOTIATION,
          :status => TradingItemBidStatus::WITH_PROPOSAL)
      end

      describe '#bidders_selected' do
        it 'should returns all bidders not selected' do
          expect(subject.bidders_selected).to eq [bidder1]
        end
      end

      describe '#remaining_bidders' do
        it 'should return the not selected bidder' do
          expect(subject.remaining_bidders).to eq []
        end
      end
    end
  end

  describe 'with proposals not activated' do
    context 'benefited not wins' do
      before do
        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder1.id,
          :amount => 1000.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder2.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited1.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited2.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited1.id,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

        TradingItemBid.create!(
          :round => 1,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder_benefited2.id,
          :stage => TradingItemBidStage::ROUND_OF_BIDS,
          :status => TradingItemBidStatus::WITHOUT_PROPOSAL)
      end

      context 'benefited between 5%' do
        before do
          TradingItemBid.create!(
            :round => 1,
            :trading_item_id => trading_item.id,
            :bidder_id => bidder2.id,
            :amount => 96.0,
            :stage => TradingItemBidStage::ROUND_OF_BIDS,
            :status => TradingItemBidStatus::WITH_PROPOSAL)
        end

        context 'without negotiation' do
          describe '#bidders_selected' do
            it 'should returns all bidders not selected' do
              expect(subject.bidders_selected).to eq [bidder_benefited1, bidder_benefited2]
            end
          end

          describe '#remaining_bidders' do
            it 'should return the not selected bidder' do
              expect(subject.remaining_bidders).to eq [bidder_benefited1, bidder_benefited2]
            end
          end
        end

        context 'with negotiation and with proposal' do
          before do
            TradingItemBid.create!(
              :round => 0,
              :trading_item_id => trading_item.id,
              :bidder_id => bidder_benefited1.id,
              :amount => 90.0,
              :stage => TradingItemBidStage::NEGOTIATION,
              :status => TradingItemBidStatus::WITH_PROPOSAL)
          end

          describe '#bidders_selected' do
            it 'should returns all bidders not selected' do
              expect(subject.bidders_selected).to eq [bidder_benefited1, bidder_benefited2]
            end
          end

          describe '#remaining_bidders' do
            it 'should return the not selected bidder' do
              expect(subject.remaining_bidders).to eq []
            end
          end
        end

        context 'with negotiation and without proposal' do
          before do
            TradingItemBid.create!(
              :round => 0,
              :trading_item_id => trading_item.id,
              :bidder_id => bidder_benefited1.id,
              :stage => TradingItemBidStage::NEGOTIATION,
              :status => TradingItemBidStatus::WITHOUT_PROPOSAL)
          end

          describe '#bidders_selected' do
            it 'should returns all bidders not selected' do
              expect(subject.bidders_selected).to eq [bidder_benefited1, bidder_benefited2]
            end
          end

          describe '#remaining_bidders' do
            it 'should return the not selected bidder' do
              expect(subject.remaining_bidders).to eq [bidder_benefited2]
            end
          end
        end
      end

      context 'benefited above 5%' do
        before do
          TradingItemBid.create!(
            :round => 1,
            :trading_item_id => trading_item.id,
            :bidder_id => bidder2.id,
            :amount => 94.0,
            :stage => TradingItemBidStage::ROUND_OF_BIDS,
            :status => TradingItemBidStatus::WITH_PROPOSAL)
        end

        describe 'without negotiation' do
          describe '#bidders_selected' do
            it 'should returns all bidders not selected' do
              expect(subject.bidders_selected).to eq []
            end
          end

          describe '#remaining_bidders' do
            it 'should return the not selected bidder' do
              expect(subject.remaining_bidders).to eq []
            end
          end
        end
      end
    end
  end
end
