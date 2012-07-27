# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/administrative_process_budget_allocation_decorator'

describe AdministrativeProcessBudgetAllocationDecorator do
  context '#budget_allocation_amount' do
    context 'when do not have budget_allocation_amount' do
      before do
        component.stub(:budget_allocation_amount).and_return(nil)
      end

      it 'should be nil' do
        subject.budget_allocation_amount.should be_nil
      end
    end

    context 'when have budget_allocation_amount' do
      before do
        component.stub(:budget_allocation_amount).and_return(10)
      end

      it 'should return budget_allocation_amount' do
        subject.budget_allocation_amount.should eq "10,00"
      end
    end
  end

  context '#value' do
    context 'when do not have value' do
      before do
        component.stub(:value).and_return(nil)
      end

      it 'should be nil' do
        subject.value.should be_nil
      end
    end

    context 'when have value' do
      before do
        component.stub(:value).and_return(15)
      end

      it 'should return value' do
        subject.value.should eq "15,00"
      end
    end
  end

  context '#total_items_value' do
    context 'when do not have total_items_value' do
      before do
        component.stub(:total_items_value).and_return(nil)
      end

      it 'should be nil' do
        subject.total_items_value.should eq nil
      end
    end

    context 'when have total_items_value' do
      before do
        component.stub(:total_items_value).and_return(100)
      end

      it 'should return total items value' do
        subject.total_items_value.should eq "100,00"
      end
    end
  end
end
