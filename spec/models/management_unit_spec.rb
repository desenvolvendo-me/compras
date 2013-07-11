require 'model_helper'
require 'app/models/management_unit'
require 'app/models/pledge'
require 'app/models/descriptor'

describe ManagementUnit do
  it "should return the description as to_s method" do
    subject.description = "Central Unit"

    expect(subject.to_s).to eq "Central Unit"
  end

  it { should validate_presence_of(:descriptor_id) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:acronym) }
  it { should validate_presence_of(:status) }

  describe '#descriptor' do
    before do
      subject.descriptor_id = 1
    end

    let(:descriptor) { Descriptor.new }

    it 'returns an instance from Descriptor' do
      Descriptor.should_receive(:find).with(1).and_return(descriptor)

      expect(subject.descriptor).to be_an_instance_of Descriptor
    end
  end
end
