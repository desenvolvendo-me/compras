# encoding: utf-8
require 'unit_helper'
require 'app/business/direct_purchase_annulment'
require 'app/business/purchase_solicitation_budget_allocation_item_status_changer'

describe DirectPurchaseAnnulment do
  subject do
    DirectPurchaseAnnulment.new(direct_purchase, resource_annul, item_group_annulment)
  end

  let :direct_purchase do
    double(
      :direct_purchase,
      :purchase_solicitation_item_group => purchase_solicitation_item_group
    )
  end

  let :purchase_solicitation_item_group do
    double(:purchase_solicitation_item_group)
  end

  let :item_group_annulment do
    double(:item_status_changer, :annul => true)
  end

  let :resource_annul do
    double(:resource_annul,
      :employee => 'João',
      :date => Date.new(2012, 10, 01),
      :description => 'Anulação'
    )
  end

  it 'should set items from purchase_solicitation_item_group as pending when has a purchase_solicitation_item_group' do
    purchase_solicitation_item_group.stub(:present?).and_return(true)

    item_group_annulment.should_receive(:new).
                         with(purchase_solicitation_item_group).
                         and_return(item_group_annulment)

    item_group_annulment.should_receive(:create_annulment).
                         with(
                           'João',
                           Date.new(2012, 10, 01),
                           'Anulação'
                         )

    subject.annul
  end

  it 'should not update status of items when purchase_solicitation_item_group is not present' do
    purchase_solicitation_item_group.stub(:present?).and_return(false)

    item_group_annulment.should_not_receive(:new)

    subject.annul
  end
end
