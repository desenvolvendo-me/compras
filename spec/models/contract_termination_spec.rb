require 'model_helper'
# require 'app/models/contract'
require 'app/models/contract_termination'
# require 'lib/annullable'
# require 'app/models/resource_annul'

describe ContractTermination do
  xit { should belong_to :contract }
  xit { should belong_to :dissemination_source }

  xit { should have_one(:annul).dependent(:destroy) }

  xit { should validate_presence_of :year }
  xit { should validate_presence_of :contract }
  xit { should validate_presence_of :reason }
  xit { should validate_presence_of :expiry_date }
  xit { should validate_presence_of :termination_date }
  xit { should validate_presence_of :publication_date }
  xit { should validate_presence_of :dissemination_source }

  xit { should_not allow_value('12').for(:year) }
  it { should allow_value('1234').for(:year) }

  xit 'should contact the number an the year to generate the to_s' do
    subject.stub(:number).and_return 1
    subject.stub(:year).and_return 2012

    expect(subject.to_s).to eq '1/2012'
  end

  describe '#next_number' do
    before do
      described_class.stub(:last_number).and_return 1
      subject.stub(:year).and_return 2012
    end

    xit 'returns the last number + 1' do
      expect(subject.next_number).to eq 2
    end
  end

  describe 'generate the number' do
    before do
      described_class.stub(:last_number).and_return 1
    end

    xit 'assigns the next_number' do
      subject.run_callbacks(:create)

      expect(subject.number).to eq 2
    end
  end

  context 'with annul' do
    let :annul do
      double(:annul)
    end

    xit "should be annulled when it has an annul" do
      subject.stub(:annul => annul)

      expect(subject).to be_annulled
    end
  end

  xit "should not be annulled when it does not have an annul" do
    expect(subject).not_to be_annulled
  end

  describe '#status' do
    xit "should be 'active' when not annulled" do
      subject.stub(:annulled?).and_return(false)

      expect(subject.status).to eq Status::ACTIVE
    end

    xit "should be 'inactive' when annulled" do
      subject.stub(:annulled?).and_return(true)

      expect(subject.status).to eq Status::INACTIVE
    end
  end
end
