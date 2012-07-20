# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/budget_allocation_decorator'

describe BudgetAllocationDecorator do
  context '#real_amount' do
    before do
      component.stub(:real_amount => 500.0)
    end

    it 'should applies precision' do
      subject.real_amount.should eq '500,00'
    end
  end

  context '#reserved_value' do
    before do
      component.stub(:reserved_value => 500.0)
    end

    it 'should applies precision' do
      subject.reserved_value.should eq '500,00'
    end
  end
end
