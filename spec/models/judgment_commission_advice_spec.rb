# encoding: utf-8
require 'model_helper'
require 'app/models/judgment_commission_advice'
require 'app/models/judgment_commission_advice_member'
require 'app/models/individual'

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

  context "inherited and not inherited members" do
    let(:member1) do
      double('member 1', :to_hash => {:member => 1})
    end

    let(:member2) do
      double('member 2', :to_hash => {:member => 2})
    end

    let(:member3) do
      double('member 3', :to_hash => {:member => 3})
    end

    it "it should return the inherited members" do
      subject.stub(:licitation_commission_members).and_return([member1, member3])
      subject.stub(:judgment_commission_advice_members).and_return([member1, member2, member3])

      subject.inherited_members.should eq [member1, member3]
    end

    it "it should return the not inherited members" do
      subject.stub(:licitation_commission_members).and_return([member1, member2])
      subject.stub(:judgment_commission_advice_members).and_return([member1, member2, member3])

      subject.not_inherited_members.should eq [member3]
    end
  end
end
