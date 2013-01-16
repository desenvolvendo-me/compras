require 'unit_helper'
require 'app/business/purchase_solicitation_item_group_status_changer'

describe PurchaseSolicitationItemGroupStatusChanger do
  let(:item_group_repository) { double(:item_group_repository) }
  let(:item_group) { double(:item_group, :id => 1, :purchase_solicitations => [purchase_solicitation_1, purchase_solicitation_2]) }
  let(:purchase_solicitation_1) { double(:purchase_solicitation_1) }
  let(:purchase_solicitation_2) { double(:purchase_solicitation_2) }
  let(:purchase_solicitation_status_changer) { double(:purchase_solicitation_status_changer) }

  context 'when has a item group' do
    subject { described_class.new(item_group, purchase_solicitation_status_changer, item_group_repository) }

    context "change!" do
      it 'should change item group status and change for each purchase solicitation' do
        item_group_repository.should_receive(:find).with(item_group.id).and_return(item_group)
        item_group.should_receive(:fulfill!)

        purchase_solicitation_status_changer.
          should_receive(:change).
          exactly(1).times.
          with(purchase_solicitation_1)

        purchase_solicitation_status_changer.
          should_receive(:change).
          exactly(1).times.
          with(purchase_solicitation_2)

        subject.change!
      end
    end
  end
end
