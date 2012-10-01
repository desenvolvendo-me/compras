require 'unit_helper'
require 'app/business/purchase_solicitation_item_group_annulment'

describe PurchaseSolicitationItemGroupAnnulment do
  subject do
    PurchaseSolicitationItemGroupAnnulment.new(item_group, item_status_changer)
  end

  let :item_group do
    double(:item_group)
  end

  let :item_status_changer do
    double(:item_status_changer, :change => true)
  end

  context '#annul' do
    it 'should change the status of purchase_solicitation_items to pending' do
      item_group.stub(:purchase_solicitation_item_ids).and_return([1, 2, 3])

      item_status_changer.should_receive(:new).
                          with(:old_item_ids => [1, 2, 3]).
                          and_return(item_status_changer)

      subject.annul
    end
  end
end
