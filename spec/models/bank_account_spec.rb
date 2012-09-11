require 'model_helper'
require 'app/models/bank_account'
require 'app/models/agency'

describe BankAccount do
  let(:subject) { BankAccount.new }
  let(:agency) { Agency.new }
  let(:bank) { mock('bank') }

  it 'return description when converted to string' do
    subject.description = 'Banco do Brasil'
    expect(subject.description).to eq subject.to_s
  end

  it "should delegate bank to agency" do
    agency.should_receive(:bank).and_return(bank)
    subject.agency = agency
    subject.bank
  end

  it "should delegate digit to agency" do
    subject.stub(:agency).and_return(double('Agency', :digit => 9))
    expect(subject.agency_digit).to eq 9
  end

  it "should delegate number to agency" do
    subject.stub(:agency).and_return(double('Agency', :number => 1))
    expect(subject.agency_number).to eq 1
  end

  it { should belong_to :agency }

  it { should have_many(:capabilities).dependent(:destroy) }

  it { should validate_presence_of :description }
  it { should validate_presence_of :agency }
  it { should validate_presence_of :account_number }
  it { should validate_presence_of :digit }
  it { should validate_presence_of :kind }

  it { should allow_value('0077').for(:account_number) }
  it { should allow_value('77').for(:account_number) }
  it { should_not allow_value('0a077').for(:account_number) }
end
