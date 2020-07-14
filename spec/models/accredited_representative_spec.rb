require 'model_helper'
require 'app/models/bidder'
require 'app/models/persona/person'
require 'app/models/person'
require 'app/models/accredited_representative'

describe AccreditedRepresentative do
  it { should belong_to :person }
  it { should belong_to :bidder }
end
