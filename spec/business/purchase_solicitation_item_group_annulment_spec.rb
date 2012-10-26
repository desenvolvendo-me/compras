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

  let(:item_group) { double(:item_group, :id => 2, :change_status! => true) }
  let(:item_status_changer) { double(:item_status_changer, :change => true) }

  describe '#annul' do
    it 'should change status of items and item_group' do
      item_group.stub(:purchase_solicitation_item_ids).and_return([1, 2, 3])

      item_status_changer.should_receive(:new).
                          with(:old_item_ids => [1, 2, 3]).
                          and_return(item_status_changer)

      item_group.should_receive(:change_status!).with(PurchaseSolicitationItemGroupStatus::ANNULLED)

      subject.annul
    end
  end
end
