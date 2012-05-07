require 'decorator_helper'
require 'app/decorators/revenue_accounting_decorator'

describe RevenueAccountingDecorator do
  let :date do
    Date.new(2012, 4, 13)
  end

  context 'when have persisted' do
    it 'should return formatted created_at as date' do
      component.stub(:created_at).and_return(Time.new(2012, 4, 13))
      component.stub(:persisted?).and_return(true)
      helpers.stub(:l).with(date).and_return('13/04/2012')

      subject.date.should eq '13/04/2012'
    end
  end

  context 'when have not created_at' do
    let :date_storage do
      double(:current => date)
    end

    it 'should return formatted date current' do
      component.stub(:persisted?).and_return(false)
      helpers.stub(:l).with(date).and_return('13/04/2012')

      subject.date(date_storage).should eq '13/04/2012'
    end
  end
end
