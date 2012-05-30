require 'model_helper'
require 'app/models/unico/land_subdivision'
require 'app/models/land_subdivision'
require 'app/models/address'

describe LandSubdivision do
  it { should have_many :addresses }
end
