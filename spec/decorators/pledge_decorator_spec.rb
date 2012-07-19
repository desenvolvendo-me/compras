# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/pledge_decorator'

describe PledgeDecorator do
  context '#budget_allocation_real_amount' do
    before do
      component.stub(:budget_allocation_real_amount => 500.0)
      helpers.stub(:number_with_precision).with(500.0).and_return("500,00")
    end

    it 'should applies precision' do
      subject.budget_allocation_real_amount.should eq '500,00'
    end
  end

  context '#reserve_fund_value' do
    before do
      component.stub(:reserve_fund_value => 300.0)
      helpers.stub(:number_with_precision).with(300.0).and_return("300,00")
    end

    it 'should applies precision' do
      subject.reserve_fund_value.should eq '300,00'
    end
  end

  context '#pledge_parcels_sum' do
    before do
      component.stub(:pledge_parcels_sum => 300.0)
      helpers.stub(:number_with_precision).with(300.0).and_return("300,00")
    end

    it 'should applies precision' do
      subject.pledge_parcels_sum.should eq '300,00'
    end
  end

  context '#balance' do
    before do
      component.stub(:balance => 100.0)
      helpers.stub(:number_with_precision).with(100.0).and_return("100,00")
    end

    it 'should applies precision' do
      subject.balance.should eq '100,00'
    end
  end

  context '#balance_as_currency' do
    before do
      component.stub(:balance => 100.0)
      helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')
    end

    it 'should applies currency' do
      subject.balance_as_currency.should eq 'R$ 100,00'
    end
  end

  context '#pledge_cancellations_sum' do
    before do
      component.stub(:pledge_cancellations_sum => 100.0)
      helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')
    end

    it 'should applies currency' do
      subject.pledge_cancellations_sum.should eq 'R$ 100,00'
    end
  end

  context '#value' do
    before do
      component.stub(:value => 100.0)
      helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')
    end

    it 'should applies currency' do
      subject.value.should eq 'R$ 100,00'
    end
  end

  context '#pledge_liquidations_sum' do
    before do
      component.stub(:pledge_liquidations_sum).and_return(100.0)
      helpers.stub(:number_with_precision).with(100.0).and_return('100,00')
    end

    it 'should applies precision' do
      subject.pledge_liquidations_sum.should eq '100,00'
    end
  end

  context '#pledge_liquidations_sum_as_currency' do
    before do
      component.stub(:pledge_liquidations_sum).and_return(100.0)
      helpers.stub(:number_to_currency).with(100.0).and_return('100,00')
    end

    it 'should applies currency' do
      subject.pledge_liquidations_sum_as_currency.should eq '100,00'
    end
  end

  context '#contract_signature_date' do
    before do
      component.stub(:contract_signature_date).and_return(Date.new(2012, 6, 12))
      helpers.stub(:l).with(Date.new(2012, 6, 12)).and_return('12/06/2012')
    end

    it 'should localize' do
      subject.contract_signature_date.should eq '12/06/2012'
    end
  end

  context '#emission_date' do
    before do
      component.stub(:emission_date).and_return(Date.new(2012, 6, 12))
      helpers.stub(:l).with(Date.new(2012, 6, 12)).and_return('12/06/2012')
    end

    it 'should localize' do
      subject.emission_date.should eq '12/06/2012'
    end
  end
end
