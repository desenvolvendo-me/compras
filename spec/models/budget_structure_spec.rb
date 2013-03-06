# encoding: utf-8
require 'model_helper'
require 'app/models/budget_structure'
require 'app/models/inscriptio_cursualis/address'
require 'app/models/address'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation_budget_allocation_item'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/purchase_solicitation'
require 'app/models/budget_structure_responsible'
require 'lib/signable'
require 'app/models/direct_purchase'
require 'app/models/employee'

describe BudgetStructure do
  it 'should respond to to_s with budget_structure - description' do
    subject.stub(:budget_structure).and_return('99/00')
    subject.description = 'Secretaria de Educação'
    expect(subject.to_s).to eq '99/00 - Secretaria de Educação'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :code }
  it { should validate_presence_of :tce_code }
  it { should validate_presence_of :acronym }
  it { should validate_presence_of :performance_field }
  it { should validate_presence_of :budget_structure_configuration }
  it { should validate_presence_of :administration_type }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :budget_structure_level }
  it { should_not validate_presence_of :parent }

  it { should have_one :address }
  it { should have_many(:budget_allocations).dependent(:restrict) }
  it { should have_many(:budget_structure_responsibles).dependent(:destroy).order(:id) }
  it { should have_many(:purchase_solicitations).dependent(:restrict) }
  it { should belong_to :budget_structure_configuration }
  it { should belong_to :administration_type }
  it { should belong_to :budget_structure_level }
  it { should belong_to :parent }
  it { should have_many(:direct_purchases).dependent(:restrict) }
  it { should have_many(:children).dependent(:restrict) }

  context 'when level is greater than 1' do
    before do
      subject.stub(:level_greater_than_1?).and_return(true)
    end

    it { should validate_presence_of :parent }
  end

  context "when has a parent" do
    let :upper_budget_structure_level do
      double(:upper_budget_structure_level, :id => 1)
    end

    let :parent do
      double(:parent, :level => 1)
    end

    it 'should return 1 as budget_structure_level' do
      subject.stub(:parent).and_return( parent )
      subject.stub(:upper_budget_structure_level).and_return( upper_budget_structure_level )
      expect(subject.parent_budget_structure_level_id).to be 1
    end
  end

  context 'validate code mask' do
    before do
      subject.stub(:budget_structure_level).and_return(budget_structure_level)
    end

    let :budget_structure_level do
      double('BudgetStructureLevel', :level => 1, :mask => '999')
    end

    it { should allow_value('123').for(:code) }
    it { should_not allow_value('1a3').for(:code) }
    it { should_not allow_value('12').for(:code) }
  end

  context "when has not a parent" do
    it 'should return nil as upper_budget_structure_level' do
      subject.stub(:parent).and_return( nil )
      expect(subject.upper_budget_structure_level).to be nil
    end
  end

  context 'when has a parent with level 1' do
    let :parent do
      double(:parent, :level => 1)
    end

    it 'validating that parent is an immediate superior when level is 3' do
      subject.stub(:level).and_return(3)
      subject.stub(:parent).and_return(parent)

      subject.valid?

      expect(subject.errors.messages[:parent]).to include 'deve ser uma estrutura com nível superior imediato (nível 2)'
    end

    it 'validating that parent is an immediate superior when level is 2' do
      subject.stub(:level).and_return(2)
      subject.stub(:parent).and_return(parent)

      subject.valid?

      expect(subject.errors.messages[:parent]).to be nil
    end

    it 'should not validate if level is nil' do
      subject.stub(:level).and_return(nil)
      subject.stub(:parent).and_return(parent)

      subject.valid?

      expect(subject.errors.messages[:parent]).to be nil
    end
  end

  describe 'to_s' do
    context 'when has not parent' do
      before do
        subject.stub(:parent).and_return( nil )
        subject.stub(:separator).and_return('')
      end

      it 'should to_s be code + separator - description' do
        subject.code = 123
        subject.description = 'prefeitura'

        expect(subject.to_s).to eq '123 - prefeitura'
      end
    end

    context 'when has a parent' do
      let :parent do
        double(:parent,
               :code => 1,
               :separator => '-',
               :parent => nil
              )
      end

      it 'should to_s be parent_cod + parent_separator + code + separator - description' do
        subject.stub(:parent).and_return( parent )
        subject.stub(:separator).and_return('')
        subject.code = 123
        subject.description = 'prefeitura'

        expect(subject.to_s).to eq '1-123 - prefeitura'
      end
    end

    context 'when has a parent that has a parent' do
      let :parent_of_parent do
        double(:parent,
               :code => 1,
               :separator => '-',
               :parent => nil
              )
      end

      let :parent do
        double(:parent,
               :code => 12,
               :separator => '/',
               :parent => parent_of_parent
              )
      end

      it 'should to_s be parent_of_parent_cod + parent_of_parent_separator + parent_cod + parent_separator + code + separator - description' do
        subject.stub(:parent).and_return( parent )
        subject.stub(:separator).and_return('')
        subject.code = 123
        subject.description = 'prefeitura'

        expect(subject.to_s).to eq '1-12/123 - prefeitura'
      end
    end
  end

  context 'when getting persisted responsibles' do
    before do
      subject.stub(:budget_structure_responsibles).and_return(
        [persisted_responsible, new_responsible]
      )
    end

    let :persisted_responsible do
      double(:persisted? => true)
    end

    let :new_responsible do
      double(:persisted? => false)
    end

    it 'should return only persisted' do
      expect(subject.persisted_budget_structure_responsibles).to eq [persisted_responsible]
    end
  end

  context 'when check responsible changes' do
    context 'and have new responsible' do
      before do
        subject.stub(:budget_structure_responsibles).and_return(
          [persisted_responsible, new_responsible]
        )
      end

      let :persisted_responsible do
        double(:persisted? => true)
      end

      let :new_responsible do
        double(:persisted? => false)
      end

      it 'should return true if has a responsible as new_record?' do
        expect(subject).to be_budget_structure_responsibles_changed
      end
    end

    context 'and do not have new responsible' do
      before do
        subject.stub(:budget_structure_responsibles).and_return(
          [persisted_responsible]
        )
      end

      let :persisted_responsible do
        double(:persisted? => true)
      end

      it 'should return false if do not have a responsible as new_record?' do
        expect(subject).to_not be_budget_structure_responsibles_changed
      end
    end
  end

  context '#persisted_budget_structure_responsibles_without_end_date' do
    before do
      subject.stub(:budget_structure_responsibles).and_return(responsibles)
    end

    let :responsibles do
      [
        responsible_persisted_with_end_date,
        responsible_persisted_without_end_date,
        responsible_not_persisted,
      ]
    end

    let :responsible_persisted_with_end_date do
      double('ResponsiblePersistedWithEndDate', :persisted? => true, :end_date => Date.today)
    end

    let :responsible_persisted_without_end_date do
      double('ResponsiblePersistedWithoutEndDate', :persisted? => true, :end_date => nil)
    end

    let :responsible_not_persisted do
      double('ResponsibleNotPersisted', :persisted? => false)
    end

    it 'should return only persisted without date' do
      expect(subject.persisted_budget_structure_responsibles_without_end_date).to eq [
        responsible_persisted_without_end_date
      ]
    end
  end
end
