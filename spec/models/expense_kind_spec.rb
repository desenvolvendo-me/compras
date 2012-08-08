# encoding: utf-8
require 'model_helper'
require 'app/models/expense_kind'
require 'app/models/pledge'

describe ExpenseKind do
  it 'should return description as to_s method' do
    subject.description = 'Pagamentos'

    expect(subject.to_s).to eq 'Pagamentos'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :status }
  it { should have_many(:pledges).dependent(:restrict) }
end
