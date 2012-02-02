# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation'

describe PurchaseSolicitation do
  it 'should return the id in to_s method' do
    subject.justification = 'Precisamos de mais cadeiras'

    subject.to_s.should eq 'Precisamos de mais cadeiras'
  end

  it {should belong_to :responsible }
  it {should belong_to :budget_allocation }
  it {should belong_to :delivery_location }
  it {should belong_to :liberator }
  it {should belong_to :organogram }
  it {should have_and_belong_to_many :budget_allocations }

  it { should validate_presence_of :accounting_year }
  it { should validate_presence_of :request_date }
  it { should validate_presence_of :delivery_location_id }
  it { should validate_presence_of :responsible_id }
  it { should validate_presence_of :kind }
end
