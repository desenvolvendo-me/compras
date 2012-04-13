require 'presenter_helper'
require 'app/presenters/revenue_accounting_presenter'

describe RevenueAccountingPresenter do
  subject do
    described_class.new(revenue_accounting, nil, helpers)
  end

  let :date do
    Date.new(2012, 4, 13)
  end

  let :helpers do
    double.tap do |helpers|
      helpers.stub(:l).with(date).and_return('13/04/2012')
    end
  end

  context 'when have persisted' do
    let :revenue_accounting do
      double(:created_at => Time.new(2012, 4, 13), :persisted? => true)
    end

    it 'should return formatted created_at as date' do
      subject.date.should eq '13/04/2012'
    end
  end

  context 'when have not created_at' do
    let :revenue_accounting do
      double(:persisted? => false)
    end

    let :date_storage do
      double(:current => date)
    end

    it 'should return formatted date current' do
      subject.date(date_storage).should eq '13/04/2012'
    end
  end
end
