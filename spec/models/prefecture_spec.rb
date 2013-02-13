require 'model_helper'
require 'app/models/setting'

describe Prefecture do
  it { should have_one(:setting).dependent(:destroy) }

  it { should delegate(:allow_insert_past_processes).to(:setting).allowing_nil(true) }
  it { should delegate(:state).to(:address).allowing_nil(true) }
  it { should delegate(:id).to(:state).allowing_nil(true).prefix(true) }
end
