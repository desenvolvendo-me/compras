# encoding: utf-8
require 'model_helper'
require 'app/models/administration_type'

describe AdministrationType do
  it 'should return code and name as to_s method' do
    subject.name = 'Privada'

    subject.to_s.should eq 'Privada'
  end

  it {should belong_to :legal_nature }
  it {should validate_presence_of :name }
  it {should validate_presence_of :administration }
  it {should validate_presence_of :organ_type }
  it {should validate_presence_of :legal_nature_id }
end
