# encoding: UTF-8
require 'spec_helper'

describe MaterialsClass do
  context 'uniqueness validations' do
    before { MaterialsClass.make!(:software) }

    it { should validate_uniqueness_of(:class_number) }
  end

  describe '.term' do
    before do
      software
      arames
      comp_eletricos
    end

    let(:software) { MaterialsClass.make!(:software) }
    let(:arames) { MaterialsClass.make!(:arames) }
    let(:comp_eletricos) { MaterialsClass.make!(:comp_eletricos) }

    it 'return without using mask on class_number' do
      expect(MaterialsClass.term('013')).to eq [software]
    end

    it 'return using mask on class_number' do
      expect(MaterialsClass.term('0.13')).to eq [software]
    end

    it 'return using description' do
      expect(MaterialsClass.term('Softw')).to eq [software]
    end

    it 'not return using wrong description' do
      expect(MaterialsClass.term('Doftw')).to_not include(software)
    end
  end

  describe '#parent' do
    subject do
      MaterialsClass.make!(:software,
                           :masked_number => "01.32.15.000.000",
                           :description => 'Antivirus')
    end

    it 'should return the parent based on masked_number hierarchy' do
      parent = MaterialsClass.make!(:software)

      expect(subject.parent).to eq parent
    end

    it 'should return nil when has no parent' do
      expect(subject.parent).to be_nil
    end
  end

  describe '#children' do
    subject do
      MaterialsClass.make!(:software)
    end

    it 'should return all children based on masked_number' do
      child1 = MaterialsClass.make!(:software,
                :masked_number => "01.32.15.000.000", :description => 'Antivirus')

      child2 = MaterialsClass.make!(:software,
                :masked_number => "01.32.16.000.000", :description => 'Sistemas Operacionais')

      not_child = MaterialsClass.make!(:arames)

      expect(subject.children).to include(child1, child2)
      expect(subject.children).to_not include(not_child)
    end
  end

  describe 'update has_children on save' do
    subject do
      MaterialsClass.make!(:software)
    end

    it 'should change the parent has_children when save or remove children' do
      expect(subject.has_children).to be_false

      child = MaterialsClass.make!(:software,
        :masked_number => "01.32.15.000.000", :description => 'Antivirus')

      subject.reload # Need this, else is getting the cached subject.

      expect(subject.has_children).to be_true

      child.destroy

      subject.reload # Need this, else is getting the cached subject.

      expect(subject.has_children).to be_false
    end
  end

  describe '.without_children' do
    it 'should return only material classes without children' do
      parent = MaterialsClass.make!(:software)
      child = MaterialsClass.make!(:software,
        :masked_number => "01.32.15.000.000", :description => 'Antivirus')

      expect(described_class.without_children).to eq [child]
    end
  end
end
