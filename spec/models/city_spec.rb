# encoding: utf-8
require 'model_helper'
require 'app/models/city'
require 'app/models/district'
require 'app/models/agency'
require 'app/models/neighborhood'
require 'app/models/prefecture'

describe City do
  it 'return name when converted to string' do
    subject.name = 'Apucarana'
    subject.name.should eq subject.to_s
  end

  it { should belong_to :state }
  it { should have_many :agencies }
  it { should have_many :neighborhoods }
  it { should have_many :districts }

  it { should validate_presence_of :name }
  it { should validate_presence_of :state }

end
