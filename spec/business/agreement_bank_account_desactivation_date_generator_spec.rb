require 'unit_helper'
require 'app/business/agreement_bank_account_desactivation_date_generator'

describe AgreementBankAccountDesactivationDateGenerator do
  before do
    Date.stub(:current).and_return(current_date)
  end

  let :current_date do
    Date.new(2012, 12, 20)
  end

  context 'when have desactivation_date' do
    let :bank_account do
      double('BankAccount', :desactivation_date? => true)
    end

    it 'should do nothing' do
      described_class.new([bank_account]).change!

      bank_account.should_receive(:desactivation_date=).never
    end
  end

  context 'when dont have desactivation_date' do
    let :bank_account_1 do
      double('BankAccount1',
             :desactivation_date? => true,
             :desactivation_date => Date.current)
    end

    let :bank_account_2 do
      double('BankAccount2', :desactivation_date? => false)
    end

    it 'should set desactivation_date if is blank' do
      bank_account_1.should_receive(:desactivation_date=).never
      bank_account_2.should_receive(:desactivation_date=).with(current_date).and_return(true)

      described_class.new([bank_account_1, bank_account_2]).change!
    end
  end
end
