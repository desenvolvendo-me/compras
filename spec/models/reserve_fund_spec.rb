# encoding: utf-8
require 'model_helper'
require 'app/models/reserve_fund'
require 'app/models/pledge'

describe ReserveFund do
  it 'should return to_s as id/year' do
    subject.id = 1
    subject.year = 2012
    subject.to_s.should eql '1/2012'
  end

  it 'should return false for is_type_licitation when type is not Licitação' do
    subject.stub(:reserve_allocation_type).and_return(double(:description => "Comum"))

    subject.is_type_licitation?.should be_false
  end

  it 'should return true for is_type_licitation when type is Licitação' do
    subject.stub(:reserve_allocation_type).and_return(double(:description => "Licitação"))

    subject.is_type_licitation?.should be_true
  end

  it { should belong_to :entity }
  it { should belong_to :budget_allocation }
  it { should belong_to :reserve_allocation_type }
  it { should belong_to :licitation_modality }
  it { should belong_to :creditor }
  it { should have_many(:pledges).dependent(:restrict) }

  it { should validate_presence_of :entity }
  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :value }
  it { should validate_presence_of :year }
  it { should validate_presence_of :reserve_allocation_type }
  it { should validate_presence_of :date }

  it { should allow_value('2009').for(:year) }
  it { should_not allow_value('209').for(:year) }
end
