# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/administrative_process_budget_allocation_decorator'

describe AdministrativeProcessBudgetAllocationDecorator do
  context '#id_or_mustache_variable' do
    it 'should return mustache variable' do
      subject.stub(:id).and_return(nil)
      subject.id_or_mustache_variable.should eq "{{id}}"
    end

    it 'should return id' do
      subject.stub(:id).and_return(1)
      subject.id_or_mustache_variable.should eq 1
    end
  end

  context '#budget_allocation_id_or_mustache_variable' do
    it 'should return mustache variable' do
      subject.stub(:budget_allocation_id).and_return(nil)
      subject.budget_allocation_id_or_mustache_variable.should eq "{{budget_allocation_id}}"
    end

    it 'should return budget_allocation_id' do
      subject.stub(:budget_allocation_id).and_return(1)
      subject.budget_allocation_id_or_mustache_variable.should eq 1
    end
  end

  context '#budget_allocation_or_mustache_variable' do
    it 'should return mustache variable' do
      subject.stub(:budget_allocation).and_return(nil)

      subject.budget_allocation_or_mustache_variable.should eq "{{description}}"
    end

    it 'should return budget_allocation' do
      subject.stub(:budget_allocation).and_return(1)

      subject.budget_allocation_or_mustache_variable.should eq 1
    end
  end

  context '#budget_allocation_expense_nature_or_mustache_variable' do
    it 'should return mustache variable' do
      subject.stub(:budget_allocation_expense_nature).and_return(nil)

      subject.budget_allocation_expense_nature_or_mustache_variable.should eq "{{expenseNature}}"
    end

    it 'should return expense_nature' do
      subject.stub(:budget_allocation_expense_nature).and_return(1)

      subject.budget_allocation_expense_nature_or_mustache_variable.should eq 1
    end
  end

  context '#budget_allocation_amount_or_mustache_variable' do
    before do
      helpers.stub(:number_with_precision).with(nil).and_return(nil)
      helpers.stub(:number_with_precision).with("1,00").and_return("1,00")
    end

    it 'should return mustache variable' do
      subject.stub(:budget_allocation_amount).and_return(nil)

      subject.budget_allocation_amount_or_mustache_variable.should eq "{{amount}}"
    end

    it 'should return budget_allocation_amount' do
      subject.stub(:budget_allocation_amount).and_return("1,00")

      subject.budget_allocation_amount_or_mustache_variable.should eq "1,00"
    end
  end

  context '#value_or_mustache_variable' do
    before do
      helpers.stub(:number_with_precision).with(nil).and_return(nil)
      helpers.stub(:number_with_precision).with("1,00").and_return("1,00")
    end

    it 'should return mustache variable' do
      subject.stub(:value).and_return(nil)

      subject.value_or_mustache_variable.should eq "{{value}}"
    end

    it 'should return value' do
      subject.stub(:value).and_return("1,00")

      subject.value_or_mustache_variable.should eq "1,00"
    end
  end

  context '#total_items_value' do
    before do
      component.stub(:total_items_value).and_return(100)
      helpers.should_receive(:number_with_precision).with(100).and_return("100,00")
    end

    it 'should return total items value' do
      subject.total_items_value.should eq "100,00"
    end
  end
end
