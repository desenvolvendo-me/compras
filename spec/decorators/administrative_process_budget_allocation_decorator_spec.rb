# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/administrative_process_budget_allocation_decorator'

describe AdministrativeProcessBudgetAllocationDecorator do
  context '#id_or_mustache_variable' do
    context 'when do not have id' do
      before do
        component.stub(:id).and_return(nil)
      end

      it 'should return mustache variable' do
        subject.id_or_mustache_variable.should eq "{{id}}"
      end
    end

    context 'when do not have id' do
      before do
        component.stub(:id).and_return(1)
      end

      it 'should return id' do
        subject.id_or_mustache_variable.should eq 1
      end
    end
  end

  context '#budget_allocation_id_or_mustache_variable' do
    it 'should return mustache variable' do
      component.stub(:budget_allocation_id).and_return(nil)
      subject.budget_allocation_id_or_mustache_variable.should eq "{{budget_allocation_id}}"
    end

    it 'should return budget_allocation_id' do
      component.stub(:budget_allocation_id).and_return(1)
      subject.budget_allocation_id_or_mustache_variable.should eq 1
    end
  end

  context '#budget_allocation_or_mustache_variable' do
    it 'should return mustache variable' do
      component.stub(:budget_allocation).and_return(nil)

      subject.budget_allocation_or_mustache_variable.should eq "{{description}}"
    end

    it 'should return budget_allocation' do
      component.stub(:budget_allocation).and_return(1)

      subject.budget_allocation_or_mustache_variable.should eq 1
    end
  end

  context '#budget_allocation_expense_nature_or_mustache_variable' do
    it 'should return mustache variable' do
      component.stub(:budget_allocation_expense_nature).and_return(nil)

      subject.budget_allocation_expense_nature_or_mustache_variable.should eq "{{expenseNature}}"
    end

    it 'should return expense_nature' do
      component.stub(:budget_allocation_expense_nature).and_return(1)

      subject.budget_allocation_expense_nature_or_mustache_variable.should eq 1
    end
  end

  context '#budget_allocation_amount_or_mustache_variable' do
    it 'should return mustache variable' do
      component.stub(:budget_allocation_amount).and_return(nil)

      subject.budget_allocation_amount_or_mustache_variable.should eq "{{amount}}"
    end

    it 'should return budget_allocation_amount' do
      component.stub(:budget_allocation_amount).and_return("1,00")

      subject.budget_allocation_amount_or_mustache_variable.should eq "1,00"
    end
  end

  context '#value_or_mustache_variable' do
    it 'should return mustache variable' do
      component.stub(:value).and_return(nil)

      subject.value_or_mustache_variable.should eq "{{value}}"
    end

    it 'should return value' do
      component.stub(:value).and_return("1,00")

      subject.value_or_mustache_variable.should eq "1,00"
    end
  end

  context '#total_items_value' do
    before do
      component.stub(:total_items_value).and_return(100)
    end

    it 'should return total items value' do
      subject.total_items_value.should eq "100,00"
    end
  end
end
