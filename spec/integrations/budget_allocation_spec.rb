# encoding: UTF-8
require 'spec_helper'

describe BudgetAllocation do
  context 'uniqueness validations' do
    before { BudgetAllocation.make!(:alocacao) }

    it { should validate_uniqueness_of(:description) }
    it { should validate_uniqueness_of(:code).scoped_to(:descriptor_id) }
  end

  describe '.budget_structure_id' do
    let(:allocation1) { BudgetAllocation.make!(:alocacao) }
    let(:structure1)  { allocation1.budget_structure }
    let(:allocation2) { BudgetAllocation.make!(:reparo_2011) }
    let(:structure2)  { allocation2.budget_structure }

    it 'should filter by budget_allocation_id' do
      expect(described_class.budget_structure_id(structure1.id)).to eq [allocation1]
      expect(described_class.budget_structure_id(structure2.id)).to eq [allocation2]
    end
  end
end
