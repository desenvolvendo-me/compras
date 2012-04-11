require 'model_helper'
require 'app/models/expense_element'
require 'app/models/expense_nature'

describe ExpenseElement do
  it 'should return code as to_s' do
    subject.code = 1
    subject.to_s.should eq '1'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }

  it { should have_many(:expense_natures).dependent(:restrict) }
end
