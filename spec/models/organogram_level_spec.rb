# encoding: utf-8
require 'model_helper'
require 'app/models/organogram_level'

describe OrganogramLevel do
  it 'should respond to to_s with level and description' do
    subject.level = 1
    subject.description = 'Orgão'
    subject.to_s.should eq '1 - Orgão'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :level }
  it { should validate_presence_of :digits }
end
