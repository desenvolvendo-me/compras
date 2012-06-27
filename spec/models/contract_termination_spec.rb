require 'model_helper'
require 'app/uploaders/document_uploader'
require 'app/models/contract'
require 'app/models/dissemination_source'
require 'app/models/contract_termination'

describe ContractTermination do
  it { should belong_to :contract }
  it { should belong_to :dissemination_source }

  it { should validate_presence_of :year }
  it { should validate_presence_of :contract }
  it { should validate_presence_of :reason }
  it { should validate_presence_of :expiry_date }
  it { should validate_presence_of :termination_date }
  it { should validate_presence_of :publication_date }
  it { should validate_presence_of :dissemination_source }

  it { should_not allow_value('12').for(:year) }
  it { should allow_value('1234').for(:year) }

  describe '#next_number' do
    before do
      described_class.stub(:last_number).and_return 1
      subject.stub(:year).and_return 2012
    end

    it 'returns the last number + 1' do
      subject.next_number.should eq 2
    end
  end

  describe 'generate the number' do
    before do
      described_class.stub(:last_number).and_return 1
    end

    it 'assigns the next_number' do
      subject.run_callbacks(:create)

      subject.number.should eq 2
    end

    it 'overrides the number' do
      subject.number = 30

      subject.run_callbacks(:create)

      subject.number.should eq 2
    end
  end
end
