# encoding: utf-8
require 'model_helper'
require 'app/models/budget_structure_level'

describe BudgetStructureLevel do
  it 'should respond to to_s with level and description' do
    subject.level = 1
    subject.description = 'Orgão'
    expect(subject.to_s).to eq '1 - Orgão'
  end

  it { should belong_to :budget_structure_configuration }

  it { should validate_presence_of :description }
  it { should validate_presence_of :level }
  it { should validate_presence_of :digits }
end
