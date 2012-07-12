require 'model_helper'
require 'app/models/pledge_liquidation_parcel'

describe PledgeLiquidationParcel do
  it { should belong_to :pledge_liquidation }

  it { should validate_presence_of :value }
end
