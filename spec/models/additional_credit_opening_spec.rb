# encoding: utf-8
require 'model_helper'
require 'app/models/additional_credit_opening'
require 'app/models/additional_credit_opening_moviment_type'

describe AdditionalCreditOpening do
  it 'should return year as to_s' do
    subject.year = 2012
    subject.to_s.should eq '2012'
  end

  it { should belong_to :entity }

  it { should have_many(:additional_credit_opening_moviment_types).dependent(:destroy) }

  it { should allow_value(2012).for(:year) }
  it { should_not allow_value(212).for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should validate_presence_of :entity }
  it { should validate_presence_of :year }
  it { should validate_presence_of :credit_type }
  it { should validate_presence_of :regulatory_act }
  it { should validate_presence_of :credit_date }
  it { should validate_presence_of :additional_credit_opening_nature }

  it 'should not be valid when difference is not zero' do
    subject.stub(:supplement).and_return(10.0)
    subject.stub(:reduced).and_return(1.0)
    subject.should_not be_valid
    subject.errors[:difference].should include 'não é válido'
  end

  it 'should be valid when difference is zero' do
    subject.stub(:supplement).and_return(10.0)
    subject.stub(:reduced).and_return(10.0)
    subject.should_not be_valid
    subject.errors[:difference].should be_empty
  end

  context 'validating uniquess at additional_credit_opening_moviment_type' do
    context 'with budget_allocation' do
      let :budget_allocation_one do
        AdditionalCreditOpeningMovimentType.new(:budget_allocation_id => 1)
      end

      let :budget_allocation_two do
        AdditionalCreditOpeningMovimentType.new(:budget_allocation_id => 1)
      end

      it 'should not be valid' do
        subject.additional_credit_opening_moviment_types = [budget_allocation_one, budget_allocation_two]
        subject.should_not be_valid
        subject.errors.messages[:additional_credit_opening_moviment_types].should include('já está em uso')
      end
    end

    context 'with capability' do
      let :capability_one do
        AdditionalCreditOpeningMovimentType.new(:capability_id => 1)
      end

      let :capability_two do
        AdditionalCreditOpeningMovimentType.new(:capability_id => 1)
      end

      it 'should not be valid' do
        subject.additional_credit_opening_moviment_types = [capability_one, capability_two]
        subject.should_not be_valid
        subject.errors.messages[:base].should include('já está em uso')
      end
    end
  end

  context 'validating credit date' do
    context 'with last' do
      before(:each) do
        described_class.stub(:last).and_return(double(:credit_date => Date.new(2012, 3, 1)))
        described_class.stub(:any?).and_return(true)
      end

      it 'should be valid when credit date is equal' do
        subject.should allow_value('2012-03-1').for(:credit_date)
      end

      it 'should not be valid when credit date is older' do
        subject.should_not allow_value('2011-01-01').for(:credit_date).with_message("deve ser maior ou igual a data da última abertura de crédito suplementar (01/03/2012)")
      end
    end

    context 'with publication date' do
      before(:each) do
        subject.stub(:publication_date).and_return(Date.new(2012, 3, 1))
      end

      it 'should be valid when credit date is equal' do
        subject.should allow_value('2012-03-01').for(:credit_date)
      end

      it 'should not be valid when credit date is older' do
        subject.should_not allow_value('2011-01-01').for(:credit_date).with_message("deve ser maior ou igual a data de publicação do ato administrativo (01/03/2012)")
      end
    end
  end
end
