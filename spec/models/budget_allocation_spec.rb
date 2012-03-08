# encoding: utf-8
require 'model_helper'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/reserve_fund'
require 'app/models/pledge'
require 'app/models/bid_opening'

describe BudgetAllocation do
  it 'should return description as to_s id/year' do
    subject.id = '1'
    subject.year = 2012

    subject.to_s.should eq '1/2012'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :date }

  it { should belong_to(:organogram) }
  it { should belong_to(:subfunction) }
  it { should belong_to(:government_program) }
  it { should belong_to(:government_action) }
  it { should belong_to(:expense_economic_classification) }
  it { should belong_to(:capability) }
  it { should have_many(:purchase_solicitations).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_budget_allocations).dependent(:restrict) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:reserve_funds).dependent(:restrict) }
  it { should have_many(:bid_openings).dependent(:restrict) }
  it { should have_many(:direct_purchase_budget_allocations).dependent(:restrict) }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }

  context 'validating date' do
    before(:each) do
      described_class.stub(:last).and_return(double(:date => Date.new(2011, 12, 31)))
      described_class.stub(:any?).and_return(true)
    end

    it 'should be valid when budget allocation is equal to last' do
      subject.should allow_value('2011-12-31').for(:date)
    end

    it 'should not be valid when budget allocation is greather than last' do
      subject.should_not allow_value('2011-12-21').for(:date).with_message("deve ser maior ou igual a data da última dotação (31/12/2011)")
    end
  end
end
