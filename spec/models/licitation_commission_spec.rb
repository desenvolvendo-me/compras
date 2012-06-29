# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_commission'
require 'app/models/licitation_commission_responsible'
require 'app/models/licitation_commission_member'
require 'app/models/unico/individual'
require 'app/models/individual'
require 'app/models/judgment_commission_advice'

describe LicitationCommission do
  it { should validate_presence_of :commission_type }
  it { should validate_presence_of :nomination_date }
  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :exoneration_date }
  it { should validate_presence_of :regulatory_act }

  it { should belong_to :regulatory_act }

  it { should have_many(:licitation_commission_responsibles).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_commission_members).dependent(:destroy).order(:id) }
  it { should have_many(:judgment_commission_advices).dependent(:restrict) }

  it 'should return id as to_s method' do
    subject.id = 2

    subject.to_s.should eq '2'
  end

  context 'validate dates based on nomination_date' do
    before do
      subject.stub(:nomination_date).and_return(Date.new(2012, 12, 20))
    end

    context 'expiration_date' do
      it 'should not allow expiration_date before nomination_date' do
        subject.should_not allow_value(Date.new(2012, 11, 1)).for(:expiration_date).
          with_message('deve ser em ou depois da data da nomeação (20/12/2012)')
      end

      it 'should allow expiration_date equals to nomination_date' do
        subject.should allow_value(Date.new(2012, 12, 20)).for(:expiration_date)
      end

      it 'should allow expiration_date after nomination_date' do
        subject.should allow_value(Date.new(2012, 12, 31)).for(:expiration_date)
      end
    end

    context 'exoneration_date' do
      it 'should not allow exoneration_date before nomination_date' do
        subject.should_not allow_value(Date.new(2012, 11, 1)).for(:exoneration_date).
          with_message('deve ser em ou depois da data da nomeação (20/12/2012)')
      end

      it 'should allow exoneration_date equals to nomination_date' do
        subject.should allow_value(Date.new(2012, 12, 20)).for(:exoneration_date)
      end

      it 'should allow exoneration_date after nomination_date' do
        subject.should allow_value(Date.new(2012, 12, 31)).for(:exoneration_date)
      end
    end
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
