require 'model_helper'
require 'app/models/purchase_process_trading_item'
require 'app/models/purchase_process_trading_item_bid'
require 'app/models/purchase_process_trading_item_negotiation'
require 'app/models/licitation_process_ratification_item'

describe PurchaseProcessTradingItem do
  it { should belong_to :trading }
  it { should belong_to :item }

  it { should have_many(:bids).dependent(:destroy) }
  it { should have_many(:accreditation_creditors).through(:trading) }
  it { should have_many(:ratification_items).class_name('LicitationProcessRatificationItem') }

  it { should have_one(:negotiation).dependent(:restrict) }

  describe 'delegates' do
    it { should delegate(:lot).to(:item).allowing_nil(true).prefix(true) }
    it { should delegate(:lot?).to(:trading).allowing_nil(true) }
    it { should delegate(:item?).to(:trading).allowing_nil(true) }
    it { should delegate(:purchase_process_id).to(:trading).allowing_nil(true) }
  end

  describe 'validations' do
    it 'cannot have 2 kind of reductions' do
      subject.reduction_rate_value = 10.0
      subject.reduction_rate_percent = 10.0

      subject.valid?

      expect(subject.errors[:reduction_rate_value]).to include('não pode ser usado ao mesmo tempo que o decréscimo em percentual')
    end

    it 'should allow reduction by value' do
      subject.reduction_rate_value = 10.0

      subject.valid?

      expect(subject.errors[:reduction_rate_value]).to_not include('não pode ser usado ao mesmo tempo que o decréscimo em percentual')
    end

    it 'should allow reduction by percentage' do
      subject.reduction_rate_percent = 10.0

      subject.valid?

      expect(subject.errors[:reduction_rate_value]).to_not include('não pode ser usado ao mesmo tempo que o decréscimo em percentual')
    end

    it 'should not allow a negative value for reduction_rato_value on update' do
      subject.reduction_rate_value = -1

      subject.stub(:validation_context).and_return(:update)

      subject.valid?

      expect(subject.errors[:reduction_rate_value]).to include('deve ser maior ou igual a 0')
    end

    it 'should not allow a negative value for reduction_rato_value on update' do
      subject.reduction_rate_percent = -1

      subject.stub(:validation_context).and_return(:update)

      subject.valid?

      expect(subject.errors[:reduction_rate_percent]).to include('deve ser maior ou igual a 0')
    end
  end

  describe '#to_s' do
    context 'when has lot' do
      before do
        subject.lot = 4
      end

      it 'should return the lot' do
        expect(subject.to_s).to eq '4'
      end
    end

    context 'when has not lot' do
      let(:item) { double(:item) }

      before do
        subject.stub(item: item)
      end

      it 'should return the item to_s' do
        item.should_receive(:to_s).and_return('item')

        expect(subject.to_s).to eq 'item'
      end
    end
  end

  describe '#last_bid' do
    it 'should return the last given bid for the item' do
      bids = double(:bids)

      subject.stub(bids: bids)

      bids.should_receive(:not_without_proposal).and_return(bids)
      bids.should_receive(:reorder).with(:id).and_return(['bid1', 'bid2'])

      expect(subject.last_bid).to eq 'bid2'
    end
  end

  describe '#last_bid_with_proposal' do
    it 'should return the last bid with proposal' do
      bids = double(:bids)

      subject.stub(bids: bids)

      bids.should_receive(:with_proposal).and_return(bids)
      bids.should_receive(:reorder).with(:id).and_return(['bid1', 'bid2'])

      expect(subject.last_bid_with_proposal).to eq 'bid2'
    end
  end

  describe '#lowest_proposal' do
    before do
      subject.stub(purchase_process_id: 50)
    end

    context 'when creditor_with_lowest_proposal is nil' do
      before do
        subject.stub(creditor_with_lowest_proposal: nil)
      end

      it 'should return nil' do
        expect(subject.lowest_proposal).to be_nil
      end
    end

    context 'when judgment_form by item' do
      before do
        subject.stub item?: true
      end

      context 'when creditor_with_lowest_proposal is not nil' do
        let(:creditor) { double(:creditor) }
        let(:proposal) { double(:proposal) }
        let(:item) { double(:item) }
        let(:accreditation_creditor_resource) { double(:accreditation_creditor_resource) }

        before do
          subject.stub(creditor_with_lowest_proposal: creditor)
          subject.stub(item: item)
        end

        it 'should return the lowest proposal' do
          creditor.should_receive(:creditor_proposal_by_item).with(50, item).and_return(proposal)

          expect(subject.lowest_proposal).to eq proposal
        end
      end

      context 'when judgment_form not by item' do
        before do
          subject.stub item?: false
        end

        context 'when creditor_with_lowest_proposal is not nil' do
          let(:creditor) { double(:creditor) }
          let(:proposal) { double(:proposal) }
          let(:accreditation_creditor_resource) { double(:accreditation_creditor_resource) }

          before do
            subject.stub(creditor_with_lowest_proposal: creditor)
            subject.stub(lot: 1112)
          end

          it 'should return the lowest proposal' do
            creditor.should_receive(:creditor_proposal_by_lot).with(50, 1112).and_return(proposal)

            expect(subject.lowest_proposal).to eq proposal
          end
        end
      end
    end
  end

  describe '#creditors_selected' do
    it 'should return selected creditors ordered' do
      creditors_ordered = double(:creditors_ordered)

      subject.should_receive(:creditors_ordered).and_return(creditors_ordered)
      creditors_ordered.should_receive(:selected_creditors).and_return(['creditor1', 'creditor2'])

      expect(subject.creditors_selected).to eq ['creditor1', 'creditor2']
    end
  end

  describe '#creditors_ordered' do
    let(:accreditation_creditors_repository) { double(:accreditation_creditors_repository) }

    context 'when judgment_form by item' do
      before do
        subject.stub(item?: true)
      end

      it 'should return all creditors ordered' do
        item = double(:item, id: 4)

        subject.stub(item: item)
        accreditation_creditors = double(:accreditation_creditors)

        subject.should_receive(:accreditation_creditors).and_return(accreditation_creditors)
        accreditation_creditors.should_receive(:by_lowest_proposal).with(4).and_return(['creditor1', 'creditor2'])

        expect(subject.creditors_ordered(accreditation_creditors_repository)).to eq ['creditor1', 'creditor2']
      end
    end

    context 'when judgment_form not by item' do
      before do
        subject.stub(item?: false)
      end

      it 'should return all creditors ordered' do
        subject.stub(lot: 1133, purchase_process_id: 55)

        accreditation_creditors_repository.should_receive(:by_lowest_proposal_on_lot).with(55, 1133).and_return(['creditor1', 'creditor2'])

        expect(subject.creditors_ordered(accreditation_creditors_repository)).to eq ['creditor1', 'creditor2']
      end
    end
  end

  describe '#creditors_ordered_outer' do
    let(:accreditation_creditors_repository) { double(:accreditation_creditors_repository) }

    context 'when judgment_form by item' do
      before do
        subject.stub(item?: true)
      end

      it 'should return all creditors ordered' do
        item = double(:item, id: 4)

        subject.stub(item: item)
        accreditation_creditors = double(:accreditation_creditors)

        subject.should_receive(:accreditation_creditors).and_return(accreditation_creditors)
        accreditation_creditors.should_receive(:by_lowest_proposal_outer).with(4).and_return(['creditor1', 'creditor2'])

        expect(subject.creditors_ordered_outer(accreditation_creditors_repository)).to eq ['creditor1', 'creditor2']
      end
    end

    context 'when judgment_form not by item' do
      before do
        subject.stub(item?: false)
      end

      it 'should return all creditors ordered' do
        subject.stub(lot: 1133, purchase_process_id: 55)

        accreditation_creditors_repository.should_receive(:by_lowest_proposal_outer_on_lot).with(55, 1133).and_return(['creditor1', 'creditor2'])

        expect(subject.creditors_ordered_outer(accreditation_creditors_repository)).to eq ['creditor1', 'creditor2']
      end
    end
  end

  describe '#bids_historic' do
    let(:bids) { double(:bids) }

    it 'should remove bidders without_proposals and filter by item' do
      subject.stub(bids: bids)

      bids.should_receive(:not_without_proposal).and_return(bids)
      bids.should_receive(:reorder).with('number DESC')

      subject.bids_historic
    end
  end

  describe '#lowest_bid' do
    let(:bids) { double(:bids) }

    before do
      subject.stub(bids: bids)
    end

    context 'when there is bids with proposal' do
      before do
        bids.stub(with_proposal: ['bid_lower', 'bid_higher'])
      end

      it 'should return the bid with proposal with lowest value' do
        expect(subject.lowest_bid).to eq 'bid_lower'
      end
    end

    context 'when there is no bids with proposal' do
      before do
        bids.stub(with_proposal: [])
      end

      it 'should return nil' do
        expect(subject.lowest_bid).to be_nil
      end
    end
  end

  describe '#quantity' do
    pending 'we need information about lot quantity'
  end

  describe '#lowest_bid_or_proposal_amount' do
    context 'when has last_bid' do
      let(:lowest_bid) { double(:lowest_bid, amount: 10.0) }

      before do
        subject.stub(lowest_bid: lowest_bid)
      end

      it "should return lowest_bid's amount" do
        expect(subject.lowest_bid_or_proposal_amount).to eq 10.0
      end
    end

    context 'when has not last_bid' do
      let(:lowest_proposal) { double(:lowest_proposal, unit_price: 16.0) }

      before do
        subject.stub(lowest_proposal: lowest_proposal, last_bid: nil)
      end

      it "should return lowest_proposal's unit_price" do
        expect(subject.lowest_bid_or_proposal_amount).to eq 16.0
      end
    end
  end

  describe '#lowest_bid_or_proposal_accreditation_creditor' do
    context 'when has last_bid' do
      let(:lowest_bid) { double(:lowest_bid, accreditation_creditor: 'creditor') }

      before do
        subject.stub(lowest_bid: lowest_bid)
      end

      it "should return lowest_bid's amount" do
        expect(subject.lowest_bid_or_proposal_accreditation_creditor).to eq 'creditor'
      end
    end

    context 'when has not last_bid' do
      before do
        subject.stub(creditor_with_lowest_proposal: 'creditor2')
      end

      it "should return lowest_proposal's unit_price" do
        expect(subject.lowest_bid_or_proposal_accreditation_creditor).to eq 'creditor2'
      end
    end
  end

  describe '#creditors_benefited' do
    let(:creditors_selected) { double(:creditors_selected) }

    it 'should return all unique benefited creditors' do
      subject.stub(
        creditors_selected: creditors_selected,
        minimum_amount_for_benefited: 10)

      creditors_selected.should_receive(:benefited).and_return creditors_selected
      creditors_selected.should_receive(:less_or_equal_to_trading_bid_value).with(10).and_return ['creditor', 'creditor']

      expect(subject.creditors_benefited).to eq ['creditor']
    end
  end

  describe '#close!' do
    it 'should update status to closed' do
      subject.should_receive(:update_column).with(:status, PurchaseProcessTradingItemStatus::CLOSED)

      subject.close!
    end
  end

  describe '#pending!' do
    it 'should update status to pending' do
      subject.should_receive(:update_column).with(:status, PurchaseProcessTradingItemStatus::PENDING)

      subject.pending!
    end
  end

  describe '#benefited_tie?' do
    let(:creditor) { double(:creditor) }

    before do
      subject.stub(accreditation_creditor_winner: creditor)
    end

    context 'when winner is not benefited' do
      before do
        creditor.stub(benefited?: false)
      end

      context 'when has benefited creditors' do
        before do
          subject.stub(creditors_benefited: ['creditor'])
        end

        it { expect(subject.benefited_tie?).to be_true }
      end

      context 'when has not benefited creditors' do
        before do
          subject.stub(creditors_benefited: [])
        end

        it { expect(subject.benefited_tie?).to be_false }
      end
    end

    context 'when winner is benefited' do
      before do
        creditor.stub(benefited?: true)
      end

      context 'when has benefited creditors' do
        before do
          subject.stub(creditors_benefited: ['creditor'])
        end

        it { expect(subject.benefited_tie?).to be_false }
      end

      context 'when has not benefited creditors' do
        before do
          subject.stub(creditors_benefited: [])
        end

        it { expect(subject.benefited_tie?).to be_false }
      end
    end
  end

  describe '#item_or_lot' do
    context 'when has an item' do
      before do
        subject.stub(item: 'item')
      end

      it 'should return the item' do
        expect(subject.item_or_lot).to eq 'item'
      end
    end

    context 'when does not have an item but have a lot' do
      before do
        subject.stub(item: nil, lot: 'lot')
      end

      it 'should return the lot' do
        expect(subject.item_or_lot).to eq 'lot'
      end
    end
  end

  describe '#creditor_winner' do
    let(:trading_item_winner) { double(:trading_item_winner) }

    it 'should return the creditor who wins the item' do
      trading_item_winner.should_receive(:new).with(subject).and_return trading_item_winner
      trading_item_winner.should_receive(:creditor).and_return 'creditor'

      expect(subject.creditor_winner(trading_item_winner)).to eq 'creditor'
    end
  end

  describe '#amount_winner' do
    let(:trading_item_winner) { double(:trading_item_winner) }

    it 'should return the creditor who wins the item' do
      trading_item_winner.should_receive(:new).with(subject).and_return trading_item_winner
      trading_item_winner.should_receive(:amount).and_return 100

      expect(subject.amount_winner(trading_item_winner)).to eq 100
    end
  end
end
