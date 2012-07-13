require 'unit_helper'
require 'app/business/object_annulment'

describe ObjectAnnulment do
  let :object do
    double('ObjectAnnulable')
  end

  subject { described_class.new(object) }

  describe '#annul!' do
    it 'returns false when annul object is already present' do
      object.stub_chain(:annul, :present?).and_return true

      subject.annul!.should be_false
    end

    it 'delegates the annulation to the object' do
      object.stub_chain(:annul, :present?).and_return false
      object.should_receive(:annul!)

      subject.annul!
    end
  end
end
