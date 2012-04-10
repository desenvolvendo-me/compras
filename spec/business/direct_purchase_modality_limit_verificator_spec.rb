require 'unit_helper'
require 'enumerate_it'
require 'app/business/direct_purchase_modality_limit_verificator'
require 'app/enumerations/direct_purchase_modality'

describe DirectPurchaseModalityLimitVerificator do

  let :licitation_object do
    double('licitation object',
            :purchase_licitation_exemption => 400.0,
            :build_licitation_exemption => 500.0)
  end

  let :direct_purchase do
    double('direct purchase', :licitation_object => licitation_object)
  end

  let :modality_limit do
    double(:without_bidding => 500, :work_without_bidding => 700)
  end

  let :limit_storage do
    double('modality limit', :current => modality_limit)
  end

  let :subject do
    DirectPurchaseModalityLimitVerificator.new(direct_purchase, limit_storage)
  end

  it 'should return true with modality mateiral_or_service and total of item equal to 100' do
    direct_purchase.stub(:modality => DirectPurchaseModality::MATERIAL_OR_SERVICE)
    direct_purchase.stub(:total_allocations_items_value => 100)

    subject.verify!.should be_true
  end

  it 'should return false with modality mateiral_or_service and total of item equal to 100.01' do
    direct_purchase.stub(:modality => DirectPurchaseModality::MATERIAL_OR_SERVICE)
    direct_purchase.stub(:total_allocations_items_value => 100.01)

    subject.verify!.should be_false
  end

  it 'should return true with modality engineering_works and total of item equal to 200' do
    direct_purchase.stub(:modality => DirectPurchaseModality::ENGINEERING_WORKS)
    direct_purchase.stub(:total_allocations_items_value => 200)

    subject.verify!.should be_true
  end

  it 'should return false with modality engineering_works and total of item equal to 200.01' do
    direct_purchase.stub(:modality => DirectPurchaseModality::ENGINEERING_WORKS)
    direct_purchase.stub(:total_allocations_items_value => 200.01)

    subject.verify!.should be_false
  end
end
