# encoding: utf-8
require 'model_helper'
require 'app/models/budget_structure_responsible'

describe BudgetStructureResponsible do
  it { should validate_presence_of :responsible }
  it { should validate_presence_of :regulatory_act }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :status }

  it { should belong_to :budget_structure }
  it { should belong_to :responsible }
  it { should belong_to :regulatory_act }

  context 'validating date' do
    before(:each) do
      subject.stub(:start_date).and_return(Date.new(2012, 2, 10))
    end

    it 'be valid when the end_date is after of start_date' do
      expect(subject).to allow_value(Date.new(2012, 2, 11)).for(:end_date)
    end

    it 'be invalid when the start_date is after of end_date' do
      expect(subject).not_to allow_value(Date.new(2012, 2, 1)).for(:end_date).
                                                           with_message('deve ser depois da data de início (10/02/2012)')
    end

    it 'be invalid when the start_date is equal to end_date' do
      expect(subject).not_to allow_value(Date.new(2012, 2, 10)).for(:end_date).
                                                           with_message('deve ser depois da data de início (10/02/2012)')
    end
  end
end
