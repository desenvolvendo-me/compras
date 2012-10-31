# encoding: utf-8
require 'model_helper'
require 'app/models/capability_destination'

describe CapabilityDestination do
  it 'should return description as to_s' do
    subject.description = 'Programa de Linha de Crédito'
    expect(subject.to_s).to eq 'Programa de Linha de Crédito'
  end
end
