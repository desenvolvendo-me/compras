require 'unit_helper'
require 'app/business/agreement_bank_account_status_changer'

describe AgreementBankAccountStatusChanger do
  let :status do
    double('Status')
  end

  context 'when have two bank_accounts' do
    subject do
      described_class.new([account_1, account_2], status)
    end

    let :account_1 do
      double('Account1', :active? => false)
    end

    let :account_2 do
      double('Account2', :active? => true)
    end

    it 'should set status and clear desactivation_date if was active' do
      status.stub(:value_for).with(:INACTIVE).and_return('inactive')
      status.stub(:value_for).with(:ACTIVE).and_return('active')

      account_1.should_receive(:status=).with('inactive')
      account_2.should_receive(:desactivation_date=).with(nil)
      account_2.should_receive(:status=).with('active')

      subject.change!
    end
  end

  context 'when have only one bank_account' do
    subject do
      described_class.new([account_1], status)
    end

    let :account_1 do
      double('Account1', :active? => true)
    end

    it 'should set status as active and clear desactivation_date' do
      status.stub(:value_for).with(:ACTIVE).and_return('active')

      account_1.should_receive(:status=).with('active')
      account_1.should_receive(:desactivation_date=).with(nil)

      subject.change!
    end
  end
end
