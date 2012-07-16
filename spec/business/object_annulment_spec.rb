require 'unit_helper'
require 'app/business/object_annulment'

describe ObjectAnnulment do
  let :object do
    double('ObjectAnnulable')
  end

  describe '#annul!' do
    it 'returns false when annul object is already present' do
      object.stub_chain(:annul, :present?).and_return true

      subject.class.annul!(object).should be_false
    end

    it 'delegates the annulation to the object' do
      object.stub_chain(:annul, :present?).and_return false
      object.should_receive(:annul!)

      subject.class.annul!(object)
    end
  end
end
