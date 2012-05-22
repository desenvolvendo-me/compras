require 'model_helper'
require 'app/models/subpledge_expiration_movimentation'

describe SubpledgeExpirationMovimentation do
  it { should belong_to :subpledge_expiration }
  it { should belong_to :subpledge_expiration_modificator }

  it { should validate_presence_of :subpledge_expiration }
  it { should validate_presence_of :subpledge_expiration_modificator }
  it { should validate_presence_of :subpledge_expiration_value_was }
  it { should validate_presence_of :subpledge_expiration_value }
  it { should validate_presence_of :value }
end
