require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/purchase_solicitation_item_group_status'
require 'app/business/purchase_solicitation_item_group_process'

describe PurchaseSolicitationItemGroupProcess do
  let(:new_item_group) { double(:new_item_group, :pending? => true, :purchase_solicitations => purchase_solicitations) }
  let(:old_item_group) { double(:old_item_group, :purchase_solicitations => purchase_solicitations) }
  let(:purchase_solicitation_status_changer) { double(:purchase_solicitation_status_changer) }
  let(:purchase_solicitations) { [purchase_solicitation1, purchase_solicitation2] }
  let(:purchase_solicitation1) { double(:purchase_solicitation1) }
  let(:purchase_solicitation2) { double(:purchase_solicitation2) }

  describe '#update_status' do
    context 'with new_item_group' do
      subject do
        described_class.new({:new_item_group => new_item_group}, purchase_solicitation_status_changer)
      end

      it "updates the item group status to 'in_purchase_process'" do
        new_item_group.should_receive(:change_status!).
          with(PurchaseSolicitationItemGroupStatus::IN_PURCHASE_PROCESS)

        old_item_group.should_not_receive(:change_status!).
          with(PurchaseSolicitationItemGroupStatus::PENDING)
        old_item_group.should_not_receive(:liberate_purchase_solicitations!)

        purchase_solicitation_status_changer.should_receive(:change).with(purchase_solicitation1)
        purchase_solicitation_status_changer.should_receive(:change).with(purchase_solicitation2)

        subject.update_status
      end

      it "raises an error if the new item group status is not 'Pending'" do
        new_item_group.stub(:pending?).and_return(false)

        expect { subject.update_status }.to raise_error(
          ArgumentError, "Item group status should be 'Pending'")
      end
    end

    context 'with old_item_group' do
      subject do
        described_class.new({:old_item_group => old_item_group}, purchase_solicitation_status_changer)
      end

      it "should update status of item group to 'pending'" do
        new_item_group.should_not_receive(:change_status!).
          with(PurchaseSolicitationItemGroupStatus::IN_PURCHASE_PROCESS)
        new_item_group.should_not_receive(:buy_purchase_solicitations!)

        old_item_group.should_receive(:change_status!).
          with(PurchaseSolicitationItemGroupStatus::PENDING)

        purchase_solicitation_status_changer.should_receive(:change).with(purchase_solicitation1)
        purchase_solicitation_status_changer.should_receive(:change).with(purchase_solicitation2)

        subject.update_status
      end
    end

    context 'with different new_item_group and old_item_group' do
      subject do
        described_class.new(
          { :new_item_group => new_item_group, :old_item_group => old_item_group },
          purchase_solicitation_status_changer
        )
      end

      it "should update status of item group to 'pending'" do
        new_item_group.should_receive(:change_status!).
          with(PurchaseSolicitationItemGroupStatus::IN_PURCHASE_PROCESS)

        old_item_group.should_receive(:change_status!).
          with(PurchaseSolicitationItemGroupStatus::PENDING)

        purchase_solicitation_status_changer.should_receive(:change).at_least(1).times.with(purchase_solicitation1)
        purchase_solicitation_status_changer.should_receive(:change).at_least(1).times.with(purchase_solicitation2)

        subject.update_status
      end
    end

    context 'when old and new solicitation are the same' do
      subject do
        described_class.new(
          { :new_item_group => new_item_group, :old_item_group => new_item_group },
          purchase_solicitation_status_changer
        )
      end

      it 'should do noting' do
        new_item_group.should_not_receive(:change_status!).
          with(PurchaseSolicitationItemGroupStatus::IN_PURCHASE_PROCESS)
        new_item_group.should_not_receive(:buy_purchase_solicitations!)

        old_item_group.should_not_receive(:change_status!).
          with(PurchaseSolicitationItemGroupStatus::PENDING)
        old_item_group.should_not_receive(:liberate_purchase_solicitations!)

        purchase_solicitation_status_changer.should_not_receive(:change)
        purchase_solicitation_status_changer.should_not_receive(:change)

        subject.update_status
      end
    end
  end
end
