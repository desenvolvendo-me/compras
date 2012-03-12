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

  it 'should return licitation_number/year as licitation method' do
    subject.licitation.should eq nil

    subject.licitation_number = '001'
    subject.licitation_year = '2012'

    subject.joined_licitation.should eq '001/2012'
  end

  it 'should return process_number/year as process method' do
    subject.process.should eq nil

    subject.process_number = '002'
    subject.process_year = '2013'

    subject.joined_process.should eq '002/2013'
  end

  context 'validating date' do
    before(:each) do
      described_class.stub(:last).and_return(double(:date => Date.new(2011, 12, 31)))
      described_class.stub(:any?).and_return(true)
    end

    it 'should be valid when date is equal to last' do
      subject.should allow_value('2011-12-31').for(:date)
    end

    it 'should not be valid when date is greather than last' do
      subject.should_not allow_value('2011-12-21').for(:date).with_message("deve ser maior ou igual a data da última reserva (31/12/2011)")
    end
  end
end
