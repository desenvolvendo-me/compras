require 'model_helper'
require 'app/models/precatory_parcel'

describe PrecatoryParcel do
  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :value }
  it { should validate_presence_of :situation }

  it { should belong_to :precatory }
end
