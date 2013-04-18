# encoding: utf-8
require 'model_helper'
require 'lib/signable'
require 'app/models/persona/person'
require 'app/models/person'
require 'app/models/licitation_process'
require 'app/models/payment_method'
require 'app/models/administrative_process_budget_allocation'
require 'app/models/purchase_process_item'
require 'app/models/licitation_process_publication'
require 'app/models/bidder'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process_appeal'
require 'app/models/licitation_process_ratification'
require 'app/models/budget_allocation'
require 'app/models/pledge'
require 'app/models/judgment_commission_advice'
require 'app/models/creditor'
require 'app/models/licitation_notice'
require 'app/models/licitation_process_lot'
require 'app/business/licitation_process_envelope_opening_date'
require 'app/models/reserve_fund'
require 'app/models/indexer'
require 'app/models/price_registration'
require 'app/models/trading'
require 'app/models/purchase_solicitation_item'
require 'app/models/legal_analysis_appraisal'
require 'app/models/purchase_process_accreditation'
require 'app/models/purchase_process_creditor_proposal'

describe LicitationProcess do
  let(:current_prefecture) { double(:current_prefecture) }

  before do
    subject.stub(:current_prefecture => current_prefecture)
    current_prefecture.stub(:allow_insert_past_processes => true)
  end

  it 'should return process/year - modality modality_number as to_s' do
    subject.process = '1'
    subject.year = '2012'
    subject.modality_number = '1'
    subject.stub(:modality_humanize).and_return 'Pregão'
    expect(subject.to_s).to eq '1/2012 - Pregão 1'
  end

  it { should belong_to :contact }
  it { should belong_to :judgment_form }
  it { should belong_to :payment_method }
  it { should belong_to :readjustment_index }

  it { should have_and_belong_to_many(:document_types) }
  it { should have_and_belong_to_many(:purchase_solicitations) }
  it { should have_many(:licitation_notices).dependent(:destroy) }
  it { should have_many(:licitation_process_publications).dependent(:destroy).order(:id) }
  it { should have_many(:bidders).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_impugnments).dependent(:restrict).order(:id) }
  it { should have_many(:licitation_process_appeals).dependent(:restrict) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:judgment_commission_advices).dependent(:restrict) }
  it { should have_many(:license_creditors).dependent(:restrict).through(:bidders) }
  it { should have_many(:accreditation_creditors).through(:purchase_process_accreditation) }

  it { should have_many(:licitation_process_lots).dependent(:destroy).order(:id) }
  it { should have_many(:reserve_funds).dependent(:restrict) }
  it { should have_many(:price_registrations).dependent(:restrict) }
  it { should have_many(:licitation_process_ratifications).dependent(:restrict) }
  it { should have_many(:classifications).through(:bidders) }
  it { should have_many(:classifications).through(:bidders) }
  it { should have_many(:administrative_process_budget_allocations).dependent(:destroy) }
  it { should have_many(:items).dependent(:restrict)}
  it { should have_many(:materials).through(:items) }
  it { should have_many(:legal_analysis_appraisals).dependent(:restrict) }
  it { should have_many(:budget_allocations).through(:administrative_process_budget_allocations) }
  it { should have_many(:creditor_proposals).through(:items) }

  it { should have_one(:purchase_process_accreditation).dependent(:restrict) }
  it { should have_one(:trading).dependent(:restrict) }

  describe 'default values' do
    it 'total_value_of_items should be 0.0' do
      expect(subject.total_value_of_items).to eq BigDecimal('0.0')
    end

    it 'budget_allocations_total_value should be 0.0' do
      expect(subject.budget_allocations_total_value).to eq BigDecimal('0.0')
    end
  end

  it { should validate_presence_of :contract_guarantees }
  it { should validate_presence_of :description }
  it { should validate_presence_of :execution_type }
  it { should validate_presence_of :expiration }
  it { should validate_presence_of :expiration_unit }
  it { should validate_presence_of :object_type }
  it { should validate_presence_of :payment_method }
  it { should validate_presence_of :period }
  it { should validate_presence_of :period_unit }
  it { should validate_presence_of :process_date }
  it { should validate_presence_of :type_of_purchase }
  it { should validate_presence_of :year }

  it { should_not validate_presence_of :proposal_envelope_opening_date }
  it { should_not validate_presence_of :proposal_envelope_opening_time }
  it { should_not validate_presence_of :modality }
  it { should_not validate_presence_of :judgment_form_id }
  it { should_not validate_presence_of :type_of_removal }
  it { should_not validate_presence_of :goal }
  it { should_not validate_presence_of :licensor_rights_and_liabilities }
  it { should_not validate_presence_of :licensee_rights_and_liabilities }

  context "when is a licitation" do
    before do
      subject.type_of_purchase = LicitationProcessTypeOfPurchase::LICITATION
    end

    it { should validate_presence_of :modality }
    it { should validate_presence_of :judgment_form_id }
  end

  context "when is a licitation" do
    before do
      subject.object_type = LicitationProcessObjectType::CONCESSIONS_AND_PERMITS
    end

    it { should validate_presence_of :goal }
    it { should validate_presence_of :licensor_rights_and_liabilities }
    it { should validate_presence_of :licensee_rights_and_liabilities }
  end

  context "when is a direct purchase" do
    before do
      subject.type_of_purchase = LicitationProcessTypeOfPurchase::DIRECT_PURCHASE
    end

    it { should validate_presence_of :type_of_removal }
  end

  context "when updating a record" do
    before do
      subject.stub(:validation_context).and_return(:update)
    end

    context "model validations" do
      before do
        subject.stub(:validate_proposal_envelope_opening_date).and_return true
      end

      it { should allow_value("11:11").for(:proposal_envelope_opening_time) }
    end

    describe "#validate_proposal_envelope_opening_date" do
      it "return when envelope opening date is not present" do
        subject.stub(:proposal_envelope_opening_date).and_return nil
        LicitationProcessEnvelopeOpeningDate.should_not_receive :new
        subject.send(:validate_proposal_envelope_opening_date)
        expect(subject.errors[:proposal_envelope_opening_date]).to_not include("deve ficar em branco")
      end

      it "envelope opening date should be blank when has not a publication" do
        subject.stub(:proposal_envelope_opening_date).and_return Date.current
        subject.stub(:last_publication_date).and_return nil

        subject.send(:validate_proposal_envelope_opening_date)
        expect(subject.errors[:proposal_envelope_opening_date]).to include("deve ficar em branco")
      end

      it "validates the envelope opening date with the validation poro" do
        subject.stub(:proposal_envelope_opening_date).and_return Date.current
        subject.stub(:last_publication_date).and_return Date.current
        licitation_validation = double :licitation_process_proposal_envelope_opening_date
        LicitationProcessEnvelopeOpeningDate.should_receive(:new).with(subject).and_return licitation_validation
        licitation_validation.should_receive :valid?
        subject.send(:validate_proposal_envelope_opening_date)
      end
    end

    describe '#creditors' do
      context 'when modality trading' do
        before { subject.stub(:trading?).and_return true }

        it 'returns license creditors from bidders' do
          license_creditor = double :license_creditors
          subject.stub(:license_creditors).and_return [license_creditor]

          expect(subject.creditors).to eql [license_creditor]
        end
      end

      context 'when modality is not trading' do
        before { subject.stub(:trading?).and_return false }

        it 'returns creditors from accreditation' do
          accreditation_creditors = double :accreditation_creditors
          subject.stub(:accreditation_creditors).and_return [accreditation_creditors]

          expect(subject.creditors).to eql [accreditation_creditors]
        end
      end
    end

    describe "#validate_the_year_to_processe_date_are_the_same" do
      context 'when process_date_year is equals to year' do
        before do
          subject.stub(:process_date_year => 2013)
          subject.stub(:year => 2013)
        end

        it 'should be valid' do
          subject.valid?

          expect(subject.errors[:process_date]).to_not include('não pode trocar o ano da data de expedição')
        end
      end

      context 'when process_date_year is not equals to year' do
        before do
          subject.stub(:process_date => 2013)
          subject.stub(:year => 2012)
        end

        it 'should not be valid' do
          expect(subject).to_not be_valid

          expect(subject.errors[:process_date]).to include('não pode trocar o ano da data de expedição')
        end
      end
    end
  end

  describe '#process_date_year' do
    context 'when process_date is nil' do
      it 'should return nil' do
        expect(subject.process_date_year).to be_nil
      end
    end

    context 'when process_date is not nil' do
      it 'should return the year of process_date' do
        subject.process_date = Date.new(2013, 10, 10)

        expect(subject.process_date_year).to eq 2013
      end
    end
  end

  describe 'default values' do
    it { expect(subject.price_registration).to be false }
  end

  context 'new_proposal_envelope_opening_date is not equal to new_envelope_delivery_date' do
    it { should allow_value("11:11").for(:envelope_delivery_time) }
    it { should_not allow_value("44:11").for(:envelope_delivery_time) }
  end

  context 'when prefecture allow_insert_past_processes is true' do
    context 'validate envelope_delivery_date related with today' do
      it { should allow_value(Date.current).for(:envelope_delivery_date) }

      it { should allow_value(Date.tomorrow).for(:envelope_delivery_date) }

      it 'should allow envelope_delivery_date before today' do
        expect(subject).to allow_value(Date.yesterday).for(:envelope_delivery_date)
      end
    end
  end

  context 'when prefecture allow_insert_past_processes is false' do
    before do
      subject.stub(:current_prefecture => current_prefecture)
      current_prefecture.stub(:allow_insert_past_processes => false)
    end

    context 'validate envelope_delivery_date related with today' do
      it { should allow_value(Date.current).for(:envelope_delivery_date) }

      it { should allow_value(Date.tomorrow).for(:envelope_delivery_date) }

      it 'should not allow envelope_delivery_date before today' do
        expect(subject).not_to allow_value(Date.yesterday).for(:envelope_delivery_date).
                                                      with_message("deve ser igual ou posterior a data atual (#{I18n.l(Date.current)})")
      end
    end
  end

  context 'validate proposal_envelope_opening_date related with envelope_delivery_date' do
    let :envelope_delivery_date do
      Date.current + 10.days
    end

    before do
      subject.stub(:envelope_delivery_date).and_return(envelope_delivery_date)
    end

    it 'should allow proposal_envelope_opening_date date after envelope_delivery_date' do
      expect(subject).to allow_value(Date.current + 15.days).for(:proposal_envelope_opening_date)
    end

    it 'should allow proposal_envelope_opening_date date equals to envelope_delivery_date' do
      expect(subject).to allow_value(envelope_delivery_date).for(:proposal_envelope_opening_date)
    end

    it 'should not allow proposal_envelope_opening_date date before envelope_delivery_date' do
      expect(subject).not_to allow_value(Date.current).for(:proposal_envelope_opening_date).
                                                    with_message("deve ser igual ou posterior a data da entrega dos envelopes (#{I18n.l envelope_delivery_date})")
    end
  end

  it "validates if bidders where added before publication" do
    subject.stub(:bidders => [double])

    subject.valid?

    expect(subject.errors[:base]).to include "Licitantes não podem ser incluídos antes da publicação do edital"
  end

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201').for(:year) }
  it { should_not allow_value('a201').for(:year) }

  it "validate attribute changes if not updatable" do
    subject.stub(:updatable? => false)
    subject.year = 2014

    subject.valid?

    expect(subject.errors[:base]).to include "não pode ser editado"
  end

  it 'should tell if it allow invitation bidders' do
    subject.stub(:proposal_envelope_opening_date).and_return(Date.tomorrow)

    expect(subject).not_to be_allow_bidders

    subject.stub(:proposal_envelope_opening_date).and_return(Date.current)

    expect(subject).to be_allow_bidders

    subject.stub(:proposal_envelope_opening_date).and_return(Date.yesterday)

    expect(subject).not_to be_allow_bidders
   end

  it 'should return the advice number correctly' do
    subject.stub(:judgment_commission_advices).and_return([1, 2, 3])

    expect(subject.advice_number).to eq 3
  end

  context "when proposal_envelope_opening_date is not the current date" do
    it "should return false for envelope_opening? method" do
      subject.proposal_envelope_opening_date = Date.tomorrow

      expect(subject).not_to be_envelope_opening
    end
  end

  context "when proposal_envelope_opening_date is the current date" do
    it "should return true for envelope_opening? method" do
      subject.proposal_envelope_opening_date = Date.current

      expect(subject).to be_envelope_opening
    end
  end

  it "should have filled lots" do
    subject.stub(:items).and_return(true)
    subject.items.stub(:without_lot?).and_return(false)
    expect(subject).to be_filled_lots
  end

  context 'lots with items' do
    let :lot_with_items do
      [double("LicitationProcessLot", :purchase_process_items => [double("LicitationProcessLotItem")],
              :bidder_proposals => [double]),
       double("LicitationProcessLot", :purchase_process_items => [],
              :bidder_proposals => [double])]
    end

    it 'should filter lots with items' do
      subject.should_receive(:licitation_process_lots).and_return(lot_with_items)

      expect(subject.lots_with_items.size).to eq 1
    end
  end

  context 'has bidders and is available for classification' do
    it 'should return true' do
      subject.stub(:bidders => [double])
      subject.stub(:available_for_licitation_process_classification? => true)

      expect(subject.has_bidders_and_is_available_for_classification).to be true
    end

    it 'should return false' do
      subject.stub(:bidders => [])
      subject.stub(:available_for_licitation_process_classification? => true)

      expect(subject.has_bidders_and_is_available_for_classification).to be false
    end

    it 'should return false' do
      subject.stub(:bidders => [double])
      subject.stub(:available_for_licitation_process_classification? => false)

      expect(subject.has_bidders_and_is_available_for_classification).to be false
    end
  end

  context "#winning_bid" do
    it 'returns the classification that has won the bid' do
      classification_1 = double(:classification, :situation => SituationOfProposal::LOST)
      classification_2 = double(:classification, :situation => SituationOfProposal::WON)

      subject.stub(:all_licitation_process_classifications => [classification_1, classification_2])

      expect(subject.winning_bid).to eq classification_2
    end
  end

  describe "#edital_published?" do
    it "returns true if there are any published editals" do
      publications = double(:edital => [double])
      subject.stub(:licitation_process_publications => publications)

      expect(subject.edital_published?).to be_true
    end
  end

  describe "#updatable" do

    let(:ratifications) { double(:empty? => true) }

    let(:publications) do
      double(:empty? => true,
             :current_updatable? => true)
    end

    before do
      subject.stub(:licitation_process_publications => publications)
      subject.stub(:licitation_process_ratifications => ratifications)
      subject.stub(:new_record? => false)
    end

    it "returns true if it's a new record" do
      subject.stub(:new_record? => true)

      expect(subject).to be_updatable
    end

    it "returns true if there are no ratifications" do
      ratifications.stub(:empty? => true)

      expect(subject).to be_updatable
    end

    it "returns true if there are no publications" do
      publications.stub(:empty? => true)

      expect(subject).to be_updatable
    end

    it "returns true if publications are updatable" do
      publications.stub(:current_updatable? => true)

      expect(subject).to be_updatable
    end

    it "returns false otherwise" do
      publications.stub(:current_updatable? => false,
                        :empty? => false)
      ratifications.stub(:empty? => false)

      expect(subject).not_to be_updatable
    end
  end

  describe '#ratification?' do
    it 'should be true when have any licitation_process_ratifications' do
      subject.stub(:licitation_process_ratifications).and_return(['ratification'])

      expect(subject.ratification?).to be_true
    end

    it 'should be false when have anyone licitation_process_ratifications' do
      subject.stub(:licitation_process_ratifications).and_return([])

      expect(subject.ratification?).to be_false
    end
  end

  describe '#update_status' do
    it 'should update status' do
      subject.should_receive(:update_column).with(:status, LicitationProcessStatus::IN_PROGRESS)

      subject.update_status(LicitationProcessStatus::IN_PROGRESS)
    end
  end

  describe '#has_trading?' do
    context 'when trading is not present' do
      it { expect(subject.has_trading?).to be_false }
    end

    context 'when trading is present' do
      let(:trading) { double(:trading) }

      before do
        subject.stub(:trading => trading)
      end

      it { expect(subject.has_trading?).to be_true }
    end
  end

  describe "#last_publication_date" do
    it "returns the publication date from the last publication" do
      subject.stub_chain(:licitation_process_publications, :empty?).and_return false
      subject.stub_chain(:licitation_process_publications, :current).and_return double(:licitation_process_publications, :publication_date => Date.tomorrow)
      expect(subject.last_publication_date).to eql Date.tomorrow
    end
  end

  describe '#update_purchase_solicitation_to_purchase_process' do
    let(:purchase_solicitation) { double(:purchase_solicitation) }

    it "updates the purchase solicitation service_status to in_purchase_process" do
      purchase_solicitation.stub(:new_record?).and_return false
      purchase_solicitation.should_receive(:buy!)
      subject.send(:update_purchase_solicitation_to_purchase_process, purchase_solicitation)
    end
  end

  describe '#update_purchase_solicitation_to_liberated' do
    let(:purchase_solicitation) { double(:purchase_solicitation) }

    it "updates the purchase solicitation service_status to liberated" do
      purchase_solicitation.should_receive(:liberate!)
      subject.send(:update_purchase_solicitation_to_liberated, purchase_solicitation)
    end
  end

  describe 'when save' do
    describe "and has not items" do
      it "total_value_of_items= has not called" do
        subject.stub(:items).and_return(nil)
        subject.should_not_receive(:total_value_of_items=)

        subject.run_callbacks(:save)
      end
    end

    describe "and has items" do
      let(:items) { [item1, item2, item3] }

      let(:item1) do
        double(:items1,
               :marked_for_destruction? => true,
               :estimated_total_price => 100
              )
      end

      let(:item2) do
        double(:items2,
               :marked_for_destruction? => false,
               :estimated_total_price => 50
              )
      end

      let(:item3) do
        double(:items3,
               :marked_for_destruction? => false,
               :estimated_total_price => 10
              )
      end

      it "should return tota_value_of_items" do
        subject.stub(:items).and_return(items)

        subject.run_callbacks(:save)

        expect(subject.total_value_of_items).to eq 60
      end
    end

    describe "and not has budget allocations" do
      it "budget_allocations_total_value= has not called" do
        subject.stub(:administrative_process_budget_allocations).and_return([])
        subject.should_not_receive(:budget_allocations_total_value=)

        subject.run_callbacks(:save)
      end
    end

    describe "and has budget allocations" do
      let(:budget_allocation1) do
        double(:budget_allocation1,
               :marked_for_destruction? => false,
               :value => 5
              )
      end

      let(:budget_allocation2) do
        double(:budget_allocation2,
               :marked_for_destruction? => true,
               :value => 10
              )
      end

      let(:budget_allocation3) do
        double(:budget_allocation3,
               :marked_for_destruction? => false,
               :value => 5
              )
      end

      it "should return budget_allocations_total_value" do
        subject.stub(:administrative_process_budget_allocations).and_return([budget_allocation1, budget_allocation2, budget_allocation3])
        subject.run_callbacks(:save)

        expect(subject.budget_allocations_total_value).to eq 10
      end
    end
  end
end
