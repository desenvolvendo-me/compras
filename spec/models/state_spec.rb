# encoding: utf-8
require 'model_helper'
require 'app/models/unico/state'
require 'app/models/state'
require 'app/models/account_plan_configuration'

describe State do
  it { should have_many(:account_plan_configurations).dependent(:restrict) }
end
