require 'model_helper'
require 'app/models/unico/street'
require 'app/models/street'
require 'app/models/address'

describe Street do
  it { should have_many :addresses }
end
