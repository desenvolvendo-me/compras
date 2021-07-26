require 'model_helper'
require 'app/models/inscriptio_cursualis/land_subdivision'
require 'app/models/land_subdivision'
require 'app/models/inscriptio_cursualis/address'
require 'app/models/address'

describe LandSubdivision do
  it { should have_many :addresses }
end
