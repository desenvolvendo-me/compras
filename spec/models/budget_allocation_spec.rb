require 'model_helper'
require 'app/models/budget_structure'
require 'app/models/expense_nature'
require 'app/models/budget_allocation'

describe BudgetAllocation do
  describe '#can_be_used?' do
    let(:purchase_process) { double(:purchase_process, id: 10) }

    context 'when has a pledge_request' do
      it 'should be false' do
        subject.stub(has_pledge_request?: true)
        subject.stub(has_reserve_fund?: false)

        expect(subject.can_be_used?(purchase_process)).to be_false
      end
    end

    context 'when has a reserve_fund' do
      it 'should be false' do
        subject.stub(has_reserve_fund?: true)
        subject.stub(has_pledge_request?: false)

        expect(subject.can_be_used?(purchase_process)).to be_false
      end
    end

    context 'when has a reserve_fund and a pledge_request' do
      it 'should be false' do
        subject.stub(has_reserve_fund?: true)
        subject.stub(has_pledge_request?: true)

        expect(subject.can_be_used?(purchase_process)).to be_false
      end
    end

    context 'when has no reserve_fund neither pledge_request' do
      it 'should be true' do
        subject.stub(has_reserve_fund?: false)
        subject.stub(has_pledge_request?: false)

        expect(subject.can_be_used?(purchase_process)).to be_true
      end
    end
  end
end
