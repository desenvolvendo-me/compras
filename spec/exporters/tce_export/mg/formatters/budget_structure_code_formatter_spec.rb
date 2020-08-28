require 'exporter_helper'
require 'app/exporters/tce_export/mg/formatters/budget_structure_code_formatter'

describe TceExport::MG::Formatters::BudgetStructureCodeFormatter do
  let(:budget_structure) { double('BudgetStructure', :to_s => '999') }

  it "returns the formatted code" do
    budget_structure.stub(:structure_sequence => [
      double('Organ', :code => '02'),
      double('Unit', :code => '03'),
      double('SubUnit', :code => '04')
    ])

    expect(described_class.new("01", budget_structure).to_s).to eq "01003004"
  end

  it "returns the formatted code if subunit is missing on budget structure sequence" do
    budget_structure.stub(:structure_sequence => [
      double('Organ', :code => '02'),
      double('Unit', :code => '03')
    ])

    expect(described_class.new("01", budget_structure).to_s).to eq "01003"
  end

  it "raises an error if unit is missing on budget structure sequence" do
    budget_structure.stub(:structure_sequence => [
      double('Organ', :code => '02')
    ])

    expect {
      described_class.new("01", budget_structure).to_s
    }.to raise_error(TceExport::MG::Exceptions::InvalidData, 'Estrutura orçamentária "999" inválida. Deve ter 2 (99.999) ou 3 níveis (99.999.999)')
  end

  it "returns the formatted code if budget structure sequence is empty" do
    budget_structure.stub(:structure_sequence => [])

    expect {
      described_class.new("01", budget_structure).to_s
    }.to raise_error(TceExport::MG::Exceptions::InvalidData, 'Estrutura orçamentária "999" inválida. Deve ter 2 (99.999) ou 3 níveis (99.999.999)')
  end

  context 'when budget_structure is nil' do
    it 'should return an empty string' do
      expect(described_class.new("01", nil).to_s).to eq ""
    end
  end
end
