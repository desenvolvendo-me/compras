# encoding: utf-8
require 'model_helper'
require 'config/initializers/inflections'
require 'app/models/condominium'
require 'app/models/address'

describe Condominium do
  it "return name when converted to String" do
    subject.name = "Tambuatá"
    subject.name.should eq subject.to_s
  end

  it { should validate_presence_of :name }
end
