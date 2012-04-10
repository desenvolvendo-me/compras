require 'unit_helper'
require 'app/business/direct_purchase_modality_limit_verificator'

describe DirectPurchaseModalityLimitVerificator do
  let :direct_purchase do
    double('direct purchase', :licitation_object_purchase_licitation_exemption => 400.0,
                              :licitation_object_build_licitation_exemption => 500.0)
  end

  let :limit_storage do
    double('modality limit', :current_limit_material_or_service_without_bidding => 500,
                             :current_limit_engineering_works_without_bidding => 700)
  end

  let :subject do
    DirectPurchaseModalityLimitVerificator.new(direct_purchase, limit_storage)
  end

  it 'should return true with modality mateiral_or_service and total of item equal to 100' do
    direct_purchase.stub(:material_or_service?).and_return(true)
    direct_purchase.stub(:engineering_works?).and_return(false)
    direct_purchase.stub(:total_allocations_items_value).and_return(100)

    subject.verify!.should be_true
  end

  it 'should return false with modality mateiral_or_service and total of item equal to 100.01' do
    direct_purchase.stub(:material_or_service?).and_return(true)
    direct_purchase.stub(:engineering_works?).and_return(false)
    direct_purchase.stub(:total_allocations_items_value).and_return(100.01)

    subject.verify!.should be_false
  end

  it 'should return true with modality engineering_works and total of item equal to 200' do
    direct_purchase.stub(:material_or_service?).and_return(false)
    direct_purchase.stub(:engineering_works?).and_return(true)
    direct_purchase.stub(:total_allocations_items_value).and_return(200)

    subject.verify!.should be_true
  end

  it 'should return false with modality engineering_works and total of item equal to 200.01' do
    direct_purchase.stub(:material_or_service?).and_return(false)
    direct_purchase.stub(:engineering_works?).and_return(true)
    direct_purchase.stub(:total_allocations_items_value).and_return(200.01)

    subject.verify!.should be_false
  end
end
