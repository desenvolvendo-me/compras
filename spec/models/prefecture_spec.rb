require 'model_helper'
require 'app/models/setting'
require 'app/models/extended_prefecture'

describe Prefecture do
  it { should have_one(:setting).dependent(:destroy) }
  it { should have_one(:extended_prefecture).dependent(:destroy) }

  it { should delegate(:allow_insert_past_processes).to(:setting).allowing_nil(true) }
  it { should delegate(:state).to(:address).allowing_nil(true) }
  it { should delegate(:city).to(:address).allowing_nil(true) }
  it { should delegate(:id).to(:state).allowing_nil(true).prefix(true) }
  it { should delegate(:tce_mg_code).to(:city).allowing_nil(true) }
  it { should delegate(:organ_code).to(:extended_prefecture).allowing_nil(true) }
  it { should delegate(:organ_kind).to(:extended_prefecture).allowing_nil(true) }
  it { should delegate(:control_fractionation).to(:extended_prefecture).allowing_nil(true) }
end
