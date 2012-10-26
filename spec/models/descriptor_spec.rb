require 'model_helper'
require 'app/parsers/month_and_year_parser'
require 'app/models/budget_allocation'
require 'app/models/capability'
require 'app/models/expense_nature'
require 'app/models/extra_credit'
require 'app/models/government_action'
require 'app/models/government_program'
require 'app/models/management_unit'
require 'app/models/pledge'
require 'app/models/reserve_fund'
require 'app/models/budget_revenue'
require 'app/models/revenue_nature'
require 'app/models/subfunction'
require 'app/models/descriptor'
require 'app/models/event_checking_configuration'

describe Descriptor do
  it 'should return year and entity as to_s' do
    subject.period = Date.new(2012, 10, 1)
    subject.stub(:entity).and_return(double(:to_s => 'Detran'))
    expect(subject.to_s).to eq '2012 - Detran'
  end

  it { should belong_to :entity }

  it { should have_many(:budget_allocations).dependent(:restrict) }
  it { should have_many(:capabilities).dependent(:restrict) }
  it { should have_many(:expense_natures).dependent(:restrict) }
  it { should have_many(:extra_credits).dependent(:restrict) }
  it { should have_many(:government_actions).dependent(:restrict) }
  it { should have_many(:government_programs).dependent(:restrict) }
  it { should have_many(:management_units).dependent(:restrict) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:reserve_funds).dependent(:restrict) }
  it { should have_many(:budget_revenue).dependent(:restrict) }
  it { should have_many(:revenue_natures).dependent(:restrict) }
  it { should have_many(:subfunctions).dependent(:restrict) }
  it { should have_many(:event_checking_configurations).dependent(:restrict) }

  it { should validate_presence_of :entity }
  it { should validate_presence_of :period }

  it { subject.localized.should allow_value('12/2012').for(:period) }
  it { should_not allow_value('13/2012').for(:period) }

  describe '#year' do
    it 'should be 2012' do
      subject.stub(:period).and_return(Date.new(2012, 01, 02))

      expect(subject.year).to eq 2012
    end

    it 'should be nil' do
      subject.stub(:period).and_return(nil)

      expect(subject.year).to eq nil
    end
  end

  describe '#month' do
    it 'should be 1' do
      subject.stub(:period).and_return(Date.new(2012, 01, 02))

      expect(subject.month).to eq 1
    end

    it 'should be nil' do
      subject.stub(:period).and_return(nil)

      expect(subject.month).to eq nil
    end
  end
end
