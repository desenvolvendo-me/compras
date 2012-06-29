# encoding: utf-8
require 'model_helper'
require 'app/models/budget_structure_responsible'

describe BudgetStructureResponsible do
  it { should validate_presence_of :responsible }
  it { should validate_presence_of :regulatory_act }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :status }

  it { should belong_to :budget_structure }
  it { should belong_to :responsible }
  it { should belong_to :regulatory_act }

  context 'validating date' do
    it 'be invalid when the start_date is after of end_date' do
      subject.start_date = Date.new(2012, 2, 10)
      subject.end_date = Date.new(2012, 2, 1)

      subject.should be_invalid
      subject.errors[:end_date].should eq ['deve ser depois da data de início (10/02/2012)']
    end

    it 'be invalid when the start_date is equal to end_date' do
      subject.start_date = Date.new(2012, 2, 10)
      subject.end_date = subject.start_date

      subject.should be_invalid
      subject.errors[:end_date].should eq ['deve ser depois da data de início (10/02/2012)']
    end

    it 'be valid when the end_date is after of start_date' do
      subject.start_date = Date.yesterday
      subject.end_date = Date.current

      subject.valid?

      subject.errors[:end_date].should be_empty
      subject.errors[:start_date].should be_empty
    end
  end
end
