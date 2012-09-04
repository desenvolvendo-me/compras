require 'model_helper'
require 'app/models/checking_account_of_fiscal_account'

describe CheckingAccountOfFiscalAccount do
  it 'should return name as to_s' do
    subject.name = 'Disponibilidade financeira'
    expect(subject.to_s).to eq 'Disponibilidade financeira'
  end

  it { should validate_presence_of :tce_code }
  it { should validate_presence_of :name }
  it { should validate_presence_of :main_tag }

  it { should have_many(:checking_account_structures).dependent(:restrict) }
end
