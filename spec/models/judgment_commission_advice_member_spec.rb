# encoding: utf-8
require 'model_helper'
require 'app/models/judgment_commission_advice_member'

describe JudgmentCommissionAdviceMember do
  it { should belong_to :judgment_commission_advice }
  it { should belong_to :individual }
  it { should belong_to :licitation_commission_member }

  it "should not validate attributes when is inherited" do
    subject.stub(:inherited?).and_return(true)

    expect(subject).not_to validate_presence_of :individual
    expect(subject).not_to validate_presence_of :role
    expect(subject).not_to validate_presence_of :role_nature
    expect(subject).not_to validate_presence_of :registration
  end

  it "should validate attributes when is not inherited" do
    subject.stub(:inherited?).and_return(false)

    expect(subject).to validate_presence_of :individual
    expect(subject).to validate_presence_of :role
    expect(subject).to validate_presence_of :role_nature
    expect(subject).to validate_presence_of :registration
  end

  it "should verify if is inherited" do
    subject.stub(:licitation_commission_member).and_return(nil)

    expect(subject.inherited?).to be_false

    subject.stub(:licitation_commission_member).and_return(double)

    expect(subject.inherited?).to be_true
  end

  it "should return the correct individual id depending on presence of licitation_commission_member" do
    subject.stub(:individual_id).and_return(3)
    subject.stub(:licitation_commission_member).and_return(nil)

    expect(subject.individual_identification).to eq 3

    subject.stub(:licitation_commission_member).and_return(double(:individual_id => 5))

    expect(subject.individual_identification).to eq 5
  end
end
