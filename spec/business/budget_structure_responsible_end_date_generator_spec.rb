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

  context 'when is invalid' do
    let :budget do
      double('InvalidBudget', :valid? => false)
    end

    it 'should not set end_date' do
      described_class.new(budget).change!
    end
  end

  context 'when have persisted responsible without end_date' do
    let :budget do
      double('Budget', :budget_structure_responsibles_changed? => true,
             :valid? => true,
             :persisted_budget_structure_responsibles_without_end_date => [responsible])
    end

    let :responsible do
      double('Responsible', :persisted? => true, :end_date => Date.new(2012, 1, 1))
    end

    it 'should set end_date' do
      responsible.should_receive(:end_date=).with(current_date).and_return(true)

      described_class.new(budget).change!
    end
  end
end
