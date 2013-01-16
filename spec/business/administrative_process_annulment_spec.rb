# encoding: utf-8
require 'unit_helper'
require 'enumerate_it'
require 'active_support/core_ext/module/delegation'
require "active_support/core_ext/date/calculations"
require 'app/enumerations/administrative_process_status'
require 'app/business/administrative_process_annulment'

describe AdministrativeProcessAnnulment do
  subject do
    AdministrativeProcessAnnulment.new(
      administrative_process,
      current_user,
      :item_group_annulment_creator => item_group_annulment_creator,
      :budget_allocation_fulfiller => budget_allocation_fulfiller
    )
  end

  let(:administrative_process) { double(:administrative_process, :to_s => '1/2012') }
  let(:current_user) { double(:current_user) }
  let(:budget_allocation_fulfiller) { double(:budget_allocation_fulfiller) }
  let(:item_group_annulment_creator) { double(:item_group_annulment_creator) }

  describe 'delegates' do
    it 'should delegates purchase_solicitation_item_group to administrative_process' do
      administrative_process.should_receive(:purchase_solicitation_item_group)

      subject.purchase_solicitation_item_group
    end
  end

  it 'should annuls administrative process' do
    item_group = double(:item_group, :present? => false)

    administrative_process.stub(:purchase_solicitation_item_group => item_group)

    administrative_process.should_receive(:update_status).with(AdministrativeProcessStatus::ANNULLED)

    subject.annul
  end

  context 'with purchase_solicitation_item_group' do
    it 'should annuls administrative process, purchase_solicitation_item_group and clean fulfillers' do
      item_group = double(:item_group, :present? => true)
      item_group_annulment_creator_instance = double(:item_group_annulment_creator_instance)
      fulfiller_instance = double(:fulfiller_instance)

      current_user.stub(:authenticable).and_return('User authenticable')

      administrative_process.stub(:purchase_solicitation_item_group).
                             and_return(item_group)

      administrative_process.should_receive(:update_status).
                             with(AdministrativeProcessStatus::ANNULLED)

      subject.should_receive(:annulment_message).and_return('Anulado através do processo administrativo 1/2012')

      item_group_annulment_creator_instance.should_receive(:create_annulment).
                                    with('User authenticable', Date.current, "Anulado através do processo administrativo 1/2012")

      item_group_annulment_creator.should_receive(:new).
                           with(item_group).
                           and_return(item_group_annulment_creator_instance)

      budget_allocation_fulfiller.should_receive(:new).
                                  with(:purchase_solicitation_item_group => item_group).
                                  and_return(fulfiller_instance)

      fulfiller_instance.should_receive(:fulfill)

      subject.annul
    end
  end
end
