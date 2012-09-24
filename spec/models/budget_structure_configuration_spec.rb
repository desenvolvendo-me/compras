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

    context 'when generate' do
      let :mask_generator do
        double('Generator', :from_levels => '9/99')
      end

      it 'should return correct mask using MaskGenerator' do
        expect(subject.mask(mask_generator)).to eq '9/99'
      end
    end

    it 'should validate presence of level only on last mask' do
      level1.separator = nil
      expect(subject).not_to be_valid
      expect(subject.ordered_budget_structure_levels.first.errors[:separator]).to include 'não pode ficar em branco'
      expect(subject.ordered_budget_structure_levels.last.errors[:separator]).to_not include 'não pode ficar em branco'
    end
  end

  describe '#ordered_budget_structure_levels' do
    let :level_1 do
      double(:level_1, :new_record? => false, :level => 1)
    end

    let :level_2 do
      double(:level_2, :new_record? => true, :level => 2)
    end

    let :level_3 do
        double(:level_3, :new_record? => false, :level => 3)
    end

    let :level_4 do
        double(:level_4, :new_record? => false, :level => 4)
    end

    it "should return the same order if have any level not persisted" do
      subject.stub(:budget_structure_levels).and_return([level_3, level_4, level_2, level_1])

      expect(subject.ordered_budget_structure_levels).to eq [level_3, level_4, level_2, level_1]
    end

    it "should return ordered if have not any level not persisted" do
      subject.stub(:budget_structure_levels).and_return([level_3, level_4, level_1])

      expect(subject.ordered_budget_structure_levels).to eq [level_1, level_3, level_4]
    end
  end
end
