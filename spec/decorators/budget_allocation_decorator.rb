# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/budget_allocation_decorator'

describe BudgetAllocationDecorator do
  context '#real_amount' do
    context 'when do not have real_amount' do
      before do
        component.stub(:real_amount).and_return(nil)
      end

      it 'should be nil' do
        subject.real_amount.should be_nil
      end
    end

    context 'when have real_amount' do
      before do
        component.stub(:real_amount).and_return(500.0)
      end

      it 'should applies precision' do
        subject.real_amount.should eq '500,00'
      end
    end
  end

  context '#reserved_value' do
    context 'when do not have reserved_value' do
      before do
        component.stub(:reserved_value).and_return(nil)
      end

      it 'should be nil' do
        subject.reserved_value.should be_nil
      end
    end

    context 'when have reserved_value' do
      before do
        component.stub(:reserved_value).and_return(500.0)
      end

      it 'should applies precision' do
        subject.reserved_value.should eq '500,00'
      end
    end
  end
end
