# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/pledge_decorator'

describe PledgeDecorator do
  context '#budget_allocation_real_amount' do
    context 'when do not have budget_allocation_real_amount' do
      before do
        component.stub(:budget_allocation_real_amount).and_return(nil)
      end

      it 'should be nil' do
        subject.budget_allocation_real_amount.should be_nil
      end
    end

    context 'when have budget_allocation_real_amount' do
      before do
        component.stub(:budget_allocation_real_amount).and_return(500.0)
      end

      it 'should applies precision' do
        subject.budget_allocation_real_amount.should eq '500,00'
      end
    end
  end

  context '#reserve_fund_value' do
    context 'when do not have reserve_fund_value' do
      before do
        component.stub(:reserve_fund_value).and_return(nil)
      end

      it 'should be nil' do
        subject.reserve_fund_value.should be_nil
      end
    end

    context 'when have reserve_fund_value' do
      before do
        component.stub(:reserve_fund_value).and_return(300.0)
      end

      it 'should applies precision' do
        subject.reserve_fund_value.should eq '300,00'
      end
    end
  end

  context '#pledge_parcels_sum' do
    context 'when do not have pledge_parcels_sum' do
      before do
        component.stub(:pledge_parcels_sum).and_return(nil)
      end

      it 'should be nil' do
        subject.pledge_parcels_sum.should be_nil
      end
    end

    context 'when have pledge_parcels_sum' do
      before do
        component.stub(:pledge_parcels_sum).and_return(300.0)
      end

      it 'should applies precision' do
        subject.pledge_parcels_sum.should eq '300,00'
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
        component.stub(:balance).and_return(100.0)
      end

      it 'should applies precision' do
        subject.balance.should eq '100,00'
      end
    end
  end

  context '#balance_as_currency' do
    context 'when do not have balance' do
      before do
        component.stub(:balance).and_return(nil)
      end

      it 'should be nil' do
        subject.balance_as_currency.should be_nil
      end
    end

    context 'when have balance' do
      before do
        component.stub(:balance).and_return(100.0)
      end

      it 'should applies currency' do
        subject.balance_as_currency.should eq 'R$ 100,00'
      end
    end
  end

  context '#pledge_cancellations_sum' do
    context 'when do not have pledge_cancellations_sum' do
      before do
        component.stub(:pledge_cancellations_sum).and_return(nil)
      end

      it 'should nil' do
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

  context '#value' do
    context 'when do not have value' do
      before do
        component.stub(:value).and_return(nil)
      end

      it 'should be nil' do
        subject.value.should be_nil
      end
    end

    context 'when have value' do
      before do
        component.stub(:value).and_return(100.0)
      end

      it 'should applies currency' do
        subject.value.should eq 'R$ 100,00'
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

      it 'should applies precision' do
        subject.pledge_liquidations_sum.should eq '100,00'
      end
    end
  end

  context '#pledge_liquidations_sum_as_currency' do
    context 'when do not have pledge_liquidations_sum' do
      before do
        component.stub(:pledge_liquidations_sum).and_return(nil)
      end

      it 'should be nil' do
        subject.pledge_liquidations_sum_as_currency.should be_nil
      end
    end

    context 'when have pledge_liquidations_sum' do
      before do
        component.stub(:pledge_liquidations_sum).and_return(100.0)
      end

      it 'should applies currency' do
        subject.pledge_liquidations_sum_as_currency.should eq 'R$ 100,00'
      end
    end
  end

  context '#contract_signature_date' do
    context 'when do not have contract_signature_date' do
      before do
        component.stub(:contract_signature_date).and_return(nil)
      end

      it 'should be nil' do
        subject.contract_signature_date.should be_nil
      end
    end

    context 'when have contract_signature_date' do
      before do
        component.stub(:contract_signature_date).and_return(Date.new(2012, 6, 12))
      end

      it 'should localize' do
        subject.contract_signature_date.should eq '12/06/2012'
      end
    end
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
        component.stub(:emission_date).and_return(Date.new(2012, 6, 12))
      end

      it 'should localize' do
        subject.emission_date.should eq '12/06/2012'
      end
    end
  end
end
