require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/supply_authorization_generator'

describe SupplyAuthorizationGenerator do
  subject do
    described_class.new(direct_purchase_object, supply_authorization_repository)
  end

  let :direct_purchase_object do
    double(:direct_purchase_object, :id => 1, :year => 2012)
  end

  let :supply_authorization_repository do
    double(:supply_authorization_repository)
  end

  let :supply_authorization_object do
    double(:supply_authorization_object)
  end

  let :purchase_solicitation do
    double(:purchase_solicitation)
  end

  it 'should return supply_authorization if already have' do
    direct_purchase_object.stub(:supply_authorization).and_return(supply_authorization_object)
    direct_purchase_object.stub(:authorized?).and_return(true)
    expect(subject.generate!).to eq supply_authorization_object
  end

  it 'should generate supply_authorization' do
    direct_purchase_object.stub(:purchase_solicitation).and_return(purchase_solicitation)
    direct_purchase_object.stub(:authorized?).and_return(false)

    purchase_solicitation.should_receive(:present?).and_return(true)
    purchase_solicitation.should_receive(:attend!)

    supply_authorization_repository.should_receive(:create!).with(
      :direct_purchase_id => 1,
      :year => 2012
    ).and_return(supply_authorization_object)

    expect(subject.generate!).to eq supply_authorization_object
  end

  it 'should generate supply_authorization withou purchase_solicitation' do
    direct_purchase_object.stub(:purchase_solicitation).and_return(purchase_solicitation)
    direct_purchase_object.stub(:authorized?).and_return(false)

    purchase_solicitation.should_receive(:present?).and_return(false)
    purchase_solicitation.should_not_receive(:attend!)

    supply_authorization_repository.should_receive(:create!).with(
      :direct_purchase_id => 1,
      :year => 2012
    ).and_return(supply_authorization_object)

    expect(subject.generate!).to eq supply_authorization_object
  end

  it 'should not have authorize! on public interface' do
    expect(subject.respond_to?(:authorize!)).to be false
  end
end
