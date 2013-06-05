require 'model_helper'
require 'app/models/purchase_process_creditor_disqualification'
require 'app/models/purchase_process_creditor_proposal'
require 'app/models/licitation_process'
require 'app/business/purchase_process_creditor_proposal_ranking'

describe PurchaseProcessCreditorDisqualification do
  it { should belong_to :licitation_process }
  it { should belong_to :creditor }

  it { should have_one(:judgment_form).through :licitation_process }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :creditor }
  it { should validate_presence_of :disqualification_date }
  it { should validate_presence_of :reason }
  it { should validate_presence_of :kind }

  it { should delegate(:global?).to(:judgment_form).allowing_nil(true).prefix(true) }

  describe '.find_or_initialize' do
    let(:licitation_process) { double :licitation_process, id: 1 }
    let(:creditor)           { double :creditor, id: 1 }
    let(:record)             { double :record }
    let(:object)             { double :object }

    before do
      record.stub(:first_or_initialize).and_return object
      subject.class.should_receive(:by_licitation_process_and_creditor).with(licitation_process.id, creditor.id).and_return record
    end

    context 'when find a record' do
      before { object.stub(:new_record?).and_return false }

      it 'returns the record' do
        result = subject.class.find_or_initialize(licitation_process, creditor)
        expect(result.new_record?).to be_false
      end
    end

    context "when there's not a record" do
      before { object.stub(:new_record?).and_return true }

      it 'builds a new one' do
        result = subject.class.find_or_initialize(licitation_process, creditor)
        expect(result.new_record?).to be_true
      end
    end
  end

  describe '.disqualification_status' do
    let(:proposal) { double :proposal }

    context 'when got no disqualification' do
      before { subject.class.should_receive(:by_licitation_process_and_creditor).with(1, 1).and_return [] }

      it 'returns :not' do
        expect(subject.class.disqualification_status(1, 1)).to eql :not
      end
    end

    context 'when all proposals are disqualified' do
      before do
        subject.class.should_receive(:by_licitation_process_and_creditor).with(1, 1).and_return [proposal]
        proposal.stub(:all_items_qualified?).and_return false
        proposal.stub(:all_items_disqualified?).and_return true
      end

      it 'returns :fully' do
        expect(subject.class.disqualification_status(1, 1)).to eql :fully
      end
    end

    context 'when some proposals are disqualified' do
      before do
        subject.class.should_receive(:by_licitation_process_and_creditor).with(1, 1).and_return [proposal]
        proposal.stub(:all_items_qualified?).and_return false
        proposal.stub(:all_items_disqualified?).and_return false
      end

      it 'returns :partially' do
        expect(subject.class.disqualification_status(1, 1)).to eql :partially
      end
    end
  end

  describe '#proposal_items' do
    let(:licitation_process) { double :licitation_process }
    let(:creditor)           { double :creditor }

    before do
      subject.stub(:licitation_process).and_return licitation_process
      subject.stub(:creditor).and_return creditor
    end

    it 'returns the items from the licitation process and creditor' do
      licitation_process.should_receive(:proposals_of_creditor).with(creditor)
      subject.proposal_items
    end
  end

  describe '#disqualify_proposal_items' do
    let(:item)           { double :item }
    let(:proposal_items) { [item] }

    before { subject.stub(:proposal_items).and_return proposal_items }

    context 'when can disqualify an item' do
      before { subject.stub(:disqualify_item?).and_return true }

      it 'disqualifies an item when' do
        item.should_receive(:qualify!)
        item.should_receive(:disqualify!)
        PurchaseProcessCreditorProposalRanking.should_receive(:rank!).with item

        subject.run_callbacks(:save)
      end
    end

    context "when an item can't be disqualified" do
      before { subject.stub(:disqualify_item?).and_return false }

      it 'only qualifies an item' do
        item.should_receive(:qualify!)
        item.should_not_receive(:disqualify!)
        PurchaseProcessCreditorProposalRanking.should_receive(:rank!).with item

        subject.run_callbacks(:save)
      end
    end
  end

  describe '#disqualify_item?' do
    let(:item)     { double(:item, id: '1') }
    let(:item_ids) { double(:item_ids) }

    it 'returns true when kind is total' do
      subject.stub(:kind).and_return 'total'
      expect(subject.send(:disqualify_item?, item)).to be_true
    end

    it 'returns true if the current item is selected' do
      subject.stub(:kind).and_return nil
      subject.stub(:proposal_item_ids).and_return item_ids
      item_ids.should_receive(:include?).with("1").and_return true

      expect(subject.send(:disqualify_item?, item)).to be_true
    end
  end

  describe '#kind_should_be_total' do
    let(:error) { double :error }

    before do
      subject.should_receive(:errors).and_return error
      subject.stub(:kind).and_return :total
    end

    it 'adds error to kind unless it is total' do
      error.should_receive(:add).with(:kind, :should_be_total)
      subject.send :kind_should_be_total
    end
  end

  describe '#all_items_disqualified?' do
    let(:proposal_items) { double :proposal_items }
    let(:proposal_item)  { double :proposal_item }

    it 'checks to see if all proposal items are disqualified' do
      subject.should_receive(:proposal_items).and_return proposal_items
      proposal_items.should_receive(:all?).and_yield proposal_item
      proposal_item.should_receive(:disqualified?).and_return true

      expect(subject.all_items_disqualified?).to be_true
    end
  end

  describe '#all_items_qualified?' do
    let(:proposal_items) { double :proposal_items }
    let(:proposal_item)  { double :proposal_item }

    it 'checks to see if all proposal items are qualified' do
      subject.should_receive(:proposal_items).and_return proposal_items
      proposal_items.should_receive(:all?).and_yield proposal_item
      proposal_item.should_receive(:qualified?).and_return true

      expect(subject.all_items_qualified?).to be_true
    end
  end
end
