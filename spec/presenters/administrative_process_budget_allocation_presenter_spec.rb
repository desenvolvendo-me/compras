# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/administrative_process_budget_allocation_presenter'

describe AdministrativeProcessBudgetAllocationPresenter do
  subject do
    described_class.new(administrative_process_budget_allocation, nil, helpers)
  end

  let :administrative_process_budget_allocation do
    double()
  end

  let(:helpers) { double }

  it 'should return the id or mustache variable' do
    subject.stub(:id).and_return(nil)

    subject.id_or_mustache_variable.should eq "{{id}}"

    subject.stub(:id).and_return(1)

    subject.id_or_mustache_variable.should eq 1
  end

  it 'should return the budget_allocation_id or mustache variable' do
    subject.stub(:budget_allocation_id).and_return(nil)

    subject.budget_allocation_id_or_mustache_variable.should eq "{{budget_allocation_id}}"

    subject.stub(:budget_allocation_id).and_return(1)

    subject.budget_allocation_id_or_mustache_variable.should eq 1
  end

  it 'should return the budget_allocation or mustache variable' do
    subject.stub(:budget_allocation).and_return(nil)

    subject.budget_allocation_or_mustache_variable.should eq "{{description}}"

    subject.stub(:budget_allocation).and_return(1)

    subject.budget_allocation_or_mustache_variable.should eq 1
  end

  it 'should return the expense_nature or mustache variable' do
    subject.stub(:budget_allocation_expense_nature).and_return(nil)

    subject.budget_allocation_expense_nature_or_mustache_variable.should eq "{{expenseNature}}"

    subject.stub(:budget_allocation_expense_nature).and_return(1)

    subject.budget_allocation_expense_nature_or_mustache_variable.should eq 1
  end

  it 'should return the budget_allocation_amount or mustache variable' do
    helpers.stub(:number_with_precision).with(nil).and_return(nil)
    helpers.stub(:number_with_precision).with("1,00").and_return("1,00")

    subject.stub(:budget_allocation_amount).and_return(nil)

    subject.budget_allocation_amount_or_mustache_variable.should eq "{{amount}}"

    subject.stub(:budget_allocation_amount).and_return("1,00")

    subject.budget_allocation_amount_or_mustache_variable.should eq "1,00"
  end

  it 'should return the value or mustache variable' do
    helpers.stub(:number_with_precision).with(nil).and_return(nil)
    helpers.stub(:number_with_precision).with("1,00").and_return("1,00")

    subject.stub(:value).and_return(nil)

    subject.value_or_mustache_variable.should eq "{{value}}"

    subject.stub(:value).and_return("1,00")

    subject.value_or_mustache_variable.should eq "1,00"
  end

  it 'should return the total items value' do
    helpers.should_receive(:number_with_precision).with(100).and_return("100,00")

    administrative_process_budget_allocation.stub(:total_items_value).and_return(100)

    subject.total_items_value.should eq "100,00"
  end
end
