# encoding: utf-8
require 'model_helper'
require 'app/models/government_action'

describe GovernmentAction do
  it "should return the description ad to_s method" do
    subject.description = "Ação Governamental"

    subject.to_s.should eq "Ação Governamental"
  end

  it { should validate_presence_of :year }
  it { should validate_presence_of :description }
  it { should validate_presence_of :status }
  it { should validate_presence_of :entity_id }
end
