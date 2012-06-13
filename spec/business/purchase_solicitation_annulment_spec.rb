require 'unit_helper'
require 'app/business/purchase_solicitation_annulment'

describe PurchaseSolicitationAnnulment do
  let :solicitation do
    double('Solicitation')
  end

  subject { described_class.new(solicitation) }

  describe '#annul!' do
    it 'returns false when no annul object is present' do
      solicitation.stub_chain(:annul, :present?).and_return false

      subject.annul!.should be_false
    end

    it 'delegates the annulation to the solicitation' do
      solicitation.stub_chain(:annul, :present?).and_return true
      solicitation.should_receive(:annul!)

      subject.annul!
    end
  end
end
