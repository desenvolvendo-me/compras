# encoding: utf-8
require 'model_helper'
require 'app/models/agreement_kind'

describe AgreementKind do
  it 'should return description as to_s' do
    subject.description = 'Auxílio'
    expect(subject.to_s).to eq 'Auxílio'
  end

  it { should validate_presence_of :description }
end
