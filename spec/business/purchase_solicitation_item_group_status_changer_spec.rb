require 'unit_helper'
require 'app/business/purchase_solicitation_item_group_status_changer'

describe PurchaseSolicitationItemGroupStatusChanger do
  context 'when has a item group' do
    subject { described_class.new(item_group, purchase_solicitation_status_changer) }

    let(:item_group) { double(:item_group, :purchase_solicitations => [purchase_solicitation_1, purchase_solicitation_2]) }
    let(:purchase_solicitation_1) { double(:purchase_solicitation_1) }
    let(:purchase_solicitation_2) { double(:purchase_solicitation_2) }
    let(:purchase_solicitation_status_changer) { double(:purchase_solicitation_status_changer) }

    context "change!" do
      it 'should change item group status and change for each purchase solicitation' do
        item_group.should_receive(:fulfill!)

        purchase_solicitation_status_changer.should_receive(:change).
                                             exactly(1).times.
                                             with(purchase_solicitation_1)

        purchase_solicitation_status_changer.should_receive(:change).
                                             exactly(1).times.
                                             with(purchase_solicitation_2)

        subject.change!
      end
    end
  end
end
