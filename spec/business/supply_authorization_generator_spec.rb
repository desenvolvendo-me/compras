require 'unit_helper'
require 'app/business/supply_authorization_generator'

describe SupplyAuthorizationGenerator do
  subject do
    described_class.new(direct_purchase_object, supply_authorization_storage)
  end

  let :direct_purchase_object do
    double(:id => 1, :year => 2012)
  end

  let :supply_authorization_storage do
    double
  end

  let :supply_authorization_object do
    double
  end

  it 'should return supply_authorization if already have' do
    direct_purchase_object.stub(:supply_authorization).and_return(supply_authorization_object)
    direct_purchase_object.stub(:authorized?).and_return(true)
    subject.generate!.should eq supply_authorization_object
  end

  it 'should generate supply_authorization' do
    direct_purchase_object.stub(:authorized?).and_return(false)

    supply_authorization_storage.should_receive(:create).with(
      :direct_purchase_id => direct_purchase_object.id,
      :year => 2012
    ).and_return(supply_authorization_object)

    subject.generate!.should eq supply_authorization_object
  end
end
