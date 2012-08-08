# encoding: utf-8
require 'model_helper'
require 'app/models/expense_modality'
require 'app/models/expense_nature'

describe ExpenseModality do
  it 'should return code as to_s' do
    subject.code = 1
    subject.description = 'TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
    expect(subject.to_s).to eq '1 - TRANSFERÊNCIAS INTRAGOVERNAMENTAIS'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }

  it { should have_many(:expense_natures).dependent(:restrict) }
end
