require 'spec_helper'

describe MaterialClass do
  context 'uniqueness validations' do
    before { ::FactoryGirl::Preload.factories['MaterialClass'][:software] }

    it { should validate_uniqueness_of(:class_number) }
  end

  describe '.term' do
    before do
      software
      arames
      comp_eletricos
    end

    let(:software)        { ::FactoryGirl::Preload.factories['MaterialClass'][:software]  }
    let(:arames)          { ::FactoryGirl::Preload.factories['MaterialClass'][:arames]  }
    let(:comp_eletricos)  { ::FactoryGirl::Preload.factories['MaterialClass'][:comp_eletricos]  }

    it 'return without using mask on class_number' do
      expect(MaterialClass.term('013')).to eq [software]
    end

    it 'return using mask on class_number' do
      expect(MaterialClass.term('0.13')).to eq [software]
    end

    it 'return using description' do
      expect(MaterialClass.term('Softw')).to eq [software]
    end

    it 'not return using wrong description' do
      expect(MaterialClass.term('Doftw')).to_not include(software)
    end
  end

  describe '#parent' do
    subject do
      ::FactoryGirl::Preload.factories['MaterialClass'][:software]
    end

    it 'should return the parent based on masked_number hierarchy' do
      parent = FactoryGirl.create(:material_class, :masked_number => '01.00.00.000.000', :class_number => '01.00.00.000.000')
      expect(subject.parent).to eq parent
    end

    it 'should return nil when has no parent' do
      expect(subject.parent).to be_nil
    end
  end

  describe '#children' do
    subject do
      ::FactoryGirl::Preload.factories['MaterialClass'][:software]
    end

    it 'should return all children based on masked_number' do
      child1 = FactoryGirl.create(:material_class,
                                  :masked_number => "01.32.15.000.000", :class_number => "013215000000", :description => 'Antivirus')

      child2 = FactoryGirl.create(:material_class,
                                  :masked_number => "01.32.16.000.000", :class_number => "013216000000", :description => 'Sistemas Operacionais')

      not_child = ::FactoryGirl::Preload.factories['MaterialClass'][:arames]

      expect(subject.children).to include(child1, child2)
      expect(subject.children).to_not include(not_child)
    end
  end

  describe 'update has_children on save' do
    subject do
      ::FactoryGirl::Preload.factories['MaterialClass'][:software]
    end

    it 'should change the parent has_children when save or remove children' do
      expect(subject.has_children).to be_false

      child = FactoryGirl.create(:material_class,
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
      child = FactoryGirl.create(:material_class,
                                 :masked_number => "01.32.15.000.000", :description => 'Antivirus', :has_children => false)

      expect(described_class.without_children).to eq [child]
    end
  end
end
