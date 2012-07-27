require 'decorator_helper'
require 'app/decorators/pledge_cancellation_decorator'

describe PledgeCancellationDecorator do
  let :date do
    Date.new(2012, 12, 1)
  end

  context '#emission_date' do
    context 'when do not have emission_date' do
      before do
        component.stub(:emission_date).and_return(nil)
      end

      it 'should be nil' do
        subject.emission_date.should be_nil
      end
    end

    context 'when have emission_date' do
      before do
        component.stub(:emission_date).and_return(date)
      end

      it 'should localize' do
        subject.emission_date.should eq '01/12/2012'
      end
    end
  end

  context 'expiration_date' do
    context 'when do not have expiration_date' do
      before do
        component.stub(:expiration_date).and_return(nil)
      end

      it 'should be nil' do
        subject.expiration_date.should be_nil
      end
    end

    context 'when have expiration_date' do
      before do
        component.stub(:expiration_date).and_return(date)
      end

      it 'should localize' do
        subject.expiration_date.should eq '01/12/2012'
      end
    end
  end

  context '#balance' do
    context 'when do not have balance' do
      before do
        component.stub(:balance).and_return(nil)
      end

      it 'should be nil' do
        subject.balance.should be_nil
      end
    end

    context 'when have balance' do
      before do
        component.stub(:balance).and_return(9.99)
      end

      it 'should applies precision' do
        subject.balance.should eq '9,99'
      end
    end
  end

  context '#pledge_value' do
    context 'when do not have pledge_value' do
      before do
        component.stub(:pledge_value).and_return(nil)
      end

      it 'should be nil' do
        subject.pledge_value.should be_nil
      end
    end

    context 'when have pledge_value' do
      before do
        component.stub(:pledge_value).and_return(10.0)
      end

      it 'should applies currency' do
        subject.pledge_value.should eq 'R$ 10,00'
      end
    end
  end

  context '#pledge_balance' do
    context 'when have pledge_balance' do
      before do
        component.stub(:pledge_balance).and_return(nil)
      end

      it 'should be nil' do
        subject.pledge_balance.should be_nil
      end
    end

    context 'when have pledge_balance' do
      before do
        component.stub(:pledge_balance).and_return(100.0)
      end

      it 'should applies currency' do
        subject.pledge_balance.should eq 'R$ 100,00'
      end
    end
  end

  context '#pledge_cancellations_sum' do
    context 'when do not have pledge_cancellations_sum' do
      before do
        component.stub(:pledge_cancellations_sum).and_return(nil)
      end

      it 'should be nil' do
        subject.pledge_cancellations_sum.should be_nil
      end
    end

    context 'when have pledge_cancellations_sum' do
      before do
        component.stub(:pledge_cancellations_sum).and_return(100.0)
      end

      it 'should applies currency' do
        subject.pledge_cancellations_sum.should eq 'R$ 100,00'
      end
    end
  end

  context '#pledge_liquidations_sum' do
    context 'when do not have pledge_liquidations_sum' do
      before do
        component.stub(:pledge_liquidations_sum).and_return(nil)
      end

      it 'should be nil' do
        subject.pledge_liquidations_sum.should be_nil
      end
    end

    context 'when have pledge_liquidations_sum' do
      before do
        component.stub(:pledge_liquidations_sum).and_return(100.0)
      end

      it 'should applies currency' do
        subject.pledge_liquidations_sum.should eq 'R$ 100,00'
      end
    end
  end
end
