# encoding: utf-8
require 'spec_helper'

describe Agreement do
  context '#status' do
    it 'should return active when first occurrence is in_progress' do
      subject = Agreement.make!(:apoio_ao_turismo_with_2_occurrences)

      expect(subject.status).to be Status::ACTIVE
    end

    it 'should return inactive when first occurrence is not in_progress' do
      subject = Agreement.make!(:apoio_ao_turismo_with_2_occurrences_inactive)

      expect(subject.status).to be Status::INACTIVE
    end
  end

  context 'ordering bank accounts creation date desc and status' do
    it 'highest creation date should be first' do
      bank_account_1 = AgreementBankAccount.make!(:itau)
      bank_account_2 = AgreementBankAccount.make!(:santander)

      subject = Agreement.make!(:apoio_ao_turismo, :agreement_bank_accounts => [bank_account_1, bank_account_2])

      expect(subject.agreement_bank_accounts.first).to eq bank_account_2
    end

    it 'active should be first' do
      bank_account_active = AgreementBankAccount.make!(:santander)
      bank_account_inactive = AgreementBankAccount.make!(:itau_2)

      subject = Agreement.make!(:apoio_ao_turismo, :agreement_bank_accounts => [bank_account_active, bank_account_inactive])

      expect(subject.agreement_bank_accounts.first).to eq bank_account_active
    end
  end
end
