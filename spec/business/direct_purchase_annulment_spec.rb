# encoding: utf-8
require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/direct_purchase_annulment'
require 'app/business/supply_authorization_email_sender'
require 'app/business/purchase_solicitation_budget_allocation_item_status_changer'

describe DirectPurchaseAnnulment do
  subject do
    DirectPurchaseAnnulment.new(
      direct_purchase,
      resource_annul,
      context,
      item_group_annulment,
      email_sender
    )
  end

  let :direct_purchase do
    double(
      :direct_purchase,
      :purchase_solicitation_item_group => purchase_solicitation_item_group,
      :purchase_solicitation => purchase_solicitation,
      :supply_authorization => supply_authorization
    )
  end

  let :purchase_solicitation do
    double(:purchase_solicitation)
  end

  let :purchase_solicitation_item_group do
    double(:purchase_solicitation_item_group)
  end

  let :supply_authorization do
    double(:supply_authorization)
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

  let :context do
    double(:context)
  end

  let :email_sender do
    double(:email_sender)
  end

  describe '#annul' do
    it 'should set items from purchase_solicitation_item_group as pending when has a purchase_solicitation_item_group' do
      purchase_solicitation_item_group.stub(:present?).and_return(true)
      purchase_solicitation.stub(:present?).and_return(false)
      supply_authorization.stub(:present?).and_return(false)

      item_group_annulment.should_receive(:new).
                           with(purchase_solicitation_item_group).
                           and_return(item_group_annulment)

      item_group_annulment.should_receive(:create_annulment).
                           with('João', Date.new(2012, 10, 01), 'Anulação')

      subject.annul
    end

    it 'should not update status of items when purchase_solicitation_item_group is not present' do
      purchase_solicitation_item_group.stub(:present?).and_return(false)
      purchase_solicitation.stub(:present?).and_return(false)
      supply_authorization.stub(:present?).and_return(false)

      item_group_annulment.should_not_receive(:new)

      subject.annul
    end

    it 'should clear purchase_solicitation items fulfiller and change status to pending' do
      purchase_solicitation_item_group.stub(:present?).and_return(false)
      purchase_solicitation.stub(:present?).and_return(true)
      supply_authorization.stub(:present?).and_return(false)

      purchase_solicitation.should_receive(:clear_items_fulfiller_and_status)

      subject.annul
    end

    it 'should not clear purchase_solicitation items fulfiller and change status to pending when purchase_solicitation not present' do
      purchase_solicitation_item_group.stub(:present?).and_return(false)
      purchase_solicitation.stub(:present?).and_return(false)
      supply_authorization.stub(:present?).and_return(false)


      purchase_solicitation.should_not_receive(:clear_items_fulfiller_and_status)

      subject.annul
    end

    it 'should change status of purchase solicitation when there is a supply_authorization assigned' do
      purchase_solicitation_item_group.stub(:present?).and_return(false)
      purchase_solicitation.stub(:present?).and_return(false)
      supply_authorization.stub(:present?).and_return(true)

      email_sender.should_receive(:deliver)
      email_sender.should_receive(:new).with(supply_authorization, context).and_return(email_sender)
      purchase_solicitation.should_not_receive(:liberate!)

      subject.annul
    end

    it 'should change status of purchase solicitation and liberate purchase solicitation when there is a supply_authorization assigned' do
      purchase_solicitation_item_group.stub(:present?).and_return(false)
      purchase_solicitation.stub(:present?).and_return(true)
      supply_authorization.stub(:present?).and_return(true)

      email_sender.should_receive(:deliver)
      email_sender.should_receive(:new).with(supply_authorization, context).and_return(email_sender)
      purchase_solicitation.should_receive(:liberate!)
      purchase_solicitation.should_receive(:clear_items_fulfiller_and_status)

      subject.annul
    end
  end

  it 'should delegates purchase_solicitation_item_group to direct_purchase' do
    direct_purchase.stub(:purchase_solicitation_item_group).and_return(true)
    purchase_solicitation.stub(:present?).and_return(false)

    expect(subject.purchase_solicitation_item_group).to be true

    direct_purchase.stub(:purchase_solicitation_item_group).and_return(false)

    expect(subject.purchase_solicitation_item_group).to be false
  end

  it 'should delegates supply_authorization to direct_purchase' do
    direct_purchase.stub(:supply_authorization).and_return(true)
    purchase_solicitation.stub(:present?).and_return(false)

    expect(subject.supply_authorization).to be true

    direct_purchase.stub(:supply_authorization).and_return(false)

    expect(subject.supply_authorization).to be false
  end
end
