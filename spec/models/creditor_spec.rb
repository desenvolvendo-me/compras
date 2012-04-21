require 'model_helper'
require 'app/models/creditor'
require 'app/models/pledge'
require 'app/models/reserve_fund'

describe Creditor do
  it 'should return to_s as name' do
    subject.name = 'Empresa LTDA.'
    subject.to_s.should eq 'Empresa LTDA.'
  end

  it { should belong_to :entity }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:reserve_funds).dependent(:restrict) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :status }
  it { should validate_presence_of :entity }
end
