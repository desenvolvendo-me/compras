# encoding: utf-8
require 'model_helper'
require 'app/models/extra_credit_nature'
require 'app/models/extra_credit'

describe ExtraCreditNature do
  it 'should return description as to_s' do
    subject.description = 'Abre crédito'
    subject.to_s.should eq 'Abre crédito'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :kind }

  it { should have_many(:extra_credits).dependent(:restrict) }
end
