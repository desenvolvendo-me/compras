# encoding: utf-8
require 'model_helper'
require 'app/models/administration_type'
require 'app/models/budget_unit'

describe AdministrationType do
  it 'should return code and description as to_s method' do
    subject.description = 'Privada'

    subject.to_s.should eq 'Privada'
  end

  it {should belong_to :legal_nature }
  it { should have_many(:budget_units).dependent(:restrict) }

  it {should validate_presence_of :description }
  it {should validate_presence_of :administration }
  it {should validate_presence_of :organ_type }
  it {should validate_presence_of :legal_nature }
end
