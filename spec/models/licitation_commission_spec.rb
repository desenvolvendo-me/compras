# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_commission'
require 'app/models/licitation_commission_responsible'
require 'app/models/licitation_commission_member'
require 'app/models/individual'
require 'app/models/accreditation'

describe LicitationCommission do
  it { should validate_presence_of :commission_type }
  it { should validate_presence_of :nomination_date }
  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :exoneration_date }
  it { should validate_presence_of :regulatory_act }

  it { should belong_to :regulatory_act }

  it { should have_many(:licitation_commission_responsibles).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_commission_members).dependent(:destroy).order(:id) }
  it { should have_many(:accreditations).dependent(:restrict) }
  it { should have_many(:judgment_commission_advices).dependent(:restrict) }

  it 'should return id as to_s method' do
    subject.id = 2

    subject.to_s.should eq '2'
  end
  
  it "should not have expiration_date less than nomination_date" do
    subject.nomination_date = Date.current

    subject.should_not allow_value(Date.yesterday).for(:expiration_date).
                                                   with_message("deve ser em ou depois de #{I18n.l(Date.current)}")
  end

  it "should not have exoneration_date less than nomination_date" do
    subject.nomination_date = Date.current

    subject.should_not allow_value(Date.yesterday).for(:exoneration_date).
                                                   with_message("deve ser em ou depois de #{I18n.l(Date.current)}")
  end

  it "should delegate publication_date to regulatory_act with prefix" do
    subject.stub(:regulatory_act).and_return stub(:publication_date => Date.new(2012, 2, 28))
    subject.regulatory_act_publication_date.should eq Date.new(2012, 2, 28)
  end

  it "the duplicated individuals on responsibles should be invalid except the first" do
    individual_one = subject.licitation_commission_responsibles.build(:individual_id => 1)
    individual_two = subject.licitation_commission_responsibles.build(:individual_id => 1)

    subject.valid?

    individual_one.errors.messages[:individual_id].should be_nil
    individual_two.errors.messages[:individual_id].should include "já está em uso"
  end

  it "the diferent individuals on responsibles should be valid" do
    individual_one = subject.licitation_commission_responsibles.build(:individual_id => 1)
    individual_two = subject.licitation_commission_responsibles.build(:individual_id => 2)

    subject.valid?

    individual_one.errors.messages[:individual_id].should be_nil
    individual_two.errors.messages[:individual_id].should be_nil
  end

  it "the duplicated individuals on members should be invalid except the first" do
    individual_one = subject.licitation_commission_members.build(:individual_id => 1)
    individual_two = subject.licitation_commission_members.build(:individual_id => 1)

    subject.valid?

    individual_one.errors.messages[:individual_id].should be_nil
    individual_two.errors.messages[:individual_id].should include "já está em uso"
  end

  it "the diferent individuals on members should be valid" do
    individual_one = subject.licitation_commission_members.build(:individual_id => 1)
    individual_two = subject.licitation_commission_members.build(:individual_id => 2)

    subject.valid?

    individual_one.errors.messages[:individual_id].should be_nil
    individual_two.errors.messages[:individual_id].should be_nil
  end

  context 'must have one president' do
    let(:member_1) do
      double('member 1', :individual_id => 1, :president? => false)
    end

    let(:president_1) do
      double('president 1', :individual_id => 3, :president? => true)
    end

    let(:president_2) do
      double('president 2', :individual_id => 4, :president? => true)
    end

    it "must be invalid when there is no president" do
      subject.stub(:licitation_commission_members).and_return([member_1])

      subject.valid?

      subject.errors.messages[:licitation_commission_members].should include 'deve haver um presidente'
    end

    it "must be invalid when there are two presidents" do
      subject.stub(:licitation_commission_members).and_return([president_1, president_2])

      subject.valid?

      subject.errors.messages[:licitation_commission_members].should include 'deve haver apenas um presidente'
    end

    it "must be valid when there are one president" do
      subject.stub(:licitation_commission_members).and_return([president_1, member_1])

      subject.valid?

      subject.errors.messages[:licitation_commission_members].should be_nil
    end
  end
end
