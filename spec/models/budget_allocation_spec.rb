# encoding: utf-8
require 'model_helper'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/reserve_fund'
require 'app/models/pledge'
require 'app/models/direct_purchase_budget_allocation'
require 'app/models/extra_credit_moviment_type'
require 'app/models/administrative_process_budget_allocation'

describe BudgetAllocation do
  it 'should return "id/year - description" as to_s' do
    subject.id = '1'
    subject.year = 2012
    subject.description = 'Manutenção e Reparo'

    subject.to_s.should eq '1/2012 - Manutenção e Reparo'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :date }
  it { should validate_presence_of :kind }

  it { should belong_to(:budget_unit) }
  it { should belong_to(:subfunction) }
  it { should belong_to(:government_program) }
  it { should belong_to(:government_action) }
  it { should belong_to(:expense_nature) }
  it { should belong_to(:capability) }

  it { should have_many(:extra_credit_moviment_types).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_budget_allocations).dependent(:restrict) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:reserve_funds).dependent(:restrict) }
  it { should have_many(:direct_purchase_budget_allocations).dependent(:restrict) }
  it { should have_many(:administrative_process_budget_allocations).dependent(:restrict) }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }

  it 'should validate presence of amount if kind is average' do
    subject.stub(:divide?).and_return(true)
    subject.should validate_presence_of :amount
  end

  it 'should not validate presence of amount if kind is average' do
    subject.stub(:divide?).and_return(false)
    subject.should_not validate_presence_of :amount
  end

  it 'should calculate reserved value' do
    subject.reserved_value.should eq 0

    fund1 = double(:value => 3200)
    fund2 = double(:value => 2500)
    subject.stub(:reserve_funds).and_return([fund1, fund2])

    subject.reserved_value.should eq 5700
  end

  context '#real_amount' do
    it 'should calculate the right real value when the amount is not nil' do
      subject.stub(:amount => 400.0, :reserved_value => 200.0)
      subject.real_amount.should eq(200.0)
    end

    it 'should calculate the right real value when the amount is nil' do
      subject.stub(:amount => nil, :reserved_value => 200.0)
      subject.real_amount.should eq(-200.0)
    end
  end
end
