require 'exporter_helper'
require 'app/exporters/tce_export/mg/formatters/expense_classification_formatter'

describe TceExport::MG::Formatters::ExpenseClassificationFormatter do

  let(:budget_allocation) { double('BudgetAllocation') }
  let(:expense_nature) { double('ExpenseNature', :expense_nature => "3.0.00.00.00") }

  it "returns the formatted code" do
    budget_allocation.stub(:budget_structure_structure_sequence => [
      double('Organ', :code => '02'),
      double('Unit', :code => '03'),
      double('SubUnit', :code => '04')
    ])

    budget_allocation.stub(:function_code => 1)
    budget_allocation.stub(:subfunction_code => 2)
    budget_allocation.stub(:government_program_code => "0123")
    budget_allocation.stub(:government_action_action_type => 9)
    budget_allocation.stub(:government_action_code => "0456")

    expect(described_class.new("01", budget_allocation, expense_nature).to_s).to eq "01003010020123945630000000"
  end

  it "raises an error if unit is missing on budget structure sequence" do
    budget_allocation.stub(:budget_structure_structure_sequence => [
      double('Organ', :code => '02')
    ])

    expect {
      described_class.new("01", budget_allocation, expense_nature).to_s
    }.to raise_error(TceExport::MG::Exceptions::InvalidData, "Código da estrutura orçamentária inválido")
  end

  it "raises an error if budget structure sequence is empty" do
    budget_allocation.stub(:budget_structure_structure_sequence => [])

    expect {
      described_class.new("01", budget_allocation, expense_nature).to_s
    }.to raise_error(TceExport::MG::Exceptions::InvalidData, "Código da estrutura orçamentária inválido")
  end
end
