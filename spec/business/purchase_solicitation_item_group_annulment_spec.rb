# encoding: utf-8
require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/purchase_solicitation_item_group_status'
require 'app/business/purchase_solicitation_item_group_annulment'

describe PurchaseSolicitationItemGroupAnnulment do
  subject do
    PurchaseSolicitationItemGroupAnnulment.new(
      item_group,
      :item_status_changer => item_status_changer
    )
  end

  let(:item_group) { double(:item_group) }
  let(:item_status_changer) { double(:item_status_changer, :change => true) }

  describe '#annul' do
    it 'should change status of items and item_group' do
      item_status_changer.should_receive(:new).
                          with(:old_purchase_solicitation_item_group => item_group).
                          and_return(item_status_changer)

      item_status_changer.should_receive(:change)
      item_group.should_receive(:change_status!).with(PurchaseSolicitationItemGroupStatus::ANNULLED)

      subject.annul
    end
  end
end
