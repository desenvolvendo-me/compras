# encoding: utf-8
require 'model_helper'
require 'app/models/government_action'
require 'app/models/budget_allocation'

describe GovernmentAction do
  it "should return the description ad to_s method" do
    subject.description = "Ação Governamental"

    subject.to_s.should eq "Ação Governamental"
  end

  it { should belong_to :entity }
  it { should have_many(:budget_allocations).dependent(:restrict) }

  it { should validate_presence_of :year }
  it { should validate_presence_of :description }
  it { should validate_presence_of :status }
  it { should validate_presence_of :entity }
  it { should validate_numericality_of :year }
  it { should allow_value("2012").for(:year) }
  it { should_not allow_value("201").for(:year) }
  it { should_not allow_value("20122").for(:year) }
end
