require 'model_helper'
require 'app/models/unico/street'
require 'app/models/street'
require 'app/models/unico/address'
require 'app/models/address'
require 'app/models/unico/neighborhood'

describe Street do
  it { should have_many :addresses }
end
