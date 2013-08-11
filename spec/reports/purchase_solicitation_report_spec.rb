require 'report_helper'
require 'app/enumerations/purchase_solicitation_kind'
require 'app/enumerations/purchase_solicitation_service_status'
require 'app/reports/purchase_solicitation_report'

describe PurchaseSolicitationReport do
  let(:repository) { double(:repository) }

  subject do
    described_class.new(repository)
  end

  describe '#item' do
    it 'should return the Material from an material_id' do
      record = double(:record, material_id: 5)
      material_repository = double(:material_repository)

      material_repository.should_receive(:find).with(5).and_return('Material')

      expect(subject.item(record, material_repository)).to eq 'Material'
    end
  end
end
