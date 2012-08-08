require 'model_helper'
require 'app/models/expense_group'
require 'app/models/expense_nature'

describe ExpenseGroup do
  it 'should return code as to_s' do
    subject.code = 1
    subject.description = 'RESTOS A PAGAR'
    expect(subject.to_s).to eq '1 - RESTOS A PAGAR'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }

  it { should have_many(:expense_natures).dependent(:restrict) }
end
