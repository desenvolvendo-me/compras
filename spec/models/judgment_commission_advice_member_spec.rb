# encoding: utf-8
require 'model_helper'
require 'app/models/judgment_commission_advice_member'

describe JudgmentCommissionAdviceMember do
  it { should belong_to :judgment_commission_advice }
  it { should belong_to :individual }
  it { should belong_to :licitation_commission_member }

  it "should not validate attributes when is inherited" do
    subject.stub(:inherited?).and_return(true)

    subject.should_not validate_presence_of :individual
    subject.should_not validate_presence_of :role
    subject.should_not validate_presence_of :role_nature
    subject.should_not validate_presence_of :registration
  end

  it "should validate attributes when is not inherited" do
    subject.stub(:inherited?).and_return(false)

    subject.should validate_presence_of :individual
    subject.should validate_presence_of :role
    subject.should validate_presence_of :role_nature
    subject.should validate_presence_of :registration
  end

  it "should verify if is inherited" do
    subject.stub(:licitation_commission_member).and_return(nil)

    subject.inherited?.should be_false

    subject.stub(:licitation_commission_member).and_return(double)

    subject.inherited?.should be_true
  end

  it "should return the correct individual id depending on presence of licitation_commission_member" do
    subject.stub(:individual_id).and_return(3)
    subject.stub(:licitation_commission_member).and_return(nil)

    subject.individual_identification.should eq 3

    subject.stub(:licitation_commission_member).and_return(double(:individual_id => 5))

    subject.individual_identification.should eq 5
  end
end
