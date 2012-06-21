require 'model_helper'
require 'app/uploaders/document_uploader'
require 'app/models/contract'
require 'app/models/dissemination_source'
require 'app/models/contract_termination'

describe ContractTermination do
  it { should belong_to :contract }
  it { should belong_to :dissemination_source }

  it { should validate_presence_of :number }
  it { should validate_presence_of :year }
  it { should validate_presence_of :contract }
  it { should validate_presence_of :reason }
  it { should validate_presence_of :expiry_date }
  it { should validate_presence_of :termination_date }
  it { should validate_presence_of :publication_date }
  it { should validate_presence_of :dissemination_source }

  it { should_not allow_value('12').for(:year) }
  it { should allow_value('1234').for(:year) }

  describe 'ContractTermination#next_number' do
    subject { described_class}

    before do
      subject.stub(:last_number).and_return 1
    end

    it 'returns the last number + 1' do
      subject.next_number(2012).should eq 2
    end
  end
end
