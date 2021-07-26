require 'model_helper'
require 'app/models/inscriptio_cursualis/neighborhood'
require 'app/models/neighborhood'
require 'app/models/inscriptio_cursualis/address'
require 'app/models/address'

describe Neighborhood do
  it { should have_many(:addresses).dependent(:restrict) }
end
