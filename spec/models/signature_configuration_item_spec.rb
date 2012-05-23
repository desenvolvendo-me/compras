require 'model_helper'
require 'app/models/signature_configuration_item'

describe SignatureConfigurationItem do
  it { should belong_to :signature }
  it { should belong_to :signature_configuration }

  it { should validate_presence_of :signature }
  it { should validate_presence_of :order }
end
