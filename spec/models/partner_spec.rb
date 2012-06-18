# encoding: utf-8
require 'model_helper'
require 'app/models/partner'
require 'app/models/person'
require 'app/models/company'

describe Partner do
  it 'return name when converted to string' do
    subject.build_person
    subject.person.name = 'João da Silva'
    subject.person.name.should eq subject.to_s
  end

  it { should belong_to :person }
  it { should belong_to :company }

  it { should validate_presence_of :person }
  it { should validate_presence_of :percentage }
  it { should validate_numericality_of :percentage }
  it { should allow_value(100).for(:percentage) }
  it { should allow_value(0.01).for(:percentage) }
  it { should_not allow_value(100.01).for(:percentage) }
end
