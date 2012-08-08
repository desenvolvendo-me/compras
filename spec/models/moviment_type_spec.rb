# encoding: utf-8
require 'model_helper'
require 'app/models/moviment_type'
require 'app/models/extra_credit_moviment_type'

describe MovimentType do
  it 'should return name as to_s' do
    subject.name = 'Adicionar dotação'
    expect(subject.to_s).to eq 'Adicionar dotação'
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :operation }
  it { should validate_presence_of :character }
  it { should validate_presence_of :source }

  it { should have_many(:extra_credit_moviment_types).dependent(:restrict) }
end
