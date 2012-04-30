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
  it { should validate_presence_of :judgment_start_date }
  it { should validate_presence_of :judgment_start_time }
  it { should validate_presence_of :judgment_end_date }
  it { should validate_presence_of :judgment_end_time }
  it { should validate_presence_of :companies_minutes }
  it { should validate_presence_of :companies_documentation_minutes }
  it { should validate_presence_of :justification_minutes }
  it { should validate_presence_of :judgment_minutes }

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

    it "should not have judgment end date/time before judgment start date/time" do
      subject.judgment_start_date = Date.new(2012, 3, 10)
      subject.judgment_start_time = "10:00"

      # same time should be valid
      subject.judgment_end_date = Date.new(2012, 3, 10)
      subject.judgment_end_time = "10:00"

      subject.valid?

      subject.errors.messages[:judgment_start_date].should be_nil

      # end after start should be valid
      subject.judgment_end_date = Date.new(2012, 3, 11)
      subject.judgment_end_time = "9:00"

      subject.valid?

      subject.errors.messages[:judgment_start_date].should be_nil

      # end before start should be invalid
      subject.judgment_end_date = Date.new(2012, 3, 10)
      subject.judgment_end_time = "9:59"

      subject.valid?

      subject.errors.messages[:judgment_end_date].should include "data do fim do julgamento não pode ser anterior a data do início do julgamento"
    end
  end
end
