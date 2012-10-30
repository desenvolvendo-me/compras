require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/purchase_solicitation_item_group_status'
require 'app/business/purchase_solicitation_item_group_process'

describe PurchaseSolicitationItemGroupProcess do
  describe "#update_item_group_status" do
    let :item_group do
      double(:item_group, :change_status! => nil, :pending? => true)
    end

    it "updates the item group status to 'in_purchase_process'" do
      item_group.should_receive(:change_status!).with(PurchaseSolicitationItemGroupStatus::IN_PURCHASE_PROCESS)

      described_class.update_item_group_status(item_group)
    end

    it "raises an error if the new item group status is not 'Pending'" do
      item_group.stub(:pending?).and_return(false)

      expect {
        described_class.update_item_group_status(item_group)
      }.to raise_error(ArgumentError, "Item group status should be 'Pending'")
    end

    context "process already has a item group" do
      it "should change the status of the current item group back to 'pending'" do
        old_group = double(:old_group)

        old_group.should_receive(:change_status!).with(PurchaseSolicitationItemGroupStatus::PENDING)

        described_class.update_item_group_status(item_group, old_group)
      end
    end

    context "when old and new solicitation are the same" do
      it "it should do nothing" do
        item_group.should_not_receive(:change_status!)

        described_class.update_item_group_status(item_group, item_group)
      end
    end
  end
end
