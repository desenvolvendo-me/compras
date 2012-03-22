# encoding: utf-8
require 'model_helper'
require 'app/models/additional_credit_opening'

describe AdditionalCreditOpening do
  it 'should return year as to_s' do
    subject.year = 2012
    subject.to_s.should eq '2012'
  end

  it { should allow_value(2012).for(:year) }
  it { should_not allow_value(212).for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  it { should validate_presence_of :entity }
  it { should validate_presence_of :year }
  it { should validate_presence_of :credit_type }
  it { should validate_presence_of :administractive_act }
  it { should validate_presence_of :credit_date }

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
