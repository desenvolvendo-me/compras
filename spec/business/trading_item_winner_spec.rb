require 'unit_helper'
require 'app/business/trading_item_winner'

describe TradingItemWinner do
  subject do
    described_class.new(trading_item, :preemptive_right => preemptive_right)
  end

  let(:trading_item) { double(:trading_item) }
  let(:preemptive_right) { double(:preemptive_right) }

  describe '#bidder_winner' do
    let(:bids) { double(:bids) }

    before do
      trading_item.stub(:bids => bids)
    end

    context 'when there is no lowest bid' do
      before do
        bids.stub(:last_valid_proposal => nil)
      end

      it 'should be nil' do
        expect(subject.bidder_winner).to be_nil
      end
    end

    context 'when there is a lowest bid' do
      let(:bidder) { double(:bidder) }
      let(:lowest_bid) { double(:lowest_bid, :bidder => bidder) }

      before do
        bids.stub(:last_valid_proposal => lowest_bid)
      end

      context 'when lowest_bid is a valid negotiation' do
        before do
          lowest_bid.stub(:negotiation? => true)
        end

        it 'should return the bidder of lowest bid' do
          expect(subject.bidder_winner).to eq bidder
        end
      end

      context 'when lowest_bid is not a valid negotiation' do
        before do
          lowest_bid.stub(:negotiation? => false)
        end

        it 'should return nil when bidder is disabled' do
          bidder.stub(:disabled => true)

          expect(subject.bidder_winner).to eq nil
        end

        it 'should return nil when bidder is benefited' do
          bidder.stub(:disabled => false)
          bidder.stub(:benefited => true)

          expect(subject.bidder_winner).to eq nil
        end

        it 'should return nil when there is not bidders with preemptive right' do
          bidder.stub(:disabled => false)
          bidder.stub(:benefited => false)
          preemptive_right.stub(:empty? => false)

          expect(subject.bidder_winner).to eq nil
        end

        it 'should return nil when the bidder have negotiation without proposal' do
          negotiation = double(:negotiation, :bidder => bidder)

          bidder.stub(:disabled => false)
          bidder.stub(:benefited => false)
          preemptive_right.stub(:empty? => true)
          bids.should_receive(:at_stage_of_negotiation).and_return(bids)
          bids.should_receive(:with_no_proposal).and_return([negotiation])

          expect(subject.bidder_winner).to eq nil
        end

        it 'should return the bidder with lowest proposal' do
          negotiation = double(:negotiation, :bidder => nil)

          bidder.stub(:disabled => false)
          bidder.stub(:benefited => false)
          preemptive_right.stub(:empty? => true)
          bids.should_receive(:at_stage_of_negotiation).and_return(bids)
          bids.should_receive(:with_no_proposal).and_return([negotiation])

          expect(subject.bidder_winner).to eq bidder
        end
      end
    end
  end

  describe '.winner' do
    let(:winner_instance) { double(:winner_instance) }

    it 'should instantiate and call bidder_winner' do
      described_class.should_receive(:new).with(trading_item).and_return(winner_instance)
      winner_instance.should_receive(:bidder_winner)

      described_class.winner(trading_item)
    end
  end
end
