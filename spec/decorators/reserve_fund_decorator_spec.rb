# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/reserve_fund_decorator'

describe ReserveFundDecorator do
  context '#budget_allocation_real_amount' do
    before do
      component.stub(:budget_allocation_real_amount).and_return(5000.0)
    end

    it 'should applies precision' do
      subject.budget_allocation_real_amount.should eq '5.000,00'
    end
  end
end
