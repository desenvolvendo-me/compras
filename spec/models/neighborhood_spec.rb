# encoding: utf-8
require 'model_helper'
require 'app/models/unico/neighborhood'
require 'app/models/neighborhood'
require 'app/models/address'

describe Neighborhood do
  it { should have_many(:addresses).dependent(:restrict) }
end
