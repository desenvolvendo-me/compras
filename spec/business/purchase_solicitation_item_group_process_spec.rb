require 'unit_helper'
require 'ostruct'
require 'enumerate_it'
require 'app/enumerations/purchase_solicitation_item_group_status'
require 'app/business/purchase_solicitation_item_group_process'

describe PurchaseSolicitationItemGroupProcess do
  describe "#set_item_group" do

    let (:process) { OpenStruct.new } 
    let (:item_group) { double(:item_group, :change_status! => nil) } 

    subject do
      PurchaseSolicitationItemGroupProcess.new(process)
    end

    before do
      process.stub(:save! => true)
    end

    it "updates the item group status to 'in_purchase_process'" do
      item_group.should_receive(:change_status!).with(PurchaseSolicitationItemGroupStatus::IN_PURCHASE_PROCESS)
      subject.set_item_group(item_group)
    end

    it "sets the item group of the process" do
      subject.set_item_group(item_group)
      expect(process.purchase_solicitation_item_group).to eq item_group
    end

    context "process already has a item group" do
      it "should change the status of the current item group back to 'pending'" do
        old_group = double(:old_group)
        process.stub(:purchase_solicitation_item_group => old_group)

        old_group.should_receive(:change_status!).with(PurchaseSolicitationItemGroupStatus::PENDING)
        subject.set_item_group(item_group)
      end
    end
  end
end
