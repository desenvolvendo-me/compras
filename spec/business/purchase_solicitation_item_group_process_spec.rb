require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/purchase_solicitation_item_group_status'
require 'app/business/purchase_solicitation_item_group_process'

describe PurchaseSolicitationItemGroupProcess do
  describe "#update_item_group_status" do

    let(:process) { double(:process) }
    let(:item_group) { double(:item_group,
                               :change_status! => nil,
                               :pending? => true) }

    subject do
      PurchaseSolicitationItemGroupProcess.new(process)
    end

    it "updates the item group status to 'in_purchase_process'" do
      process.stub(:purchase_solicitation_item_group => nil)

      item_group.should_receive(:change_status!).with(PurchaseSolicitationItemGroupStatus::IN_PURCHASE_PROCESS)
      subject.update_item_group_status(item_group)
    end

    it "raises an error if the new item group status is not 'Pending'" do
      item_group.stub(:pending? => false)

      expect {
        subject.update_item_group_status(item_group)
      }.to raise_error(ArgumentError, "Item group status should be 'Pending'")
    end

    context "process already has a item group" do
      it "should change the status of the current item group back to 'pending'" do
        old_group = double(:old_group)
        process.stub(:purchase_solicitation_item_group => old_group)

        old_group.should_receive(:change_status!).with(PurchaseSolicitationItemGroupStatus::PENDING)
        subject.update_item_group_status(item_group)
      end
    end
  end
end
