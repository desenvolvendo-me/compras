# encoding: utf-8
require 'model_helper'
require 'lib/signable'
require 'app/models/licitation_process'
require 'app/models/administrative_process'
require 'app/models/capability'
require 'app/models/payment_method'
require 'app/models/licitation_process_publication'
require 'app/models/licitation_process_bidder'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process_appeal'
require 'app/models/budget_allocation'
require 'app/models/pledge'
require 'app/models/judgment_commission_advice'
require 'app/models/creditor'
require 'app/models/licitation_notice'
require 'app/models/licitation_process_lot'
require 'app/business/licitation_process_types_of_calculation_by_judgment_form_kind'
require 'app/business/licitation_process_types_of_calculation_by_object_type'
require 'app/business/licitation_process_types_of_calculation_by_modality'
require 'app/models/reserve_fund'
require 'app/models/indexer'
require 'app/models/record_price'

describe LicitationProcess do
  it 'should return process/year as to_s' do
    subject.process = '1'
    subject.year = '2012'
    expect(subject.to_s).to eq '1/2012'
  end

  it { should belong_to :administrative_process }
  it { should belong_to :capability }
  it { should belong_to :payment_method }
  it { should belong_to :readjustment_index }
  it { should belong_to :judgment_form }

  it { should have_and_belong_to_many(:document_types) }
  it { should have_many(:licitation_notices).dependent(:destroy) }
  it { should have_many(:licitation_process_publications).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_bidders).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_impugnments).dependent(:restrict).order(:id) }
  it { should have_many(:licitation_process_appeals).dependent(:restrict) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:judgment_commission_advices).dependent(:restrict) }
  it { should have_many(:creditors).dependent(:restrict).through(:licitation_process_bidders) }
  it { should have_many(:licitation_process_lots).dependent(:destroy).order(:id) }
  it { should have_many(:reserve_funds).dependent(:restrict) }
  it { should have_many(:record_prices).dependent(:restrict) }

  it { should validate_presence_of :year }
  it { should validate_presence_of :process_date }
  it { should validate_presence_of :administrative_process }
  it { should validate_presence_of :capability }
  it { should validate_presence_of :expiration }
  it { should validate_presence_of :expiration_unit }
  it { should validate_presence_of :period }
  it { should validate_presence_of :period_unit }
  it { should validate_presence_of :payment_method }
  it { should validate_presence_of :envelope_delivery_date }
  it { should validate_presence_of :envelope_delivery_time }
  it { should validate_presence_of :envelope_opening_date }
  it { should validate_presence_of :envelope_opening_time }
  it { should validate_presence_of :pledge_type }
  it { should validate_presence_of :type_of_calculation }

  describe 'default values' do
    it { expect(subject.consider_law_of_proposals).to be false }
    it { expect(subject.disqualify_by_documentation_problem).to be false }
    it { expect(subject.disqualify_by_maximum_value).to be false }
    it { expect(subject.price_registration).to be false }
  end

  context 'new_envelope_opening_date is not equal to new_envelope_delivery_date' do
    before do
      subject.stub(:new_envelope_opening_date_equal_new_envelope_delivery_date?).and_return(false)
    end

    it { should allow_value("11:11").for(:envelope_delivery_time) }
    it { should_not allow_value("44:11").for(:envelope_delivery_time) }
    it { should allow_value("11:11").for(:envelope_opening_time) }
    it { should_not allow_value("44:11").for(:envelope_opening_time) }
  end

  context 'validate envelope_delivery_date related with today' do
    it { should allow_value(Date.current).for(:envelope_delivery_date) }

    it { should allow_value(Date.tomorrow).for(:envelope_delivery_date) }

    it 'should not allow envelope_delivery_date before today' do
      expect(subject).not_to allow_value(Date.yesterday).for(:envelope_delivery_date).
                                                    with_message("deve ser igual ou posterior a data atual (#{I18n.l(Date.current)})")
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

  context 'validate process_date related with administrative_process_date' do
    let :administrative_process_date do
      Date.current + 10.days
    end

    before do
      subject.stub(:administrative_process_date).and_return(administrative_process_date)
    end

    it 'should allow process_date after administrative_process_date' do
      expect(subject).to allow_value(Date.current + 15.days).for(:process_date)
    end

    it 'should allow process_date equals to administrative_process_date' do
      expect(subject).to allow_value(administrative_process_date).for(:process_date)
    end

    it 'should not allow process_date before administrative_process_date' do
      expect(subject).not_to allow_value(Date.current).for(:process_date).
                                                   with_message("deve ser igual ou posterior a data do processo administrativo (#{I18n.l administrative_process_date})")
    end
  end

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201').for(:year) }
  it { should_not allow_value('a201').for(:year) }

  describe '#next_process' do
    context 'when the process of last licitation process is 4' do
      before do
        subject.stub(:last_process_of_self_year).and_return(4)
      end

      it 'should be 5' do
        expect(subject.next_process).to eq 5
      end
    end
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

  describe 'publication' do
    let :licitation_process_publications do
      double :licitation_process_publications
    end

    it 'should can be updated when is a new record' do
      expect(subject).to be_updatable
    end

    it 'should can be updated when is not a new record, but has not publication' do
      subject.stub!(:new_record? => false)
      expect(subject).to be_updatable
    end

    it 'should can be updated when is not a new record, has publication but licitation process publication is updatable' do
      subject.stub!(:new_record? => false)
      subject.stub(:licitation_process_publications => licitation_process_publications)
      licitation_process_publications.should_receive(:empty?).and_return(false)
      licitation_process_publications.stub(:current_updatable? => true)
      expect(subject).to be_updatable
    end

    it 'should can not be updated when is not a new record, has publication and licitation process publication not updatable' do
      subject.stub!(:new_record?, false)
      licitation_process_publications.stub(:current_updatable? => false)
      licitation_process_publications.should_receive(:empty?).and_return(false)
      subject.stub(:licitation_process_publications => licitation_process_publications)
      expect(subject).not_to be_updatable
    end
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
    subject.stub(:administrative_process_judgment_form_kind).and_return('any')
    subject.stub(:type_of_calculation).and_return('lowest_total_price_by_item')

    LicitationProcessTypesOfCalculationByJudgmentFormKind.any_instance.stub(:correct_type_of_calculation?).and_return(false)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).to include 'não permitido para este tipo de julgamento (Menor preço total por item)'

    LicitationProcessTypesOfCalculationByJudgmentFormKind.any_instance.stub(:correct_type_of_calculation?).and_return(true)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).not_to include 'não permitido para este tipo de julgamento (Menor preço total por item)'
  end

  it "should validate type_of_calculation by object type" do
    subject.stub(:administrative_process_object_type).and_return('any')
    subject.stub(:type_of_calculation).and_return('lowest_total_price_by_item')

    LicitationProcessTypesOfCalculationByObjectType.any_instance.stub(:correct_type_of_calculation?).and_return(false)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).to include 'não permitido para este tipo de objeto (Menor preço total por item)'

    LicitationProcessTypesOfCalculationByObjectType.any_instance.stub(:correct_type_of_calculation?).and_return(true)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).not_to include 'não permitido para este tipo de objeto (Menor preço total por item)'
  end

  it 'should not allow lowest_total_price_by_item as type_of_calculation when modality is presence_trading' do
    subject.stub(:administrative_process_modality).and_return('presence_trading')
    subject.stub(:type_of_calculation).and_return('lowest_total_price_by_item')

    LicitationProcessTypesOfCalculationByModality.any_instance.should_receive(:correct_type_of_calculation?).
                                                  with('presence_trading', 'lowest_total_price_by_item').and_return(false)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).to include 'não permitido para esta modalidade (Menor preço total por item)'
  end

  it 'should allow lowest_total_price_by_item as type_of_calculation when modality is presence_trading' do
    subject.stub(:administrative_process_modality).and_return('presence_trading')
    subject.stub(:type_of_calculation).and_return('sort_participants_by_item')

    LicitationProcessTypesOfCalculationByModality.any_instance.should_receive(:correct_type_of_calculation?).
                                                  with('presence_trading', 'sort_participants_by_item').and_return(true)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).to_not include 'não permitido para esta modalidade'
  end

  it 'should allow lowest_global_price as type_of_calculation when modality is auction' do
    subject.stub(:administrative_process_modality).and_return('auction')
    subject.stub(:type_of_calculation).and_return('lowest_global_price')

    LicitationProcessTypesOfCalculationByModality.any_instance.should_receive(:correct_type_of_calculation?).
                                                  with('auction', 'lowest_global_price').and_return(true)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).to_not include 'não permitido para esta modalidade'
  end

  it 'should allow lowest_global_price as type_of_calculation when modality is auction' do
    subject.stub(:administrative_process_modality).and_return('auction')
    subject.stub(:type_of_calculation).and_return('lowest_price_by_lot')

    LicitationProcessTypesOfCalculationByModality.any_instance.should_receive(:correct_type_of_calculation?).
                                                  with('auction', 'lowest_price_by_lot').and_return(true)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).to_not include 'não permitido para esta modalidade'
  end

  it 'should not allow lowest_total_price_by_item as type_of_calculation when modality is auction' do
    subject.stub(:administrative_process_modality).and_return('auction')
    subject.stub(:type_of_calculation).and_return('lowest_total_price_by_item')

    LicitationProcessTypesOfCalculationByModality.any_instance.should_receive(:correct_type_of_calculation?).
                                                  with('auction', 'lowest_total_price_by_item').and_return(false)

    subject.valid?

    expect(subject.errors[:type_of_calculation]).to include 'não permitido para esta modalidade (Menor preço total por item)'
  end

  it "should have filled lots" do
    subject.stub(:items).and_return(true)
    subject.items.stub(:without_lot?).and_return(false)
    expect(subject).to be_filled_lots
  end

  it "should validate administrative_process_status" do
    subject.stub(:administrative_process_released?).and_return(false)

    subject.valid?

    expect(subject.errors[:administrative_process]).to include 'o status deve ser liberado'

    subject.stub(:administrative_process_released?).and_return(true)

    subject.valid?

    expect(subject.errors[:administrative_process]).to_not include 'o status deve ser liberado'
  end

  context "with adminsitrative process" do
    before do
      subject.stub(:administrative_process => administrative_process)
    end

    let :administrative_process do
      double('administrative_process',
             :administrative_process_budget_allocations => [],
             :released? => true
      )
    end

    let :licitation_process do
      double('licitation_process')
    end

    it "should not be valid if administrative process does not allow licitation process" do
      administrative_process.stub(:allow_licitation_process? => false)
      administrative_process.stub(:licitation_process => nil)

      subject.stub(:administrative_process => administrative_process)

      subject.valid?

      expect(subject.errors[:administrative_process]).to include 'não permite processo licitatório'
    end

    it 'should validate that selected administrative process is available' do
      expect(subject.errors.messages[:administrative_process]).to be_nil

      subject.stub(:administrative_process_licitation_process).and_return(true)

      administrative_process.stub(:licitation_process => licitation_process)
      administrative_process.stub(:allow_licitation_process? => true)

      subject.valid?

      expect(subject.errors.messages[:administrative_process]).to include 'já está em uso'
    end

    it "should not be valid if administrative_process have another licitation_process" do
      administrative_process.stub(:licitation_process => licitation_process)
      administrative_process.stub(:allow_licitation_process? => true)

      subject.valid?

      expect(subject.errors[:administrative_process]).to include "já tem um processo licitatório"
    end

    it "should be valid if administrative_process have the current licitation_process" do
      administrative_process.stub(:licitation_process => subject)
      administrative_process.stub(:allow_licitation_process? => true)

      subject.valid?

      expect(subject.errors[:administrative_process]).to_not include "já tem um processo licitatório"
    end

    it "should be valid if administrative_process do not have licitation_process" do
      administrative_process.stub(:licitation_process => nil)
      administrative_process.stub(:allow_licitation_process? => true)

      subject.valid?

      expect(subject.errors[:administrative_process]).to_not include "já tem um processo licitatório"
    end
  end

  context 'lots with items' do
    let :lot_with_items do
      [double("LicitationProcessLot", :administrative_process_budget_allocation_items => [double("LicitationProcessLotItem")],
              :licitation_process_bidder_proposals => [double]),
       double("LicitationProcessLot", :administrative_process_budget_allocation_items => [],
              :licitation_process_bidder_proposals => [double])]
    end

    it 'should filter lots with items' do
      subject.should_receive(:licitation_process_lots).and_return(lot_with_items)

      expect(subject.lots_with_items.size).to eq 1
    end
  end

  context 'has bidders and is available for classification' do
    it 'should return true' do
      subject.stub(:licitation_process_bidders => [double])
      subject.stub(:is_available_for_licitation_process_classification? => true)

      expect(subject.has_bidders_and_is_available_for_classification).to be true
    end

    it 'should return false' do
      subject.stub(:licitation_process_bidders => [])
      subject.stub(:is_available_for_licitation_process_classification? => true)

      expect(subject.has_bidders_and_is_available_for_classification).to be false
    end

    it 'should return false' do
      subject.stub(:licitation_process_bidders => [double])
      subject.stub(:is_available_for_licitation_process_classification? => false)

      expect(subject.has_bidders_and_is_available_for_classification).to be false
    end
  end
end
