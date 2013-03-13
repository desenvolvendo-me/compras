# encoding: utf-8
require 'model_helper'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/purchase_solicitation_budget_allocation_item'
require 'app/models/purchase_solicitation'
require 'app/models/reserve_fund'
require 'app/models/pledge'
require 'app/models/direct_purchase_budget_allocation'
require 'app/models/administrative_process_budget_allocation'

describe BudgetAllocation do
  describe 'default values' do
    it 'uses false as default for refinancing' do
      expect(subject.refinancing).to be false
    end

    it 'uses false as default for health' do
      expect(subject.health).to be false
    end

    it 'uses false as default for alienation_appeal' do
      expect(subject.alienation_appeal).to be false
    end

    it 'uses false as default for education' do
      expect(subject.education).to be false
    end

    it 'uses false as default for foresight' do
      expect(subject.foresight).to be false
    end

    it 'uses false as default for personal' do
      expect(subject.personal).to be false
    end
  end

  it { should validate_presence_of :budget_structure }
  it { should validate_presence_of :capability }
  it { should validate_presence_of :date }
  it { should validate_presence_of :descriptor }
  it { should validate_presence_of :expense_nature }
  it { should validate_presence_of :government_action }
  it { should validate_presence_of :government_program }
  it { should validate_presence_of :subfunction }
  it { should validate_presence_of :function }

  it { should belong_to(:descriptor) }
  it { should belong_to(:budget_structure) }
  it { should belong_to(:subfunction) }
  it { should belong_to(:government_program) }
  it { should belong_to(:government_action) }
  it { should belong_to(:expense_nature) }
  it { should belong_to(:capability) }

  it { should have_many(:purchase_solicitation_budget_allocations).dependent(:restrict) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:reserve_funds).dependent(:restrict) }
  it { should have_many(:direct_purchase_budget_allocations).dependent(:restrict) }
  it { should have_many(:administrative_process_budget_allocations).dependent(:restrict) }

  it { should auto_increment(:code).by([:descriptor_id]).on(:before_create) }

  it 'should validate presence of amount if kind is average' do
    subject.stub(:divide?).and_return(true)
    expect(subject).to validate_presence_of :amount
  end

  it 'should not validate presence of amount if kind is average' do
    subject.stub(:divide?).and_return(false)
    expect(subject).not_to validate_presence_of :amount
  end

  it 'should calculate reserved value' do
    expect(subject.reserved_value).to eq 0

    fund1 = double(:value => 3200)
    fund2 = double(:value => 2500)
    subject.stub(:reserve_funds).and_return([fund1, fund2])

    expect(subject.reserved_value).to eq 5700
  end

  context '#real_amount' do
    it 'should calculate the right real value when the amount is not nil' do
      subject.stub(:amount => 400.0, :reserved_value => 200.0)
      expect(subject.real_amount).to eq(200.0)
    end

    it 'should calculate the right real value when the amount is nil' do
      subject.stub(:amount => nil, :reserved_value => 200.0)
      expect(subject.real_amount).to eq(-200.0)
    end
  end

  context '#function' do
    let :subfunction do
      double(:subfunction, :id => 1, :function => 'Subfunction-Function', :function_id => 2)
    end

    it "should return funtion value if has not a subfunction" do
      subject.function = 'Function'

      expect(subject.function).to eq 'Function'
    end

    it "should return subfunction.function value if has a subfunction" do
      subject.stub(:subfunction => subfunction)

      expect(subject.function).to eq 'Subfunction-Function'
    end

    it "should return funtion_id value if has not a subfunction" do
      subject.function_id = 1

      expect(subject.function_id).to eq 1
    end

    it "should return subfunction.function_id value if has a subfunction" do
      subject.stub(:subfunction => subfunction)

      expect(subject.function_id).to eq 2
    end
  end
end
