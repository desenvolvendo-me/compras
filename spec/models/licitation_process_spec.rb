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
  it { should have_many(:licitation_process_publications).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_invited_bidders).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_invited_bidder_documents).through(:licitation_process_invited_bidders) }
  it { should have_many(:licitation_process_impugnments).dependent(:restrict).order(:id) }
  it { should have_many(:licitation_process_appeals).dependent(:restrict) }

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

  it "should allow update envelope delivery and opening datetimes" do
    now = Time.now
    subject.envelope_delivery_date = Date.today
    subject.envelope_delivery_time = now
    subject.envelope_opening_date = Date.today
    subject.envelope_opening_time = now

    subject.set_dates(
      :envelope_delivery_date => Date.tomorrow,
      :envelope_delivery_time => now + 1.day,
      :envelope_opening_date => Date.tomorrow,
      :envelope_opening_time => now + 1.day
    )

    subject.envelope_delivery_date.should eq Date.tomorrow
    subject.envelope_delivery_time.should eq now + 1.day
    subject.envelope_opening_date.should eq Date.tomorrow
    subject.envelope_opening_time.should eq now + 1.day
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
end
