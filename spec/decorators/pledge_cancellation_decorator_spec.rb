require 'decorator_helper'
require 'app/decorators/pledge_cancellation_decorator'

describe PledgeCancellationDecorator do
  let :date do
    Date.new(2012, 12, 1)
  end

  context '#emission_date' do
    before do
      component.stub(:emission_date).and_return(date)
      helpers.stub(:l).with(date).and_return('01/12/2012')
    end

    it 'should localize' do
      subject.emission_date.should eq '01/12/2012'
    end
  end

  context 'expiration_date' do
    before do
      component.stub(:expiration_date).and_return(date)
      helpers.stub(:l).with(date).and_return('01/12/2012')
    end

    it 'should localize' do
      subject.expiration_date.should eq '01/12/2012'
    end
  end

  context '#balance' do
    before do
      component.stub(:balance).and_return(9.99)
      helpers.stub(:number_with_precision).with(9.99).and_return('9,99')
    end

    it 'should applies precision' do
      subject.balance.should eq '9,99'
    end
  end

  context '#pledge_value' do
    before do
      component.stub(:pledge_value).and_return(10.0)
      helpers.stub(:number_to_currency).with(10.0).and_return('R$ 10,00')
    end

    it 'should applies currency' do
      subject.pledge_value.should eq 'R$ 10,00'
    end
  end

  context '#pledge_balance' do
    before do
      component.stub(:pledge_balance).and_return(100.0)
      helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')
    end

    it 'should applies currency' do
      subject.pledge_balance.should eq 'R$ 100,00'
    end
  end

  context '#pledge_cancellations_sum' do
    before do
      component.stub(:pledge_cancellations_sum).and_return(100.0)
      helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')
    end

    it 'should applies currency' do
      subject.pledge_cancellations_sum.should eq 'R$ 100,00'
    end
  end

  context '#pledge_liquidations_sum' do
    before do
      component.stub(:pledge_liquidations_sum).and_return(100.0)
      helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')
    end

    it 'should applies currency' do
      subject.pledge_liquidations_sum.should eq 'R$ 100,00'
    end
  end
end
