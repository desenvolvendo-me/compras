require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/agreement_bank_account_status_changer'

describe AgreementBankAccountStatusChanger do
  subject do
    described_class.new(agreement,
                        status,
                        creation_date_changer,
                        desactivation_date_changer)
  end

  before do
    agreement.stub(:agreement_bank_accounts_not_marked_for_destruction).and_return(accounts)
    creation_date_changer.stub(:new).and_return(creation_date_changer)
    desactivation_date_changer.stub(:new).and_return(desactivation_date_changer)
  end

  let :agreement do
    double('Agreement', :save => true)
  end

  let :status do
    double('Status')
  end

  let :creation_date_changer do
    double('CreationDateChanger', :generate! => true)
  end

  let :desactivation_date_changer do
    double('DesactivationDateChanger', :generate! => true)
  end

  context 'when have two bank_accounts' do
    let :accounts do
      [account_1, account_2]
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

      creation_date_changer.should_receive(:change!).and_return(true)
      desactivation_date_changer.should_receive(:change!).and_return(true)

      subject.change!
    end
  end

  context 'when have only one bank_account' do
    let :accounts do
      [account_1]
    end

    let :account_1 do
      double('Account1', :active? => true)
    end

    it 'should set status as active and clear desactivation_date' do
      status.stub(:value_for).with(:ACTIVE).and_return('active')

      account_1.should_receive(:status=).with('active')
      account_1.should_receive(:desactivation_date=).with(nil)

      creation_date_changer.should_receive(:change!).and_return(true)
      desactivation_date_changer.should_receive(:change!).and_return(true)

      subject.change!
    end
  end
end
