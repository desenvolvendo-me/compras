# encoding: utf-8
require 'model_helper'
require 'app/models/state'
require 'app/models/city'

describe State do
  it { should belong_to :country }
  it { should have_many :cities }

  it { should validate_presence_of :name }
  it { should validate_presence_of :acronym }
  it { should validate_presence_of :country }

  it 'return name when converted to string' do
    subject.name = 'Minas Gerais'
    subject.name.should eq subject.to_s
  end
end
