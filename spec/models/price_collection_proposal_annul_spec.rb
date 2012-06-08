# encoding: utf-8
require 'model_helper'
require 'app/models/price_collection_proposal'
require 'app/models/price_collection_proposal_annul'

describe PriceCollectionProposalAnnul do
  it { should belong_to :price_collection_proposal }
  it { should belong_to :employee }

  it { should validate_presence_of :date }
  it { should validate_presence_of :employee }
  it { should validate_presence_of :price_collection_proposal }
end
