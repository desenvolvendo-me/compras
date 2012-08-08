# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/reserve_fund_decorator'

describe ReserveFundDecorator do
  context '#budget_allocation_real_amount' do
    context 'when do not have budget_allocation_real_amount' do
      before do
        component.stub(:budget_allocation_real_amount).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.budget_allocation_real_amount).to be_nil
      end
    end
  end

  context '#budget_allocation_real_amount' do
    context 'when have budget_allocation_real_amount' do
      before do
        component.stub(:budget_allocation_real_amount).and_return(5000.0)
      end

      it 'should applies precision' do
        expect(subject.budget_allocation_real_amount).to eq '5.000,00'
      end
    end
  end
end
