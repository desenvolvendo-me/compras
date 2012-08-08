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
        expect(subject.budget_allocation_real_amount).to be_nil
      end
    end

    context 'when have budget_allocation_real_amount' do
      before do
        component.stub(:budget_allocation_real_amount).and_return(500.0)
      end

      it 'should applies precision' do
        expect(subject.budget_allocation_real_amount).to eq '500,00'
      end
    end
  end

  context '#reserve_fund_value' do
    context 'when do not have reserve_fund_value' do
      before do
        component.stub(:reserve_fund_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.reserve_fund_value).to be_nil
      end
    end

    context 'when have reserve_fund_value' do
      before do
        component.stub(:reserve_fund_value).and_return(300.0)
      end

      it 'should applies precision' do
        expect(subject.reserve_fund_value).to eq '300,00'
      end
    end
  end

  context '#pledge_parcels_sum' do
    context 'when do not have pledge_parcels_sum' do
      before do
        component.stub(:pledge_parcels_sum).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.pledge_parcels_sum).to be_nil
      end
    end

    context 'when have pledge_parcels_sum' do
      before do
        component.stub(:pledge_parcels_sum).and_return(300.0)
      end

      it 'should applies precision' do
        expect(subject.pledge_parcels_sum).to eq '300,00'
      end
    end
  end

  context '#balance' do
    context 'when do not have balance' do
      before do
        component.stub(:balance).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.balance).to be_nil
      end
    end

    context 'when have balance' do
      before do
        component.stub(:balance).and_return(100.0)
      end

      it 'should applies precision' do
        expect(subject.balance).to eq '100,00'
      end
    end
  end

  context '#balance_as_currency' do
    context 'when do not have balance' do
      before do
        component.stub(:balance).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.balance_as_currency).to be_nil
      end
    end

    context 'when have balance' do
      before do
        component.stub(:balance).and_return(100.0)
      end

      it 'should applies currency' do
        expect(subject.balance_as_currency).to eq 'R$ 100,00'
      end
    end
  end

  context '#pledge_cancellations_sum' do
    context 'when do not have pledge_cancellations_sum' do
      before do
        component.stub(:pledge_cancellations_sum).and_return(nil)
      end

      it 'should nil' do
        expect(subject.pledge_cancellations_sum).to be_nil
      end
    end

    context 'when have pledge_cancellations_sum' do
      before do
        component.stub(:pledge_cancellations_sum).and_return(100.0)
      end

      it 'should applies currency' do
        expect(subject.pledge_cancellations_sum).to eq 'R$ 100,00'
      end
    end
  end

  context '#value' do
    context 'when do not have value' do
      before do
        component.stub(:value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.value).to be_nil
      end
    end

    context 'when have value' do
      before do
        component.stub(:value).and_return(100.0)
      end

      it 'should applies currency' do
        expect(subject.value).to eq 'R$ 100,00'
      end
    end
  end

  context '#pledge_liquidations_sum' do
    context 'when do not have pledge_liquidations_sum' do
      before do
        component.stub(:pledge_liquidations_sum).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.pledge_liquidations_sum).to be_nil
      end
    end

    context 'when have pledge_liquidations_sum' do
      before do
        component.stub(:pledge_liquidations_sum).and_return(100.0)
      end

      it 'should applies precision' do
        expect(subject.pledge_liquidations_sum).to eq '100,00'
      end
    end
  end

  context '#pledge_liquidations_sum_as_currency' do
    context 'when do not have pledge_liquidations_sum' do
      before do
        component.stub(:pledge_liquidations_sum).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.pledge_liquidations_sum_as_currency).to be_nil
      end
    end

    context 'when have pledge_liquidations_sum' do
      before do
        component.stub(:pledge_liquidations_sum).and_return(100.0)
      end

      it 'should applies currency' do
        expect(subject.pledge_liquidations_sum_as_currency).to eq 'R$ 100,00'
      end
    end
  end

  context '#contract_signature_date' do
    context 'when do not have contract_signature_date' do
      before do
        component.stub(:contract_signature_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.contract_signature_date).to be_nil
      end
    end

    context 'when have contract_signature_date' do
      before do
        component.stub(:contract_signature_date).and_return(Date.new(2012, 6, 12))
      end

      it 'should localize' do
        expect(subject.contract_signature_date).to eq '12/06/2012'
      end
    end
  end

  context '#emission_date' do
    context 'when do not have emission_date' do
      before do
        component.stub(:emission_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.emission_date).to be_nil
      end
    end

    context 'when have emission_date' do
      before do
        component.stub(:emission_date).and_return(Date.new(2012, 6, 12))
      end

      it 'should localize' do
        expect(subject.emission_date).to eq '12/06/2012'
      end
    end
  end
end
