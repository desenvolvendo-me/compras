# encoding: utf-8
require 'model_helper'
require 'app/models/additional_credit_opening_nature'

describe AdditionalCreditOpeningNature do
  it 'should return description as to_s' do
    subject.description = 'Abre crédito'
    subject.to_s.should eq 'Abre crédito'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :kind }
end
