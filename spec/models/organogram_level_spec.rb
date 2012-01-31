# encoding: utf-8
require 'model_helper'
require 'app/models/organogram_level'

describe OrganogramLevel do
  it 'should respond to to_s with level and name' do
    subject.level = 1
    subject.name = 'Orgão'
    subject.to_s.should eq '1 - Orgão'
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :level }
  it { should validate_presence_of :digits }
end
