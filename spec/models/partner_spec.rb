require 'model_helper'
require 'app/models/persona/partner'
require 'app/models/extended_partner'
require 'app/models/partner'

describe Partner do
  it { should delegate(:cpf).to(:person).allowing_nil(true) }
end
