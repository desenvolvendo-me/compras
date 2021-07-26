require 'report_helper'
require 'enumerate_it'
require 'app/enumerations/purchase_solicitation_kind'
require 'app/enumerations/report_type'
require 'app/enumerations/purchase_solicitation_service_status'
require 'app/reports/purchase_solicitation_report'

describe PurchaseSolicitationReport do
  let(:repository) { double(:repository) }

  subject do
    described_class.new(repository)
  end

  it { should validate_presence_of :report_type }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }

  it 'allows render data as list' do
    expect(subject.render_list?).to be_true
  end

  describe '#item' do
    it 'should return the Material from an material_id' do
      record = double(:record, material_id: 5)
      material_repository = double(:material_repository)

      material_repository.should_receive(:find).with(5).and_return('Material')

      expect(subject.item(record, material_repository)).to eq 'Material'
    end
  end

  describe '#record_code_year' do
    it 'should return code and year to purchase solicitation' do
      purchase_solicitation = double(:purchase_solicitation, id: 3, code: '1', accounting_year: '2013')
      record = double(:record, purchase_solicitation_id: 3)
      purchase_solicitation_repository = double(:purchase_solicitation)

      purchase_solicitation_repository.should_receive(:find).with(3).and_return(purchase_solicitation)

      expect(subject.record_code_year(record, purchase_solicitation_repository)).to eq '1/2013'
    end
  end
end
