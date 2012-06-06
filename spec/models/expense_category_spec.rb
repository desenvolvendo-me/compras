require 'model_helper'
require 'app/models/expense_category'
require 'app/models/expense_nature'

describe ExpenseCategory do
  it 'should return code as to_s' do
    subject.code = 1
    subject.description = 'DESPESA CORRENTE'
    subject.to_s.should eq '1 - DESPESA CORRENTE'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }

  it { should have_many(:expense_natures).dependent(:restrict) }
end
