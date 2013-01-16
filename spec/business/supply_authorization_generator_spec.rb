require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/supply_authorization_generator'

describe SupplyAuthorizationGenerator do
  subject do
    described_class.new(direct_purchase_object, supply_authorization_repository, item_repository, item_group_status_changer)
  end

  let :direct_purchase_object do
    double(:direct_purchase_object,
           :id => 1,
           :year => 2012,
           :fulfill_item_group => nil)
  end

  let(:supply_authorization_repository) { double(:supply_authorization_repository) }
  let(:item_group_status_changer) { double(:item_group_status_changer) }
  let(:item_repository) { double(:item_repository) }
  let(:supply_authorization_object) { double(:supply_authorization_object) }
  let(:purchase_solicitation) { double(:purchase_solicitation) }
  let(:purchase_solicitation_item_group) { double(:purchase_solicitation_item_group) }
  let(:items) { double(:items) }

  it 'should return supply_authorization if already have' do
    direct_purchase_object.stub(:supply_authorization).and_return(supply_authorization_object)
    direct_purchase_object.stub(:authorized?).and_return(true)
    expect(subject.generate!).to eq supply_authorization_object
  end

  context "when the supply authorization is not yet generated" do 
    before do
      supply_authorization_repository.stub(:create! => supply_authorization_object)
    end

    context 'when has a direct purchase with purchase solicitation' do 
      before do
        direct_purchase_object.stub(:authorized?).and_return(false)
        direct_purchase_object.stub(:purchase_solicitation => purchase_solicitation)
        direct_purchase_object.stub(:purchase_solicitation_item_group => purchase_solicitation_item_group)
        purchase_solicitation.stub(:blank? => false)
        purchase_solicitation_item_group.stub(:blank? => true)
      end

      it 'should generate supply_authorization' do
        purchase_solicitation.should_receive(:attend!)
        purchase_solicitation.should_receive(:attend_items!)
        expect(subject.generate!).to eq supply_authorization_object
      end
    end

    context 'when has a direct purchase with item group' do 
      before do
        direct_purchase_object.stub(:authorized?).and_return(false)
        direct_purchase_object.stub(:purchase_solicitation => purchase_solicitation)
        direct_purchase_object.stub(:purchase_solicitation_item_group => purchase_solicitation_item_group)
        purchase_solicitation.stub(:blank? => true)
        purchase_solicitation_item_group.stub(:blank? => false)
      end

      it 'should generate supply_authorization' do
        item_repository.should_receive(:by_item_group).
                        with(purchase_solicitation_item_group).
                        and_return(items)

        items.should_receive(:attend!)

        item_group_status_changer.should_receive(:change).
                                  with(purchase_solicitation_item_group)

        expect(subject.generate!).to eq supply_authorization_object
      end
    end

    context 'without purchase solicitation and item group' do
      before do
        direct_purchase_object.should_receive(:purchase_solicitation).
                               at_least(1).times.and_return(purchase_solicitation)
        direct_purchase_object.should_receive(:purchase_solicitation_item_group).
                               at_least(1).times.and_return(purchase_solicitation_item_group)
        purchase_solicitation.stub(:blank? => true)
        purchase_solicitation_item_group.stub(:blank? => true)
        direct_purchase_object.stub(:authorized?).and_return(false)
      end

      it 'should generate supply_authorization without purchase_solicitation' do
        purchase_solicitation.should_not_receive(:attend!)
        item_group_status_changer.should_not_receive(:change).with(purchase_solicitation_item_group)
        expect(subject.generate!).to eq supply_authorization_object
      end
    end

    it 'should not have authorize! on public interface' do
      expect(subject.respond_to?(:authorize!)).to be false
    end
  end
end
