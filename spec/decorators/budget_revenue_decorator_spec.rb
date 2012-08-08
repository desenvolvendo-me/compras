require 'decorator_helper'
require 'app/decorators/budget_revenue_decorator'

describe BudgetRevenueDecorator do
  context 'when have persisted' do
    before do
      component.stub(:created_at).and_return(Time.new(2012, 4, 13))
      component.stub(:persisted?).and_return(true)
    end

    it 'should localize' do
      expect(subject.date).to eq '13/04/2012'
    end
  end

  context 'when have not persisted' do
    before do
      component.stub(:persisted?).and_return(false)
    end

    let :date_repository do
      double('DateRepository', :current => Date.new(2012, 4, 13))
    end

    it 'should localize Date.current' do
      expect(subject.date(date_repository)).to eq '13/04/2012'
    end
  end
end
