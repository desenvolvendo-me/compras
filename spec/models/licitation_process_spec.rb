# encoding: utf-8
require 'model_helper'
require 'lib/signable'
require 'app/models/licitation_process'
require 'app/models/capability'
require 'app/models/payment_method'
require 'app/models/administrative_process_budget_allocation'
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
require 'app/business/licitation_process_types_of_calculation_by_judgment_form_kind'
require 'app/business/licitation_process_types_of_calculation_by_object_type'
require 'app/business/licitation_process_types_of_calculation_by_modality'
require 'app/business/licitation_process_envelope_opening_date'
require 'app/models/reserve_fund'
require 'app/models/indexer'
require 'app/models/price_registration'
require 'app/models/trading'
require 'app/models/delivery_location'
require 'app/models/purchase_solicitation_budget_allocation_item'

describe LicitationProcess do
  let(:current_prefecture) { double(:current_prefecture) }

  before do
    subject.stub(:current_prefecture => current_prefecture)
    current_prefecture.stub(:allow_insert_past_processes => true)
  end

  it 'should return process/year as to_s' do
    subject.process = '1'
    subject.year = '2012'
    expect(subject.to_s).to eq '1/2012'
  end

  it { should belong_to :capability }
  it { should belong_to :payment_method }
  it { should belong_to :readjustment_index }
  it { should belong_to :judgment_form }
  it { should belong_to :delivery_location }
  it { should belong_to :purchase_solicitation }
  it { should belong_to :purchase_solicitation_item_group }
  it { should belong_to :responsible }

  it { should have_and_belong_to_many(:document_types) }
  it { should have_many(:licitation_notices).dependent(:destroy) }
  it { should have_many(:licitation_process_publications).dependent(:destroy).order(:id) }
  it { should have_many(:bidders).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_impugnments).dependent(:restrict).order(:id) }
  it { should have_many(:licitation_process_appeals).dependent(:restrict) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:judgment_commission_advices).dependent(:restrict) }
  it { should have_many(:creditors).dependent(:restrict).through(:bidders) }
  it { should have_many(:licitation_process_lots).dependent(:destroy).order(:id) }
  it { should have_many(:reserve_funds).dependent(:restrict) }
  it { should have_many(:price_registrations).dependent(:restrict) }
  it { should have_many(:licitation_process_ratifications).dependent(:restrict) }
  it { should have_many(:classifications).through(:bidders) }
  it { should have_many(:classifications).through(:bidders) }
  it { should have_many(:administrative_process_budget_allocations).dependent(:destroy) }
  it { should have_many(:items).through(:administrative_process_budget_allocations) }
  it { should have_many(:materials).through(:items) }
  it { should have_many(:purchase_solicitation_items) }

  it { should have_one(:trading).dependent(:restrict) }

  it { should validate_presence_of :year }
  it { should validate_presence_of :process_date }
  it { should validate_presence_of :period }
  it { should validate_presence_of :capability }
  it { should validate_presence_of :pledge_type }
  it { should validate_presence_of :type_of_calculation }
  it { should validate_presence_of :execution_type }
  it { should validate_presence_of :object_type }
  it { should validate_presence_of :modality }
  it { should validate_presence_of :judgment_form_id }
  it { should validate_presence_of :responsible }
  it { should validate_presence_of :description }
  it { should validate_presence_of :expiration }
  it { should validate_presence_of :expiration_unit }
  it { should validate_presence_of :period_unit }
  it { should validate_presence_of :payment_method }

  it { should_not validate_presence_of :envelope_opening_date }
  it { should_not validate_presence_of :envelope_opening_time }

  context "when updating a record" do
    before do
      subject.stub(:validation_context).and_return(:update)
    end

    context "model validations" do
      before do
        subject.stub(:validate_envelope_opening_date).and_return true
      end

      it { should allow_value("11:11").for(:envelope_opening_time) }
    end

    describe "#validate_envelope_opening_date" do
      it "return when envelope opening date is not present" do
        subject.stub(:envelope_opening_date).and_return nil
        LicitationProcessEnvelopeOpeningDate.should_not_receive :new
        subject.send(:validate_envelope_opening_date)
        expect(subject.errors[:envelope_opening_date]).to_not include("deve ficar em branco")
      end

      it "envelope opening date should be blank when has not a publication" do
        subject.stub(:envelope_opening_date).and_return Date.today
        subject.stub(:last_publication_date).and_return nil

        subject.send(:validate_envelope_opening_date)
        expect(subject.errors[:envelope_opening_date]).to include("deve ficar em branco")
      end

      it "validates the envelope opening date with the validation poro" do
        subject.stub(:envelope_opening_date).and_return Date.today
        subject.stub(:last_publication_date).and_return Date.today
        licitation_validation = double :licitation_process_envelope_opening_date
        LicitationProcessEnvelopeOpeningDate.should_receive(:new).with(subject).and_return licitation_validation
        licitation_validation.should_receive :valid?
        subject.send(:validate_envelope_opening_date)
      end
    end
  end

  describe 'default values' do
    it { expect(subject.consider_law_of_proposals).to be false }
    it { expect(subject.disqualify_by_documentation_problem).to be false }
    it { expect(subject.disqualify_by_maximum_value).to be false }
    it { expect(subject.price_registration).to be false }
  end

  context 'new_envelope_opening_date is not equal to new_envelope_delivery_date' do
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

  context 'validate envelope_opening_date related with envelope_delivery_date' do
    let :envelope_delivery_date do
      Date.current + 10.days
    end

    before do
      subject.stub(:envelope_delivery_date).and_return(envelope_delivery_date)
    end

    it 'should allow envelope_opening_date date after envelope_delivery_date' do
      expect(subject).to allow_value(Date.current + 15.days).for(:envelope_opening_date)
    end

    it 'should allow envelope_opening_date date equals to envelope_delivery_date' do
      expect(subject).to allow_value(envelope_delivery_date).for(:envelope_opening_date)
    end

    it 'should not allow envelope_opening_date date before envelope_delivery_date' do
      expect(subject).not_to allow_value(Date.current).for(:envelope_opening_date).
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
    subject.stub(:updatable? => false,
                 :changed_attributes => [double])

    subject.valid?

    expect(subject.errors[:base]).to include "não pode ser editado"
  end

  describe '#next_licitation_number' do
    context 'when the licitation_number of last licitation process is 4' do
      before do
        subject.stub(:last_licitation_number_of_self_year_and_modality).and_return(4)
      end

      it 'should be 5' do
        expect(subject.next_licitation_number).to eq 5
      end
    end
  end

  it 'should tell if it allow invitation bidders' do
    subject.stub(:envelope_opening_date).and_return(Date.tomorrow)

    expect(subject).not_to be_allow_bidders

    subject.stub(:envelope_opening_date).and_return(Date.current)

    expect(subject).to be_allow_bidders

    subject.stub(:envelope_opening_date).and_return(Date.yesterday)

    expect(subject).not_to be_allow_bidders
   end

  it 'should return the advice number correctly' do
    subject.stub(:judgment_commission_advices).and_return([1, 2, 3])

    expect(subject.advice_number).to eq 3
  end

  context "when envelope_opening_date is not the current date" do
    it "should return false for envelope_opening? method" do
      subject.envelope_opening_date = Date.tomorrow

      expect(subject).not_to be_envelope_opening
    end
  end

  context "when envelope_opening_date is the current date" do
    it "should return true for envelope_opening? method" do
      subject.envelope_opening_date = Date.current

      expect(subject).to be_envelope_opening
    end
  end

  it "should validate type_of_calculation by judgment_form_kind" do
    subject.stub(:judgment_form_kind).and_return('any')
    subject.stub(:type_of_calculation).and_return('lowest_total_price_by_item')

    LicitationProcessTypesOfCalculationByJudgmentFormKind.any_instance.stub(:correct_type_of_calculation?).and_return(false)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).to include 'não permitido para este tipo de julgamento (Menor preço total por item)'

    LicitationProcessTypesOfCalculationByJudgmentFormKind.any_instance.stub(:correct_type_of_calculation?).and_return(true)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).not_to include 'não permitido para este tipo de julgamento (Menor preço total por item)'
  end

  it "should validate type_of_calculation by object type" do
    subject.stub(:object_type).and_return('any')
    subject.stub(:type_of_calculation).and_return('lowest_total_price_by_item')

    LicitationProcessTypesOfCalculationByObjectType.any_instance.stub(:correct_type_of_calculation?).and_return(false)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).to include 'não permitido para este tipo de objeto (Menor preço total por item)'

    LicitationProcessTypesOfCalculationByObjectType.any_instance.stub(:correct_type_of_calculation?).and_return(true)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).not_to include 'não permitido para este tipo de objeto (Menor preço total por item)'
  end

  describe 'validate type_of_calculation by modality' do
    it 'should not allow lowest_total_price_by_item as type_of_calculation when modality is trading' do
      subject.stub(:modality => Modality::TRADING)
      subject.stub(:type_of_calculation => LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)

      LicitationProcessTypesOfCalculationByModality.
        any_instance.should_receive(:correct_type_of_calculation?).
        with(Modality::TRADING, LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM).
        and_return(false)

      subject.valid?

      expect(subject.errors[:type_of_calculation]).to include 'não permitido para esta modalidade (Menor preço total por item)'
    end

    it 'should allow lowest_total_price_by_item as type_of_calculation when modality is trading' do
      subject.stub(:modality => Modality::TRADING)
      subject.stub(:type_of_calculation => LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM)

      LicitationProcessTypesOfCalculationByModality.
        any_instance.should_receive(:correct_type_of_calculation?).
        with(Modality::TRADING, LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM).
        and_return(true)

      subject.valid?

      expect(subject.errors[:type_of_calculation]).to_not include 'não permitido para esta modalidade'
    end

    it 'should allow lowest_global_price as type_of_calculation when modality is auction' do
      subject.stub(:modality => Modality::AUCTION)
      subject.stub(:type_of_calculation => LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE)

      LicitationProcessTypesOfCalculationByModality.
        any_instance.should_receive(:correct_type_of_calculation?).
        with(Modality::AUCTION, LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE).
        and_return(true)

      subject.valid?

      expect(subject.errors[:type_of_calculation]).to_not include 'não permitido para esta modalidade'
    end

    it 'should allow lowest_global_price as type_of_calculation when modality is auction' do
      subject.stub(:modality => Modality::AUCTION)
      subject.stub(:type_of_calculation => LicitationProcessTypeOfCalculation::LOWEST_PRICE_BY_LOT)

      LicitationProcessTypesOfCalculationByModality.
        any_instance.should_receive(:correct_type_of_calculation?).
        with(Modality::AUCTION, LicitationProcessTypeOfCalculation::LOWEST_PRICE_BY_LOT).
        and_return(true)

      subject.valid?

      expect(subject.errors[:type_of_calculation]).to_not include 'não permitido para esta modalidade'
    end

    it 'should not allow lowest_total_price_by_item as type_of_calculation when modality is auction' do
      subject.stub(:modality => Modality::AUCTION)
      subject.stub(:type_of_calculation => LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)

      LicitationProcessTypesOfCalculationByModality.
        any_instance.should_receive(:correct_type_of_calculation?).
        with(Modality::AUCTION, LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM).
        and_return(false)

      subject.valid?

      expect(subject.errors[:type_of_calculation]).to include 'não permitido para esta modalidade (Menor preço total por item)'
    end
  end

  it "should have filled lots" do
    subject.stub(:items).and_return(true)
    subject.items.stub(:without_lot?).and_return(false)
    expect(subject).to be_filled_lots
  end

  context 'lots with items' do
    let :lot_with_items do
      [double("LicitationProcessLot", :administrative_process_budget_allocation_items => [double("LicitationProcessLotItem")],
              :bidder_proposals => [double]),
       double("LicitationProcessLot", :administrative_process_budget_allocation_items => [],
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

  describe '#ratification_date' do
    let(:ratification) do
      double(:ratification, :ratification_date => Date.today)
    end

    it 'should returns the ratification_date from first ratification' do
      subject.stub(:licitation_process_ratifications).and_return([ratification, 'ratification2'])

      expect(subject.ratification_date).to eq  Date.today
    end

    it 'should returns nil when there is no ratification' do
      subject.stub(:licitation_process_ratifications).and_return([])

      expect(subject.ratification_date).to be_nil
    end
  end

  describe '#adjudication_date' do
    let(:ratification) do
      double(:ratification, :adjudication_date => Date.today)
    end

    it 'should returns the ratification_date from first ratification' do
      subject.stub(:licitation_process_ratifications).and_return([ratification, 'ratification2'])

      expect(subject.adjudication_date).to eq Date.today
    end

    it 'should returns nil when there is no ratification' do
      subject.stub(:licitation_process_ratifications).and_return([])

      expect(subject.adjudication_date).to be_nil
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

  describe '#fulfill_purchase_solicitation_items' do
    before do
      subject.should_receive(:purchase_solicitation_items).
              and_return([item, item2])
    end

    let(:item)  { double(:item) }
    let(:item2) { double(:item2) }

    it 'should fulfill items' do
      item.should_receive(:fulfill).with(subject)
      item2.should_receive(:fulfill).with(subject)

      subject.fulfill_purchase_solicitation_items
    end
  end

  describe '#remove_fulfill_purchase_solicitation_items' do
    before do
      subject.should_receive(:purchase_solicitation_items).
              and_return([item, item2])
    end

    let(:item)  { double(:item) }
    let(:item2) { double(:item2) }

    it 'should fulfill items' do
      item.should_receive(:fulfill).with(nil)
      item2.should_receive(:fulfill).with(nil)

      subject.remove_fulfill_purchase_solicitation_items
    end
  end
end
