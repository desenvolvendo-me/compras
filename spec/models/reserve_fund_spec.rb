# encoding: utf-8
require 'model_helper'
require 'app/models/reserve_fund'

describe ReserveFund do
  it 'should return to_s as id/year' do
    subject.id = 1
    subject.year = 2012
    subject.to_s.should eql '1/2012'
  end

  it { should belong_to :entity }
  it { should belong_to :budget_allocation }

  it { should validate_presence_of :entity }
  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :value }
  it { should validate_presence_of :year }

  it { should allow_value('2009').for(:year) }
  it { should_not allow_value('209').for(:year) }
end
