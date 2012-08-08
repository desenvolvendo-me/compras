require 'model_helper'
require 'app/models/bank_account'
require 'app/models/agency'

describe BankAccount do
  let(:subject) { BankAccount.new }
  let(:agency) { Agency.new }
  let(:bank) { mock('bank') }

  it 'return name when converted to string' do
    subject.name = 'Banco do Brasil'
    expect(subject.name).to eq subject.to_s
  end

  it "should delegate bank to agency" do
    agency.should_receive(:bank).and_return(bank)
    subject.agency = agency
    subject.bank
  end

  it { should belong_to :agency }

  it { should validate_presence_of :name }
  it { should validate_presence_of :agency }
  it { should validate_presence_of :account_number }
  it { should validate_presence_of :number_agreement }
  it { should validate_presence_of :originator }

end
