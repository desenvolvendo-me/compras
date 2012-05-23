# encoding: utf-8
require 'model_helper'
require 'app/models/unico/city'
require 'app/models/city'
require 'app/models/agency'

describe City do
  it { should have_many(:agencies).dependent(:restrict) }
end
