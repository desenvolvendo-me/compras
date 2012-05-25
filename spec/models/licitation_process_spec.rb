# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process'
require 'app/models/administrative_process'
require 'app/models/capability'
require 'app/models/payment_method'
require 'app/models/licitation_process_publication'
require 'app/models/licitation_process_bidder'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process_appeal'
require 'app/models/budget_allocation'
require 'app/models/accreditation'
require 'app/models/pledge'
require 'app/models/judgment_commission_advice'
require 'app/models/provider'
require 'app/models/licitation_notice'
require 'app/models/licitation_process_lot'
require 'app/business/licitation_process_types_of_calculation_by_judgment_form_kind'
require 'app/business/licitation_process_types_of_calculation_by_object_type'
require 'app/business/licitation_process_types_of_calculation_by_modality'

describe LicitationProcess do
  it 'should return process/year as to_s' do
    subject.process = '1'
    subject.year = '2012'
    subject.to_s.should eq '1/2012'
  end

  it { should belong_to :administrative_process }
  it { should belong_to :capability }
  it { should belong_to :payment_method }
  it { should have_and_belong_to_many(:document_types) }
  it { should have_many(:licitation_notices).dependent(:destroy) }
  it { should have_many(:licitation_process_publications).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_bidders).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_impugnments).dependent(:restrict).order(:id) }
  it { should have_many(:licitation_process_appeals).dependent(:restrict) }
  it { should have_one(:accreditation).dependent(:destroy) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:judgment_commission_advices).dependent(:restrict) }
  it { should have_many(:providers).dependent(:restrict).through(:licitation_process_bidders) }
  it { should have_many(:licitation_process_lots).dependent(:destroy).order(:id) }

  it { should validate_presence_of :year }
  it { should validate_presence_of :process_date }
  it { should validate_presence_of :administrative_process }
  it { should validate_presence_of :object_description }
  it { should validate_presence_of :capability }
  it { should validate_presence_of :expiration }
  it { should validate_presence_of :expiration_unit }
  it { should validate_presence_of :readjustment_index }
  it { should validate_presence_of :period }
  it { should validate_presence_of :period_unit }
  it { should validate_presence_of :payment_method }
  it { should validate_presence_of :envelope_delivery_date }
  it { should validate_presence_of :envelope_delivery_time }
  it { should validate_presence_of :envelope_opening_date }
  it { should validate_presence_of :envelope_opening_time }
  it { should validate_presence_of :pledge_type }
  it { should validate_presence_of :type_of_calculation }

  context 'new_envelope_opening_date is not equal to new_envelope_delivery_date' do
    before do
      subject.stub(:new_envelope_opening_date_equal_new_envelope_delivery_date?).and_return(false)
    end

    it { should allow_value("11:11").for(:envelope_delivery_time) }
    it { should_not allow_value("44:11").for(:envelope_delivery_time) }
    it { should allow_value("11:11").for(:envelope_opening_time) }
    it { should_not allow_value("44:11").for(:envelope_opening_time) }
  end

  it "should not have envelope_delivery_date less than today" do
    subject.should_not allow_value(Date.yesterday).
      for(:envelope_delivery_date).with_message("deve ser em ou depois de #{I18n.l Date.current}")
  end

  it "should not have envelope_opening_date less than delivery date" do
    subject.envelope_delivery_date = Date.tomorrow

    subject.should_not allow_value(Date.current).
      for(:envelope_opening_date).with_message("deve ser em ou depois de #{I18n.l Date.tomorrow}")
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
        subject.next_process.should eq 5
      end
    end
  end

  describe '#next_licitation_number' do
    context 'when the licitation_number of last licitation process is 4' do
      before do
        subject.stub(:last_licitation_number_of_self_year_and_modality).and_return(4)
      end

      it 'should be 5' do
        subject.next_licitation_number.should eq 5
      end
    end
  end

  it 'should not have process_date less than administrative_process_date' do
    subject.stub(:administrative_process_date).and_return(Date.new(2012, 4, 25))

    subject.should_not allow_value(Date.new(2012, 4, 24)).for(:process_date).
                                                          with_message("deve ser em ou depois de 25/04/2012")
  end

   it 'should have process_date equal or greater than administrative_process_date' do
    subject.stub(:administrative_process_date).and_return(Date.new(2012, 4, 25))

    subject.should allow_value(Date.new(2012, 4, 25)).for(:process_date)
  end

  it 'should tell if it allow invitation bidders' do
    subject.stub(:envelope_opening_date).and_return(Date.tomorrow)

    subject.should_not be_allow_bidders

    subject.stub(:envelope_opening_date).and_return(Date.current)

    subject.should be_allow_bidders

    subject.stub(:envelope_opening_date).and_return(Date.yesterday)

    subject.should_not be_allow_bidders
   end

  it 'should return the advice number correctly' do
    subject.stub(:judgment_commission_advices).and_return([1, 2, 3])

    subject.advice_number.should eq 3
  end

  describe 'publication' do
    let :licitation_process_publications do
      double :licitation_process_publications
    end

    it 'should can be updated when is a new record' do
      subject.should be_updatable
    end

    it 'should can be updated when is not a new record, but has not publication' do
      subject.stub!(:new_record? => false)
      subject.should be_updatable
    end

    it 'should can be updated when is not a new record, has publication but licitation process publication is updatable' do
      subject.stub!(:new_record? => false)
      subject.stub(:licitation_process_publications => licitation_process_publications)
      licitation_process_publications.should_receive(:empty?).and_return(false)
      licitation_process_publications.stub(:current_updatable? => true)
      subject.should be_updatable
    end

    it 'should can not be updated when is not a new record, has publication and licitation process publication not updatable' do
      subject.stub!(:new_record?, false)
      licitation_process_publications.stub(:current_updatable? => false)
      licitation_process_publications.should_receive(:empty?).and_return(false)
      subject.stub(:licitation_process_publications => licitation_process_publications)
      subject.should_not be_updatable
    end
  end

  context "when envelope_opening_date is not the current date" do
    it "should return false for envelope_opening? method" do
      subject.envelope_opening_date = Date.tomorrow

      subject.should_not be_envelope_opening
    end
  end

  context "when envelope_opening_date is the current date" do
    it "should return true for envelope_opening? method" do
      subject.envelope_opening_date = Date.current

      subject.should be_envelope_opening
    end
  end

  it "should validate type_of_calculation by judgment_form_kind" do
    subject.stub(:administrative_process_judgment_form_kind).and_return('any')
    subject.stub(:type_of_calculation).and_return('lowest_total_price_by_item')

    LicitationProcessTypesOfCalculationByJudgmentFormKind.any_instance.stub(:correct_type_of_calculation?).and_return(false)

    subject.valid?

    subject.errors[:type_of_calculation].should include 'não permitido para este tipo de julgamento'

    LicitationProcessTypesOfCalculationByJudgmentFormKind.any_instance.stub(:correct_type_of_calculation?).and_return(true)

    subject.valid?

    subject.errors[:type_of_calculation].should_not include 'não permitido para este tipo de julgamento'
  end

  it "should validate type_of_calculation by object type" do
    subject.stub(:administrative_process_object_type).and_return('any')
    subject.stub(:type_of_calculation).and_return('lowest_total_price_by_item')

    LicitationProcessTypesOfCalculationByObjectType.any_instance.stub(:correct_type_of_calculation?).and_return(false)

    subject.valid?

    subject.errors[:type_of_calculation].should include 'não permitido para este tipo de objeto'

    LicitationProcessTypesOfCalculationByObjectType.any_instance.stub(:correct_type_of_calculation?).and_return(true)

    subject.valid?

    subject.errors[:type_of_calculation].should_not include 'não permitido para este tipo de objeto'
  end

  it "should validate type_of_calculation by modality" do
    subject.stub(:administrative_process_modality).and_return('any')
    subject.stub(:type_of_calculation).and_return('lowest_total_price_by_item')

    LicitationProcessTypesOfCalculationByModality.any_instance.stub(:correct_type_of_calculation?).and_return(false)

    subject.valid?

    subject.errors[:type_of_calculation].should include 'não permitido para esta modalidade'

    LicitationProcessTypesOfCalculationByModality.any_instance.stub(:correct_type_of_calculation?).and_return(true)

    subject.valid?

    subject.errors[:type_of_calculation].should_not include 'não permitido para esta modalidade'
  end

  it "should have filled lots" do
    subject.stub(:items).and_return(true)
    subject.items.stub(:without_lot?).and_return(false)
    subject.should be_filled_lots
  end

  it 'should return the winner proposal by global total value' do
    bidder_1 = double(:proposal_total_value => 1000.0, :provider => 'provider 1')
    bidder_2 = double(:proposal_total_value => 500.0, :provider => 'provider 2')
    subject.stub(:licitation_process_bidders).and_return([bidder_1, bidder_2])

    subject.winner_proposal_provider.should eq 'provider 2'
    subject.winner_proposal_total_price.should eq 500.0
  end

  it "should validate administrative_process_status" do
    subject.stub(:administrative_process_released?).and_return(false)

    subject.valid?

    subject.errors[:administrative_process].should include 'o status deve ser liberado'

    subject.stub(:administrative_process_released?).and_return(true)

    subject.valid?

    subject.errors[:administrative_process].should_not include 'o status deve ser liberado'
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

    it 'should validate that selected administrative process is available' do
      subject.errors.messages[:administrative_process].should be_nil

      subject.stub(:administrative_process_licitation_process).and_return(true)

      administrative_process.stub(:licitation_process => licitation_process)

      subject.valid?

      subject.errors.messages[:administrative_process].should include 'já está em uso'
    end

    it "should not be valid if administrative_process have another licitation_process" do
      administrative_process.stub(:licitation_process => licitation_process)

      subject.valid?

      subject.errors[:administrative_process].should include "já tem um processo licitatório"
    end

    it "should be valid if administrative_process have the current licitation_process" do
      administrative_process.stub(:licitation_process => subject)

      subject.valid?

      subject.errors[:administrative_process].should_not include "já tem um processo licitatório"
    end

    it "should be valid if administrative_process do not have licitation_process" do
      administrative_process.stub(:licitation_process => nil)

      subject.valid?

      subject.errors[:administrative_process].should_not include "já tem um processo licitatório"
    end
  end
end
