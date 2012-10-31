# encoding: utf-8
require 'model_helper'
require 'app/models/moviment_type'

describe MovimentType do
  it 'should return name as to_s' do
    subject.name = 'Adicionar dotação'
    expect(subject.to_s).to eq 'Adicionar dotação'
  end
end
