require 'model_helper'
require 'app/models/pledge_parcel_movimentation'

describe PledgeParcelMovimentation do
  it { should belong_to :pledge_parcel }
  it { should belong_to :pledge_parcel_modificator }

  it { should validate_presence_of :pledge_parcel }
  it { should validate_presence_of :pledge_parcel_modificator }
  it { should validate_presence_of :pledge_parcel_value_was }
  it { should validate_presence_of :pledge_parcel_value }
  it { should validate_presence_of :value }
end
