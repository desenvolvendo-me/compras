require 'unit_helper'
require 'app/business/agreement_bank_account_creation_date_generator'

describe AgreementBankAccountCreationDateGenerator do
  before do
    Date.stub(:current).and_return(current_date)
  end

  let :current_date do
    Date.new(2012, 12, 20)
  end

  context 'when creation_date is not empty' do
    let :bank_account do
      double('BankAccount', :creation_date? => true)
    end

    it 'should not set end_date' do
      described_class.new([bank_account]).change!

      bank_account.should_receive(:creation_date=).never
    end
  end

  context 'when have creation_date' do
    let :bank_account do
      double('BankAccount', :creation_date? => false)
    end

    it 'should set end_date' do
      bank_account.should_receive(:creation_date=).with(current_date).and_return(true)

      described_class.new([bank_account]).change!
    end
  end
end
