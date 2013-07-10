require 'model_helper'
require 'app/models/purchase_process_trading'
require 'app/models/purchase_process_trading_item'

describe PurchaseProcessTrading do
  it { should belong_to :purchase_process }

  it { should have_many(:items) }
  it { should have_many(:accreditation_creditors).through(:purchase_process_accreditation) }
  it { should have_many(:creditors).through(:accreditation_creditors) }
  it { should have_many(:items_bids).through(:items) }

  it { should have_one(:judgment_form).through(:purchase_process) }
  it { should have_one(:purchase_process_accreditation).through(:purchase_process) }

  describe 'validations' do
    it { should validate_presence_of :purchase_process }
  end

  describe 'delegates' do
    it { should delegate(:kind).to(:judgment_form).allowing_nil(true) }
    it { should delegate(:kind_humanize).to(:judgment_form).allowing_nil(true) }
    it { should delegate(:item?).to(:judgment_form).allowing_nil(true) }
    it { should delegate(:lot?).to(:judgment_form).allowing_nil(true) }
  end

  describe '#to_s' do
    let(:purchase_process) { double(:purchase_process, to_s: 'my to s')}

    it "should return the purchase_process's to_s" do
      subject.stub(purchase_process: purchase_process)
      expect(subject.to_s).to eq 'my to s'
    end
  end

  describe '#items_by_winner' do
    let(:accreditation_creditor) { double(:accreditation_creditor) }
    let(:item1) { double(:item1, lowest_bid_or_proposal_accreditation_creditor: accreditation_creditor) }
    let(:item2) { double(:item2, lowest_bid_or_proposal_accreditation_creditor: accreditation_creditor) }
    let(:item3) { double(:item3, lowest_bid_or_proposal_accreditation_creditor: 'other') }

    it 'should return the items where the creditor wins' do
      subject.stub(items: [item1, item2, item3])
      expect(subject.items_by_winner(accreditation_creditor)).to eq [item1, item2]
    end
  end

  describe '#creditors_with_lowest_proposal' do
    let(:item1) { double(:item1, lowest_bid_or_proposal_accreditation_creditor: 'one') }
    let(:item2) { double(:item2, lowest_bid_or_proposal_accreditation_creditor: 'two') }
    let(:item3) { double(:item3, lowest_bid_or_proposal_accreditation_creditor: nil) }

    it 'should return the creditors with lowest proposal/bid by item' do
      subject.stub(items: [item1, item2, item3])
      expect(subject.creditors_with_lowest_proposal).to eq ['one', 'two']
    end
  end

  describe '#creditors_winners' do
    let(:trading_item_winner) { double(:trading_item_winner) }
    let(:item1) { double(:item1) }
    let(:item2) { double(:item2) }
    let(:item3) { double(:item3) }

    it 'should return the creditors who wins each item' do
      subject.stub(items: [item1, item2, item3])

      trading_item_winner.should_receive(:new).with(item1).and_return(trading_item_winner)
      trading_item_winner.should_receive(:new).with(item2).and_return(trading_item_winner)
      trading_item_winner.should_receive(:new).with(item3).and_return(trading_item_winner)

      trading_item_winner.should_receive(:creditor).and_return('one')
      trading_item_winner.should_receive(:creditor).and_return('two')
      trading_item_winner.should_receive(:creditor)

      expect(subject.creditors_winners(trading_item_winner)).to eq ['one', 'two']
    end
  end

  describe '#allow_negotiation?' do
    let(:items) { double(:items) }

    before do
      subject.stub(items: items)
    end

    context 'when there is pending items' do
      before do
        items.stub(pending: [])
      end

      it { expect(subject.allow_negotiation?).to be_true }
    end

    context 'when there is pending items' do
      before do
        items.stub(pending: ['item'])
      end

      it { expect(subject.allow_negotiation?).to be_false }
    end
  end
end
