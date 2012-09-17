# encoding: utf-8
require 'model_helper'
require 'app/models/bidder'
require 'app/models/unico/person'
require 'app/models/person'
require 'app/models/accredited_representative'

describe AccreditedRepresentative do
  it { should belong_to :person }
  it { should belong_to :bidder }
end
