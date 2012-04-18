# encoding: utf-8
require 'model_helper'
require 'app/models/administrative_process_budget_allocation'

describe AdministrativeProcessBudgetAllocation do
  it { should belong_to :administrative_process }
  it { should belong_to :budget_allocation }
  it { should have_many(:items).dependent(:destroy).order(:id) }

  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :value }

  it 'should get the correct attributes for data' do
    expense_nature = double(:to_s => 'nature')

    budget_allocation = double(:to_s => 'allocation',
                               :expense_nature => expense_nature,
                               :amount => 300.0)

    subject.stub(:budget_allocation_id).and_return(5)
    subject.stub(:budget_allocation).and_return(budget_allocation)
    subject.stub(:value).and_return(400.0)
    subject.id = 3

    subject.attributes_for_data.should eq({'id' => 3,
                                           'budget_allocation_id' => 5,
                                           'description' => 'allocation',
                                           'value' => 400.0,
                                           'expense_nature' => 'nature',
                                           'amount' => 300.0})
  end

  it "the duplicated materials should be invalid except the first" do
    item_one = subject.items.build(:material_id => 1)
    item_two = subject.items.build(:material_id => 1)

    subject.valid?

    item_one.errors.messages[:material_id].should be_nil
    item_two.errors.messages[:material_id].should include "já está em uso"
  end

  it "the diferent materials should be valid" do
    item_one = subject.items.build(:material_id => 1)
    item_two = subject.items.build(:material_id => 2)

    subject.valid?

    item_one.errors.messages[:material_id].should be_nil
    item_two.errors.messages[:material_id].should be_nil
  end
end
