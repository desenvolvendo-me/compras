require 'model_helper'
require 'app/models/bank_account_capability'

describe BankAccountCapability do
  it { should belong_to :bank_account }
  it { should belong_to :capability }

  it { should validate_presence_of :capability }

  describe "#to_s" do
    it 'should return capability on to_s calls' do
      subject.stub(:capability => 'Recurso')

      expect(subject.to_s).to eq 'Recurso'
    end
  end
end
