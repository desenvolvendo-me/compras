# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process'
require 'app/models/administrative_process'
require 'app/models/capability'
require 'app/models/period'
require 'app/models/payment_method'
require 'app/models/licitation_process_publication'
require 'app/models/licitation_process_invited_bidder'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process_appeal'
require 'app/models/budget_allocation'
require 'app/models/accreditation'
require 'app/models/pledge'
require 'app/models/judgment_commission_advice'
require 'app/models/provider'
require 'app/models/licitation_notice'

describe LicitationProcess do
  it 'should return process/year as to_s' do
    subject.process = '1'
    subject.year = '2012'
    subject.to_s.should eq '1/2012'
  end

  it { should belong_to :administrative_process }
  it { should belong_to :capability }
  it { should belong_to :period }
  it { should belong_to :payment_method }
  it { should have_and_belong_to_many(:document_types) }
  it { should have_many(:licitation_notices).dependent(:destroy) }
  it { should have_many(:licitation_process_publications).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_invited_bidders).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_invited_bidder_documents).through(:licitation_process_invited_bidders) }
  it { should have_many(:licitation_process_impugnments).dependent(:restrict).order(:id) }
  it { should have_many(:licitation_process_appeals).dependent(:restrict) }
  it { should have_one(:accreditation).dependent(:destroy) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:judgment_commission_advices).dependent(:restrict) }
  it { should have_many(:providers).dependent(:restrict).through(:licitation_process_invited_bidders) }

  it { should validate_presence_of :year }
  it { should validate_presence_of :process_date }
  it { should validate_presence_of :administrative_process }
  it { should validate_presence_of :object_description }
  it { should validate_presence_of :capability }
  it { should validate_presence_of :expiration }
  it { should validate_presence_of :readjustment_index }
  it { should validate_presence_of :period }
  it { should validate_presence_of :payment_method }
  it { should validate_presence_of :envelope_delivery_date }
  it { should validate_presence_of :envelope_delivery_time }
  it { should validate_presence_of :envelope_opening_date }
  it { should validate_presence_of :envelope_opening_time }
  it { should validate_presence_of :pledge_type }

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

  it "the duplicated invited bidders should be invalid except the first" do
    bidder_one = subject.licitation_process_invited_bidders.build(:provider_id => 1)
    bidder_two = subject.licitation_process_invited_bidders.build(:provider_id => 1)

    subject.valid?

    bidder_one.errors.messages[:provider_id].should be_nil
    bidder_two.errors.messages[:provider_id].should include "já está em uso"
  end

  it "the diferent invited bidders should be valid" do
    bidder_one = subject.licitation_process_invited_bidders.build(:provider_id => 1)
    bidder_two = subject.licitation_process_invited_bidders.build(:provider_id => 2)

    subject.valid?

    bidder_one.errors.messages[:provider_id].should be_nil
    bidder_two.errors.messages[:provider_id].should be_nil
  end

  it 'should validate that selected administrative process is available' do
    subject.errors.messages[:administrative_process].should be_nil

    administrative_process = double('administrative process',
                                    :administrative_process_budget_allocations => [],
                                    :licitation_process => 1)

    subject.stub(:administrative_process).and_return(administrative_process)
    subject.stub(:administrative_process_licitation_process).and_return(true)

    subject.valid?

    subject.errors.messages[:administrative_process].should include 'já está em uso'
  end

  describe '#next_process' do
    context 'when do not has a licitation process with the same year' do
      before do
        subject.stub(:last_by_self_year).and_return(nil)
      end

      it 'should be 1' do
        subject.next_process.should eq 1
      end
    end

    context 'when the process of last licitation process is 4' do
      before do
        subject.stub(:last_by_self_year).and_return(last_by_self_year)
      end

      let :last_by_self_year do
        double(:last_by_self_year, :process => 4)
      end

      it 'should be 5' do
        subject.next_process.should eq 5
      end
    end
  end

  describe '#next_licitation_number' do
    context 'when do not has a licitation process with the same year and modality' do
      before do
        subject.stub(:last_by_self_year_and_modality).and_return(nil)
      end

      it 'should be 1' do
        subject.next_licitation_number.should eq 1
      end
    end

    context 'when the licitation_number of last licitation process is 4' do
      before do
        subject.stub(:last_by_self_year_and_modality).and_return(last_by_self_year_and_modality)
      end

      let :last_by_self_year_and_modality do
        double(:last_by_self_year_and_modality, :licitation_number => 4)
      end

      it 'should be 5' do
        subject.next_licitation_number.should eq 5
      end
    end
  end

  it 'should return the correct number for next judgment commission advice' do
    subject.stub(:judgment_commission_advices).and_return(Array.new(5))

    subject.next_judgment_commission_advice.should eq 6
  end

  it 'should not have process_date less than administrative_process_date' do
    subject.stub(:administrative_process_date).and_return(Date.current)
    subject.stub(:process_date).and_return(Date.yesterday)

    subject.valid?
    subject.errors.messages[:process_date].should include 'deve ser em ou depois de 25/04/2012'
  end

   it 'should have process_date equal or greater than administrative_process_date' do
    subject.stub(:administrative_process_date).and_return(Date.current)
    subject.stub(:process_date).and_return(Date.current)

    subject.valid?
    subject.errors.messages[:process_date].should be_nil
  end
end
