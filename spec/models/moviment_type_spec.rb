# encoding: utf-8
require 'model_helper'
require 'app/models/moviment_type'
require 'app/models/additional_credit_opening_moviment_type'

describe MovimentType do
  it 'should return name as to_s' do
    subject.name = 'Adicionar dotação'
    subject.to_s.should eq 'Adicionar dotação'
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :operation }
  it { should validate_presence_of :character }

  it { should have_many(:additional_credit_opening_moviment_types).dependent(:restrict) }
end
