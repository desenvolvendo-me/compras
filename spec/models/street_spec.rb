require 'model_helper'
require 'app/models/inscriptio_cursualis/street'
require 'app/models/street'
require 'app/models/inscriptio_cursualis/address'
require 'app/models/address'
require 'app/models/inscriptio_cursualis/neighborhood'

describe Street do
  it { should have_many :addresses }
end
