require 'model_helper'
require 'app/uploaders/document_uploader'
require 'app/models/contract'
require 'app/models/dissemination_source'
require 'app/models/contract_termination'
require 'lib/annullable'
require 'app/models/resource_annul'

describe ContractTermination do
  it { should belong_to :contract }
  it { should belong_to :dissemination_source }

  it { should have_one(:annul).dependent(:destroy) }

  it { should validate_presence_of :year }
  it { should validate_presence_of :contract }
  it { should validate_presence_of :reason }
  it { should validate_presence_of :expiry_date }
  it { should validate_presence_of :termination_date }
  it { should validate_presence_of :publication_date }
  it { should validate_presence_of :dissemination_source }

  it { should validate_uniqueness_of :contract_id }

  it { should_not allow_value('12').for(:year) }
  it { should allow_value('1234').for(:year) }

  it 'should contact the number an the year to generate the to_s' do
    subject.stub(:number).and_return 1
    subject.stub(:year).and_return 2012

    expect(subject.to_s).to eq '1/2012'
  end

  describe '#next_number' do
    before do
      described_class.stub(:last_number).and_return 1
      subject.stub(:year).and_return 2012
    end

    it 'returns the last number + 1' do
      expect(subject.next_number).to eq 2
    end
  end

  describe 'generate the number' do
    before do
      described_class.stub(:last_number).and_return 1
    end

    it 'assigns the next_number' do
      subject.run_callbacks(:create)

      expect(subject.number).to eq 2
    end
  end

  context 'with annul' do
    let :annul do
      double(:annul)
    end

    it "should be annulled when it has an annul" do
      subject.stub(:annul => annul)

      expect(subject).to be_annulled
    end
  end

  it "should not be annulled when it does not have an annul" do
    expect(subject).not_to be_annulled
  end

  describe '#status' do
    it "should be 'active' when not annulled" do
      subject.stub(:annulled?).and_return(false)

      expect(subject.status).to eq Status::ACTIVE
    end

    it "should be 'inactive' when annulled" do
      subject.stub(:annulled?).and_return(true)

      expect(subject.status).to eq Status::INACTIVE
    end
  end
end
