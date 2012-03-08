require 'unit_helper'
require 'enumerate_it'
require 'app/business/bid_opening_modalities_by_object_type'
require 'app/enumerations/bid_opening_modality'
require 'app/enumerations/bid_opening_object_type'

describe BidOpeningModalitiesByObjectType do
  it 'should verify status for type' do
    subject.verify_modality(BidOpeningObjectType::PURCHASE_AND_SERVICES, BidOpeningModality::MAKING_COST_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES).should be_true
    subject.verify_modality(BidOpeningObjectType::PURCHASE_AND_SERVICES, BidOpeningModality::MAKING_COST_FOR_PURCHASES_AND_SERVICES).should be_true
    subject.verify_modality(BidOpeningObjectType::PURCHASE_AND_SERVICES, BidOpeningModality::INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES).should be_true
    subject.verify_modality(BidOpeningObjectType::PURCHASE_AND_SERVICES, BidOpeningModality::AUCTION).should_not be_true
  end
end
