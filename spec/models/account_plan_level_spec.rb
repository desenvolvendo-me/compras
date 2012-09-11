# encoding: utf-8
require 'model_helper'
require 'app/models/account_plan_level'

describe AccountPlanLevel do
  it { should belong_to :account_plan_configuration }

  it { should validate_presence_of :description }
  it { should validate_presence_of :level }
  it { should validate_presence_of :digits }
end
