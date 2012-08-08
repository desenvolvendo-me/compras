# encoding: utf-8
require 'model_helper'
require 'app/models/government_action'
require 'app/models/budget_allocation'

describe GovernmentAction do
  it "should return the description ad to_s method" do
    subject.description = "Ação Governamental"

    expect(subject.to_s).to eq "Ação Governamental"
  end

  it { should belong_to :descriptor }

  it { should have_many(:budget_allocations).dependent(:restrict) }

  it { should validate_presence_of :descriptor }
  it { should validate_presence_of :description }
  it { should validate_presence_of :status }
end
