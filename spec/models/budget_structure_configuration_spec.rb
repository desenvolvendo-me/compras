# encoding: utf-8
require 'model_helper'
require 'app/models/budget_structure_configuration'
require 'app/models/budget_structure_level'
require 'app/models/budget_structure'

describe BudgetStructureConfiguration do
  it 'should respond to to_s as description' do
    subject.description = 'Organograma 2012'
    expect(subject.to_s).to eq 'Organograma 2012'
  end

  it { should have_many(:budget_structures).dependent(:restrict) }
  it { should have_many(:budget_structure_levels).dependent(:destroy).order(:id) }

  it { should validate_presence_of :description }
  it { should validate_presence_of :regulatory_act }
  it { should validate_presence_of :entity }

  context 'get mask' do
    let :level1 do
      BudgetStructureLevel.new :level => 1, :digits => 1, :separator => BudgetStructureSeparator::HYPHEN
    end

    let :level2 do
      BudgetStructureLevel.new :level => 2, :digits => 2
    end

    subject do
      described_class.new :budget_structure_levels => [level2, level1]
    end

    it 'should return correct mask' do
      expect(subject.mask).to eq '9-99'
    end

    it 'should validate presence of level only on last mask' do
      level1.separator = nil
      expect(subject).not_to be_valid
      expect(subject.ordered_budget_structure_levels.first.errors[:separator]).to include 'não pode ficar em branco'
      expect(subject.ordered_budget_structure_levels.last.errors[:separator]).to_not include 'não pode ficar em branco'
    end

    it 'should return incorrect mask when digits is missing' do
      level1.digits = nil
      expect(subject.mask).to eq '99'
    end
  end
end
