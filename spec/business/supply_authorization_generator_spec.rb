require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/supply_authorization_generator'

describe SupplyAuthorizationGenerator do
  subject do
    described_class.new(direct_purchase_object, supply_authorization_repository)
  end

  let :direct_purchase_object do
    double(:direct_purchase_object,
           :id => 1,
           :year => 2012,
           :fulfill_item_group => nil)
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

  context "when the supply authorization is not yet generated" do 
    before do
      direct_purchase_object.stub(:authorized?).and_return(false)
      purchase_solicitation.stub(:present? => false)
      direct_purchase_object.stub(:purchase_solicitation => purchase_solicitation)
      supply_authorization_repository.stub(:create! => supply_authorization_object)
    end

    it 'should generate supply_authorization' do
      purchase_solicitation.should_receive(:present?).and_return(true)

      purchase_solicitation.should_receive(:attend!)
      expect(subject.generate!).to eq supply_authorization_object
    end

    it 'should generate supply_authorization withou purchase_solicitation' do
      purchase_solicitation.should_not_receive(:attend!)
      expect(subject.generate!).to eq supply_authorization_object
    end

    it 'changes the status of the direct purchase item group to fulfilled' do
      direct_purchase_object.should_receive(:fulfill_item_group)
      subject.generate!
    end
  end

  it 'should not have authorize! on public interface' do
    expect(subject.respond_to?(:authorize!)).to be false
  end
end
