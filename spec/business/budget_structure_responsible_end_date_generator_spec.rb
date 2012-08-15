require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/budget_structure_responsible_end_date_generator'

describe BudgetStructureResponsibleEndDateGenerator do
  before do
    Date.stub(:current).and_return(current_date)
  end

  let :current_date do
    Date.new(2012, 8, 8)
  end

  context 'when have one persisted responsible' do
    let :budget do
      double('Budget', :budget_structure_responsibles_changed? => true,
             :persisted_budget_structure_responsibles => [responsible_one])
    end

    let :responsible_one do
      double('ResponsibleOne', :persisted? => true, :end_date => nil)
    end

    it 'should set end_date' do
      responsible_one.should_receive(:end_date=).with(current_date).and_return(true)

      described_class.new(budget).change!
    end
  end

  context 'when have two persisted responsibles' do
    let :budget do
      double('Budget', :budget_structure_responsibles_changed? => true,
             :persisted_budget_structure_responsibles => responsibles)
    end

    let :responsibles do
      [ responsible_one, responsible_two ]
    end

    let :responsible_one do
      double('ResponsibleOne', :persisted? => true, :end_date => Date.new(2012, 1, 1))
    end

    let :responsible_two do
      double('ResponsibleTwo', :persisted? => true, :end_date => nil)
    end

    it 'should set end_date only to last' do
      responsible_two.should_receive(:end_date=).with(current_date).and_return(true)

      described_class.new(budget).change!
    end
  end
end
