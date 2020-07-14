require 'model_helper'
require 'lib/signable'
require 'app/models/persona/person'
require 'app/models/person'
require 'app/models/bidder'
require 'app/models/bidder_proposal'
require 'app/models/bidder_document'
require 'app/models/budget_structure'
require 'app/models/licitation_process'
require 'app/models/persona/creditor'
require 'app/models/creditor'
require 'app/models/accredited_representative'
require 'app/models/licitation_process_classification'
require 'app/models/licitation_process_ratification'
require 'app/business/purchase_process_creditor_proposal_ranking'

describe Bidder do
  describe 'default values' do
    it { expect(subject.invited).to be false }
  end

  it { should belong_to :licitation_process }
  it { should belong_to :creditor }

  it { should have_many(:documents).dependent(:destroy).order(:id) }
  it { should have_many(:document_types).through(:documents) }
  it { should have_many(:accredited_representatives).dependent(:destroy) }
  it { should have_many(:people).through(:accredited_representatives) }
  it { should have_many(:licitation_process_classifications).dependent(:destroy) }
  it { should have_many(:licitation_process_classifications_by_classifiable).dependent(:destroy) }
  it { should have_many(:licitation_process_ratifications).through(:creditor) }
  it { should have_many(:items).through(:licitation_process) }

  it { should validate_presence_of :creditor }

  describe 'delegations' do
    it { should delegate(:document_type_ids).to(:licitation_process).allowing_nil(true).prefix(true) }
    it { should delegate(:process_date).to(:licitation_process).allowing_nil(true).prefix(true) }
    it { should delegate(:ratification?).to(:licitation_process).allowing_nil(true).prefix(true) }
    it { should delegate(:has_trading?).to(:licitation_process).allowing_nil(true).prefix(true) }
    it { should delegate(:year).to(:licitation_process).allowing_nil(true).prefix(true) }
    it { should delegate(:process).to(:licitation_process).allowing_nil(true).prefix(true) }

    it { should delegate(:envelope_opening?).to(:licitation_process).allowing_nil(true) }

    it { should delegate(:benefited).to(:creditor).allowing_nil(true) }
    it { should delegate(:company?).to(:creditor).allowing_nil(true) }
    it { should delegate(:identity_document).to(:creditor).allowing_nil(true) }
    it { should delegate(:name).to(:creditor).allowing_nil(true) }
    it { should delegate(:state_registration).to(:creditor).allowing_nil(true) }

    it { should delegate(:organ_responsible_for_registration).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:commercial_registration_date).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:commercial_registration_number).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:company_partners).to(:creditor).allowing_nil(true).prefix(true) }
  end

  context "licitation kind" do
    before do
      subject.stub(:judgment_form => judgment_form)
    end

    let :licitation_process do
      double('licitation_process', :ratification? => true, :judgment_form => judgment_form)
    end

    let(:judgment_form) { double(:judgment_form) }

    context "when judgment_form is best_technique" do
      before { judgment_form.stub(:best_technique?).and_return(true) }

      it { should validate_presence_of(:technical_score) }
    end

    context "when judgment_form is technical_and_price" do
      before do
        judgment_form.stub(:best_technique?).and_return(false)
        judgment_form.stub(:technical_and_price?).and_return(true)
      end

      it { should validate_presence_of(:technical_score) }
    end

    context "when judgment_form is not best_technique or technical_and_price" do
      before do
        judgment_form.stub(:best_technique?).and_return(false)
        judgment_form.stub(:technical_and_price?).and_return(false)
      end

      it { should_not validate_presence_of(:technical_score) }
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

  context 'valitation licitation_process_ratification' do
    let(:licitation_process) do
      double(:licitation_process, :administrative_process => nil,
             :judgment_form_best_technique? => true,
             :to_s => '1/2012')
    end

    it 'should not allow save when licitation_process has ratification' do
      subject.stub(:licitation_process).and_return(licitation_process)
      subject.stub(:licitation_process_ratification?).and_return(true)

      subject.valid?

      expect(subject.errors[:base]).to include 'não pode ser alterado quando o processo de compra (1/2012) vinculado estiver homologado'
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
    it 'returns true if bidder is benefited' do
      subject.stub(:benefited => true)
      expect(subject.benefited_by_law_of_proposals?).to be true
    end

    it 'returns false if bidder is not benefited' do
      subject.stub(:benefited => false)
      expect(subject.benefited_by_law_of_proposals?).to be false
    end
  end

  context '#inactivate!' do
    it 'changes the bidder enabled to Inactive' do
      subject.should_receive(:update_column).with(:enabled, false)
      subject.inactivate!
    end
  end

  context '#activate!' do
    it 'changes the bidder enabled to Active' do
      subject.should_receive(:update_column).with(:enabled, true)
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

  describe '#descroy_all_classifications' do
    let(:classifications) { double(:licitation_process_classifications) }

    it 'should call destroy_all classifications' do
      subject.stub(:licitation_process_classifications).and_return(classifications)

      classifications.should_receive(:destroy_all)

      subject.destroy_all_classifications
    end
  end

  context 'with documents' do
    let(:purchase_document) { double(:purchase_document, :purchase_document? => true) }
    let(:bidder_document) { double(:bidder_document, :purchase_document? => false) }

    before do
      subject.stub(:documents => [bidder_document, purchase_document])
    end

    describe '#bidder_documents' do
      it 'should return all documents where purchase_document is false' do
        expect(subject.bidder_documents).to eq [bidder_document]
      end
    end

    describe '#purchase_process_documents' do
      it 'should return all documents where purchase_document is false' do
        expect(subject.purchase_process_documents).to eq [purchase_document]
      end
    end

    it 'should not allow document_type duplications' do
      errors = double(:errors)
      purchase_document.stub(:document_type_id => 19, :marked_for_destruction? => false)
      bidder_document.stub(:document_type_id => 19, :marked_for_destruction? => false)

      purchase_document.should_receive(:errors).and_return(errors)
      errors.should_receive(:add).with(:document_type_id, :taken)

      expect(subject.valid?).to be_false

      expect(subject.errors[:documents]).to include('não é válido')
    end
  end

  describe '#update_proposal_ranking' do
    let(:proposal)  { double :proposal }
    let(:proposals) { [proposal] }
    let(:licitation_process) { double :licitation_process }
    let(:creditor) { double :creditor }

    before do
      subject.stub(:enabled_changed?).and_return true
      subject.stub(:creditor).and_return creditor
      subject.stub(:licitation_process).and_return licitation_process

      licitation_process.should_receive(:proposals_of_creditor).with(creditor).and_return proposals
    end

    it 'calls PurchaseProcessCreditorProposalRanking with the bidder proposals' do
      PurchaseProcessCreditorProposalRanking.should_receive(:rank!).with proposal
      subject.run_callbacks(:save)
    end
  end

end
