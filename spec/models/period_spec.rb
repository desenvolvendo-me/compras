# encoding: utf-8
require 'model_helper'
require 'app/models/period'

describe Period do
  it 'should return amount and pluralized as to_s' do
    subject.unit = PeriodUnit::YEAR

    subject.amount = '1'
    subject.to_s.should eq '1 Ano'

    subject.amount = '2'
    subject.to_s.should eq '2 Anos'

    subject.unit = PeriodUnit::MONTH

    subject.amount = '1'
    subject.to_s.should eq '1 Mês'

    subject.amount = '2'
    subject.to_s.should eq '2 Meses'

    subject.unit = PeriodUnit::DAY

    subject.amount = '1'
    subject.to_s.should eq '1 Dia'

    subject.amount = '2'
    subject.to_s.should eq '2 Dias'
  end

  it { should validate_presence_of :unit }
  it { should validate_presence_of :amount }

  it { should have_many(:direct_purchases).dependent(:restrict) }
end
