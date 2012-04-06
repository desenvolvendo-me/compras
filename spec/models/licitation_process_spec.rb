# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process'
require 'app/models/administrative_process'
require 'app/models/capability'
require 'app/models/period'
require 'app/models/payment_method'
require 'app/models/licitation_process_budget_allocation'
require 'app/models/licitation_process_budget_allocation_item'
require 'app/models/licitation_process_publication'
require 'app/models/licitation_process_invited_bidder'
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
  it { should have_many(:licitation_process_budget_allocations).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_publications).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_invited_bidders).dependent(:destroy).order(:id) }

  it { should validate_presence_of  :year }
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

  it "the duplicated budget_allocations should be invalid except the first" do
    allocation_one = subject.licitation_process_budget_allocations.build(:budget_allocation_id => 1)
    allocation_two = subject.licitation_process_budget_allocations.build(:budget_allocation_id => 1)

    subject.valid?

    allocation_one.errors.messages[:budget_allocation_id].should be_nil
    allocation_two.errors.messages[:budget_allocation_id].should include "já está em uso"
  end

  it "the diferent budget_allocations should be valid" do
    allocation_one = subject.licitation_process_budget_allocations.build(:budget_allocation_id => 1)
    allocation_two = subject.licitation_process_budget_allocations.build(:budget_allocation_id => 2)

    subject.valid?

    allocation_one.errors.messages[:budget_allocation_id].should be_nil
    allocation_two.errors.messages[:budget_allocation_id].should be_nil
  end

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
end
