# encoding: utf-8
require 'model_helper'
require 'app/models/judgment_commission_advice'

describe JudgmentCommissionAdvice do
  it { should belong_to :licitation_process }
  it { should belong_to :licitation_commission }

  it { should have_many(:judgment_commission_advice_members).dependent(:destroy).order(:id) }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :licitation_commission }
  it { should validate_presence_of :year }
  it { should validate_presence_of :minutes_number }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it 'should return id/year as to_s method' do
    subject.id = 1
    subject.year = 2012

    subject.to_s.should eq '1/2012'
  end

  it "the duplicated individuals on members should be invalid except the first" do
    individual_one = subject.judgment_commission_advice_members.build(:individual_id => 1)
    individual_two = subject.judgment_commission_advice_members.build(:individual_id => 1)

    subject.valid?

    individual_one.errors.messages[:individual_id].should be_nil
    individual_two.errors.messages[:individual_id].should include "já está em uso"
  end

  it "the diferent individuals on members should be valid" do
    individual_one = subject.judgment_commission_advice_members.build(:individual_id => 1)
    individual_two = subject.judgment_commission_advice_members.build(:individual_id => 2)

    subject.valid?

    individual_one.errors.messages[:individual_id].should be_nil
    individual_two.errors.messages[:individual_id].should be_nil
  end
end
