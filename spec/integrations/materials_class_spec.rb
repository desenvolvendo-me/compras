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
end
