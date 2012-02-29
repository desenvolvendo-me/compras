# encoding: utf-8
require 'model_helper'
require 'app/models/provider_partner'
require 'app/models/provider'
require 'app/models/person'

describe ProviderPartner do
  it { should belong_to :provider }
  it { should belong_to :individual }
end
