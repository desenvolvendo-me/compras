require 'unit_helper'
require 'app/business/budget_structure_responsible_end_date_generator'

describe BudgetStructureResponsibleEndDateGenerator do
  before do
    Date.stub(:current).and_return(current_date)
  end

  let :current_date do
    Date.new(2012, 8, 8)
  end

  context 'when have one not persisted responsible' do
    let :budget do
      double('Budget', :budget_structure_responsibles => [responsible])
    end

    let :responsible do
      double('Responsible', :persisted? => false, :end_date => nil)
    end

    it 'should set end_date' do
      responsible.should_not_receive(:end_date=)

      described_class.new(budget).change!
    end
  end

  context 'when have one persisted responsible and one not persisted' do
    let :budget do
      double('Budget', :budget_structure_responsibles => responsibles)
    end

    let :responsibles do
      [ responsible_one, responsible_two ]
    end

    let :responsible_one do
      double('ResponsibleOne', :persisted? => true, :end_date => nil)
    end

    let :responsible_two do
      double('ResponsibleTwo', :persisted? => false, :end_date => nil)
    end

    it 'should set end_date' do
      responsible_one.should_receive(:end_date=).with(current_date).and_return(true)

      described_class.new(budget).change!
    end
  end

  context 'when have two persisted responsibles and one not persisted' do
    let :budget do
      double('Budget', :budget_structure_responsibles => responsibles)
    end

    let :responsibles do
      [ responsible_one, responsible_two, responsible_three ]
    end

    let :responsible_one do
      double('ResponsibleOne', :persisted? => true, :end_date => Date.new(2012, 1, 1))
    end

    let :responsible_two do
      double('ResponsibleTwo', :persisted? => true, :end_date => nil)
    end

    let :responsible_three do
      double('ResponsibleThree', :persisted? => false, :end_date => nil)
    end

    it 'should set end_date' do
      responsible_two.should_receive(:end_date=).with(current_date).and_return(true)

      described_class.new(budget).change!
    end
  end
end
