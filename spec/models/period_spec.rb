# encoding: utf-8
require 'model_helper'
require 'app/models/period'
require 'app/models/direct_purchase'
require 'app/models/licitation_process'

describe Period do
  it 'should return amount and pluralized as to_s' do
    subject.unit = PeriodUnit::YEAR

    subject.amount = '1'
    subject.to_s.should eq '1 ano'

    subject.amount = '2'
    subject.to_s.should eq '2 anos'

    subject.unit = PeriodUnit::MONTH

    subject.amount = '1'
    subject.to_s.should eq '1 mês'

    subject.amount = '2'
    subject.to_s.should eq '2 meses'

    subject.unit = PeriodUnit::DAY

    subject.amount = '1'
    subject.to_s.should eq '1 dia'

    subject.amount = '2'
    subject.to_s.should eq '2 dias'
  end

  it { should validate_presence_of :unit }
  it { should validate_presence_of :amount }

  it { should have_many(:direct_purchases).dependent(:restrict) }
  it { should have_many(:licitation_processes).dependent(:restrict) }
  it { should have_many(:price_collections).dependent(:restrict) }
end
