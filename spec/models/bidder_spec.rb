# encoding: utf-8
require 'model_helper'
require 'lib/signable'
require 'app/models/bidder'
require 'app/models/bidder_proposal'
require 'app/models/bidder_document'
require 'app/models/licitation_process'
require 'app/models/creditor'
require 'app/models/accredited_representative'
require 'app/models/licitation_process_classification'
require 'app/models/licitation_process_ratification'
require 'app/models/trading_item_bid'
require 'app/models/bidder_disqualification'

describe Bidder do
  describe 'default values' do
    it { expect(subject.invited).to be false }
    it { expect(subject.will_submit_new_proposal_when_draw).to be true }
  end

  it { should belong_to :licitation_process }
  it { should belong_to :creditor }

  it { should have_many(:documents).dependent(:destroy).order(:id) }
  it { should have_many(:document_types).through(:documents) }
  it { should have_many(:accredited_representatives).dependent(:destroy) }
  it { should have_many(:people).through(:accredited_representatives) }
  it { should have_many(:licitation_process_classifications).dependent(:destroy) }
  it { should have_many(:licitation_process_classifications_by_classifiable).dependent(:destroy) }
  it { should have_many(:trading_item_bids).dependent(:restrict) }
  it { should have_many(:licitation_process_ratifications).dependent(:restrict) }

  it { should have_one(:disqualification).dependent(:destroy) }

  it { should validate_presence_of :creditor }

  describe 'delegations' do
    it { should delegate(:document_type_ids).to(:licitation_process).prefix(true) }
    it { should delegate(:process_date).to(:licitation_process).prefix(true) }
    it { should delegate(:ratification?).to(:licitation_process).prefix(true) }
    it { should delegate(:trading?).to(:licitation_process).prefix(true) }

    it { should delegate(:administrative_process).to(:licitation_process).allowing_nil(true) }
    it { should delegate(:envelope_opening?).to(:licitation_process).allowing_nil(true) }
    it { should delegate(:items).to(:licitation_process).allowing_nil(true) }
    it { should delegate(:allow_bidders?).to(:licitation_process).allowing_nil(true) }
    it { should delegate(:consider_law_of_proposals).to(:licitation_process).allowing_nil(true) }
    it { should delegate(:licitation_process_lots).to(:licitation_process).allowing_nil(true) }

    it { should delegate(:administrative_process_budget_allocation_items).to(:licitation_process_lots) }
    it { should delegate(:material).to(:administrative_process_budget_allocation_items) }
    it { should delegate(:benefited).to(:creditor).allowing_nil(true) }
  end

  context "licitation kind" do
    before do
      subject.stub(:administrative_process => administrative_process)
    end

    let :administrative_process do
      double('administrative_process')
    end

    it "should validate technical_score when licitation kind is best_technique" do
      administrative_process.stub(:judgment_form_best_technique?).and_return(true)
      should validate_presence_of(:technical_score)
    end

    it "should validate technical_score when licitation kind is technical_and_price" do
      administrative_process.stub(:judgment_form_best_technique?).and_return(false)
      administrative_process.stub(:judgment_form_technical_and_price?).and_return(true)
      should validate_presence_of(:technical_score)
    end

    it "should not validate technical_score when licitation kind is not best_technique or technical_and_price" do
      administrative_process.stub(:judgment_form_best_technique?).and_return(false)
      administrative_process.stub(:judgment_form_technical_and_price?).and_return(false)
      should_not validate_presence_of(:technical_score)
    end
  end

  context 'validate protocol_date related with today' do
    before do
      subject.invited = true
    end

    it { should allow_value(Date.current).for(:protocol_date) }

    it { should allow_value(Date.tomorrow).for(:protocol_date) }

    it 'should not allow date after today' do
      expect(subject).not_to allow_value(Date.yesterday).for(:protocol_date).
        with_message("deve ser igual ou posterior a data atual (#{I18n.l(Date.current)})")
    end
  end

  context 'validate receipt_date related with protocol_date' do
    let :protocol_date do
      Date.current + 10.days
    end

    before do
      subject.stub(:protocol_date).and_return(protocol_date)
      subject.invited = true
    end

    it 'should allow receipt_date date after protocol_date' do
      expect(subject).to allow_value(Date.current + 15.days).for(:receipt_date)
    end

    it 'should allow receipt_date date equals to protocol_date' do
      expect(subject).to allow_value(protocol_date).for(:receipt_date)
    end

    it 'should not allow receipt_date date before protocol_date' do
      expect(subject).not_to allow_value(Date.current).for(:receipt_date).
                                                    with_message("deve ser igual ou posterior a data do protocolo (#{I18n.l protocol_date})")
    end
  end

  context 'valitation licitatino_process_ratification' do
    let(:licitation_process) { double(:licitation_process,
      :administrative_process => nil, :allow_bidders? => true, :to_s => '1/2012') }

    it 'should not allow save when licitation_process has ratification' do
      subject.stub(:licitation_process).and_return(licitation_process)
      subject.stub(:licitation_process_ratification?).and_return(true)

      subject.valid?

      expect(subject.errors[:base]).to include 'não pode ser alterado quando o processo licitatório (1/2012) vinculado estiver homologado'
    end
  end

  it "should validate presence of dates, protocol when it is not invite" do
    subject.invited = false

    subject.valid?

    expect(subject.errors.messages[:protocol]).to be_nil
    expect(subject.errors.messages[:protocol_date]).to be_nil
    expect(subject.errors.messages[:receipt_date]).to be_nil
  end

  it "should not validate presence of dates, protocol when it is invite" do
    subject.invited = true

    subject.valid?

    expect(subject.errors.messages[:protocol]).to include "não pode ficar em branco"
    expect(subject.errors.messages[:protocol_date]).to include "não pode ficar em branco"
    expect(subject.errors.messages[:receipt_date]).to include "não pode ficar em branco"
  end

  it 'should return licitation process  - id as to_s method' do
    subject.stub(:creditor => double(:to_s => 'Fulano'))

    expect(subject.to_s).to eq 'Fulano'
  end

  describe 'before_save' do
    it 'should clear dates, protocol when is not invited' do
      subject.invited = false
      subject.protocol = 1234
      subject.protocol_date = Date.new(2012, 1, 1)
      subject.receipt_date = Date.new(2012, 1, 1)

      subject.run_callbacks(:save)

      subject.invited = false
      expect(subject.protocol).to be nil
      expect(subject.protocol_date).to be nil
      expect(subject.receipt_date).to be nil
    end

    describe "proposal" do
      let :proposal do
        double :proposal
      end

      it "should proposal situation be nil on create" do
        proposal.stub(:situation).with(SituationOfProposal::CANCELED)
        subject.stub(:proposals => [ proposal ])
        proposal.should_receive(:classification=)
        proposal.should_receive(:unit_price=)
        proposal.should_receive(:unit_price)
        proposal.should_receive(:situation=).with(nil)

        subject.run_callbacks(:save)
      end

      it "should proposal classificaton be nil on create" do
        proposal.stub(:classification).with(9)
        subject.stub(:proposals => [ proposal ])
        proposal.should_receive(:situation=)
        proposal.should_receive(:unit_price=)
        proposal.should_receive(:unit_price)
        proposal.should_receive(:classification=).with(nil)

        subject.run_callbacks(:save)
      end

      it "should proposal unit_price be 0 if was nil on create" do
        proposal.stub(:unit_price)
        subject.stub(:proposals => [ proposal ])
        proposal.should_receive(:situation=)
        proposal.should_receive(:classification=)
        proposal.should_receive(:unit_price=).with(0)

        subject.run_callbacks(:save)
      end

      it "should not change proposal unit_price if has value on create" do
        proposal.stub(:unit_price => 99)
        subject.stub(:proposals => [ proposal ])
        proposal.should_receive(:situation=)
        proposal.should_receive(:classification=)
        proposal.should_not_receive(:unit_price=).with(0)

        subject.run_callbacks(:save)
      end
    end
  end

  it "should can update proposals when all licitation process lots are filled" do
    subject.stub_chain(:licitation_process, :filled_lots?).and_return(true)
    expect(subject).to be_can_update_proposals
  end

  it "should can update proposals when has not any lots" do
    subject.stub_chain(:licitation_process, :filled_lots?).and_return(false)
    subject.stub(:licitation_process_lots).and_return( Array.new )
    expect(subject).to be_can_update_proposals
  end

  context "with licitation_process" do
    before do
      subject.stub(:licitation_process => licitation_process)
    end

    let :licitation_process do
      double('licitation_process', :administrative_process => nil, :ratification? => false)
    end

    it "should not allow changes if licitation_process does not allow_bidders" do
      licitation_process.stub(:allow_bidders?).and_return(false)

      subject.valid?
      expect(subject.errors[:licitation_process]).to include "deve ser a data da abertura do envelope do processo licitatório"
    end

    it "shuld allow changes if licitation_process allow bidders" do
      licitation_process.stub(:allow_bidders?).and_return(true)

      subject.valid?
      expect(subject.errors[:licitation_process]).to_not include "deve ser a data da abertura do envelope do processo licitatório"
    end
  end

  it 'should return 0 as the total price when there are no proposals' do
    expect(subject.total_price).to eq 0
  end

  it 'should return the total price' do
    item_1 = double('item 1', :total_price => 300)
    item_2 = double('item 2', :total_price => 200)

    subject.stub(:proposals).and_return([item_1, item_2])

    expect(subject.total_price).to eq 500
  end

  context 'item with unit price equals zero' do
    it 'should return true' do
      subject.stub(:proposals => double(:any_without_unit_price? => true))

      expect(subject.has_item_with_unit_price_equals_zero).to be true
    end

    it 'should return false' do
      subject.stub(:proposals => double(:any_without_unit_price? => false))

      expect(subject.has_item_with_unit_price_equals_zero).to be false
    end
  end

  context '#expired documents' do
    it 'should return true' do
      subject.stub(:documents => [double(:expired? => true), double(:expired? => false)])

      expect(subject.expired_documents?).to be true
    end

    it 'should return false' do
      subject.stub(:documents => [double(:expired? => false), double(:expired? => false)])

      expect(subject.expired_documents?).to be false
    end
  end

  context 'has proposals unit price greater than budget allocation unit price' do
    it 'should return true' do
      subject.stub(:proposals => [double(:unit_price_greater_than_budget_allocation_item_unit_price? => true),
                                  double(:unit_price_greater_than_budget_allocation_item_unit_price? => false)])

      expect(subject.has_proposals_unit_price_greater_than_budget_allocation_item_unit_price?).to be true
    end

    it 'should return false' do
      subject.stub(:proposals => [double(:unit_price_greater_than_budget_allocation_item_unit_price? => false),
                                  double(:unit_price_greater_than_budget_allocation_item_unit_price? => false)])

      expect(subject.has_proposals_unit_price_greater_than_budget_allocation_item_unit_price?).to be false
    end
  end

  context '#benefited_by_law_of_proposals?' do
    it 'returns true if law of proposals should not be taken into account' do
      subject.stub(:consider_law_of_proposals => false)
      expect(subject.benefited_by_law_of_proposals?).to be false
    end

    it 'returns true if bidder is benefited' do
      subject.stub(:consider_law_of_proposals => true,
                   :benefited => true)
      expect(subject.benefited_by_law_of_proposals?).to be true
    end

    it 'returns false if bidder is not benefited' do
      subject.stub(:consider_law_of_proposals => true,
                   :benefited => false)
      expect(subject.benefited_by_law_of_proposals?).to be false
    end
  end

  context '#inactivate!' do
    it 'changes the bidder status to Inactive' do
      subject.should_receive(:update_column).with(:status, "inactive")
      subject.inactivate!
    end
  end

  context '#activate!' do
    it 'changes the bidder status to Active' do
      subject.should_receive(:update_column).with(:status, "active")
      subject.activate!
    end
  end

  describe "#has_documentation_problem" do
    it "returns true if bidder's documents have expired" do
      subject.stub(:expired_documents? => true)
      subject.stub(:filled_documents? => true)

      expect(subject.has_documentation_problem?).to be true
    end

    it "returns true if bidder has not filled the documents" do
      subject.stub(:expired_documents? => false)
      subject.stub(:filled_documents? => false)

      expect(subject.has_documentation_problem?).to be true
    end

    it "returns false if documents are ok" do
      subject.stub(:expired_documents? => false)
      subject.stub(:filled_documents? => true)

      expect(subject.has_documentation_problem?).to be false
    end
  end

  describe '#lower_trading_item_bid_amount' do
    it 'should return zero when bidder there is no proposal for item' do
      trading_item = double(:trading_item)

      subject.should_receive(:lower_trading_item_bid).with(trading_item).and_return(nil)

      expect(subject.lower_trading_item_bid_amount(trading_item)).to eq 0
    end

    it 'should return the amount of lowest proposal of bidder for item' do
      trading_item = double(:trading_item)
      lower_bid = double(:lower_bid, :amount => 120.56)

      subject.should_receive(:lower_trading_item_bid).with(trading_item).and_return(lower_bid)

      expect(subject.lower_trading_item_bid_amount(trading_item)).to eq 120.56
    end
  end

  describe '#trading_item_classification_percent' do
    it 'should return nil when there are no proposal for the item' do
      trading_item = double(:trading_item)

      subject.should_receive(:lower_trading_item_bid).with(trading_item).and_return(nil)

      expect(subject.trading_item_classification_percent(trading_item)).to be_nil
    end

    it 'should return zero for the first place of the classification' do
      trading_item = double(:trading_item, :lowest_proposal_amount => 100.0)
      lower_trading_item_bid = double(:lower_trading_item_bid, :amount => 100.0)

      subject.should_receive(:lower_trading_item_bid).
              at_least(1).times.with(trading_item).and_return(lower_trading_item_bid)

      expect(subject.trading_item_classification_percent(trading_item)).to eq 0
    end

    it 'should calculate de percentual based on the first place of the classification' do
      trading_item = double(:trading_item, :lowest_proposal_amount => 100.0)
      lower_trading_item_bid = double(:lower_trading_item_bid, :amount => 120.0)

      subject.should_receive(:lower_trading_item_bid).
              at_least(1).times.with(trading_item).and_return(lower_trading_item_bid)

      expect(subject.trading_item_classification_percent(trading_item)).to eq 20.0
    end
  end

  describe '#trading_item_proposal_percent' do
    it 'should return nil when there are no proposal for the item' do
      trading_item = double(:trading_item)

      subject.should_receive(:lower_trading_item_bid_at_stage_of_proposals).with(trading_item).and_return(nil)

      expect(subject.trading_item_proposal_percent(trading_item)).to be_nil
    end

    it 'should return zero for the first place of the classification' do
      trading_item = double(:trading_item, :lowest_proposal_at_stage_of_proposals_amount => 100.0)
      lower_trading_item_bid_at_stage_of_proposals = double(:lower_trading_item_bid_at_stage_of_proposals, :amount => 100.0)

      subject.should_receive(:lower_trading_item_bid_at_stage_of_proposals).
              at_least(1).times.with(trading_item).and_return(lower_trading_item_bid_at_stage_of_proposals)

      expect(subject.trading_item_proposal_percent(trading_item)).to eq 0
    end

    it 'should calculate de percentual based on the first place of the classification' do
      trading_item = double(:trading_item, :lowest_proposal_at_stage_of_proposals_amount => 100.0)
      lower_trading_item_bid_at_stage_of_proposals = double(:lower_trading_item_bid_at_stage_of_proposals, :amount => 120.0)

      subject.should_receive(:lower_trading_item_bid_at_stage_of_proposals).
              at_least(1).times.with(trading_item).and_return(lower_trading_item_bid_at_stage_of_proposals)

      expect(subject.trading_item_proposal_percent(trading_item)).to eq 20.0
    end
  end

  describe '#descroy_all_classifications' do
    let(:classifications) { double(:licitation_process_classifications) }

    it 'should call destroy_all classifications' do
      subject.stub(:licitation_process_classifications).and_return(classifications)

      classifications.should_receive(:destroy_all)

      subject.destroy_all_classifications
    end
  end

  describe '#last_bid' do
    let(:trading_item_bids) { double(:trading_item_bids) }
    let(:trading_item) { double(:trading_item, :id => 6) }

    before do
      subject.stub(:trading_item_bids => trading_item_bids)
    end

    it 'should return nil when there are no bids for item' do
      trading_item_bids.should_receive(:for_trading_item).with(6).and_return([])

      expect(subject.last_bid(trading_item)).to be_nil
    end

    it 'should return last bid when there are bids for item' do
      trading_item_bids.should_receive(:for_trading_item).with(6).and_return(['first', 'last'])

      expect(subject.last_bid(trading_item)).to eq 'last'
    end
  end

  describe '#disabled' do
    context 'when it has not a disqualication' do
      it { expect(subject.disabled).to be_false }
    end

    context 'when it has a disqualification' do
      before do
        subject.stub(:disqualification => 'disqualification')
      end

      it { expect(subject.disabled).to be_true }
    end
  end

  describe "#can_be_disabled?" do
    let(:trading_item) do
      double(:trading_item,:bidder_with_lowest_proposal => subject)
    end

    it "returns true if bidder has lowest bid" do
      subject.stub(:benefited => false)

      expect(subject.can_be_disabled?(trading_item)).to be_true
    end

    it "returns false if bidder is benefited" do
      subject.stub(:benefited => true)

      expect(subject.can_be_disabled?(trading_item)).to be_false
    end
  end

  describe '#selected_for_trading_item?' do
    let(:item) { double(:item) }

    context 'when bidder is selected at proposals of trading_item' do
      before do
        item.stub(:selected_bidders_at_proposals => [subject])
      end

      it { expect(subject.selected_for_trading_item?(item)).to be_true }
    end

    context 'when bidder is not selected at proposals of trading_item' do
      before do
        item.stub(:selected_bidders_at_proposals => ['bidder2'])
      end

      it { expect(subject.selected_for_trading_item?(item)).to be_false }
    end
  end
end
