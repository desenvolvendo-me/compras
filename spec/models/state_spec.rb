# encoding: utf-8
require 'model_helper'
require 'app/models/state'

describe State do
  it { should have_many(:account_plan_configurations).dependent(:restrict) }
end
