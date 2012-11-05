require 'model_helper'
require 'app/models/bank_account_capability'

describe BankAccountCapability do
  it { should belong_to :bank_account }
  it { should belong_to :capability }

  it { should validate_presence_of :capability }

   describe "activate!" do
    it 'should change status and date' do
      subject.status = Status::INACTIVE

      subject.should_receive(:save!).and_return(true)

      subject.activate!(Date.current)

      expect(subject.status).to eq Status::ACTIVE
      expect(subject.date).to eq Date.current
    end
  end

   describe "inactivate!" do
    it 'should change status and inactivation date' do
      subject.status = Status::ACTIVE

      subject.should_receive(:save!).and_return(true)

      subject.inactivate!(Date.current)

      expect(subject.status).to eq Status::INACTIVE
      expect(subject.inactivation_date).to eq Date.current
    end
  end
end
