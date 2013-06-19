# encoding: utf-8
require 'spec_helper'

describe SupplyOrderItem do
  describe '#authorized_value' do
    it 'returns the sum of authorization value of ratifications of the same item' do
      wenderson = Creditor.make!(:wenderson_sa)

      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador,
        items: [PurchaseProcessItem.make!(:item_arame_farpado, quantity: 5)])

      proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation_process, creditor: wenderson)

      ratification_item = LicitationProcessRatificationItem.make!(:item,
        licitation_process_ratification: nil,
        purchase_process_creditor_proposal: proposal)

      ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador,
        creditor: wenderson,
        licitation_process: licitation_process,
        licitation_process_ratification_items: [ratification_item])

      supply_order = SupplyOrder.create!({
        authorization_date: Date.new(2013, 12, 12),
        creditor_id: wenderson.id,
        licitation_process_id: licitation_process.id,
        year: 2013
      })

      supply_order.items << SupplyOrderItem.create!({
        licitation_process_ratification_item_id: ratification_item.id,
        authorization_value: 2.99
      })

      supply_order.items << SupplyOrderItem.create!({
        licitation_process_ratification_item_id: ratification_item.id,
        authorization_value: 1.99
      })

      subject = supply_order.items.first

      expect(subject.authorized_value).to eq 4.98
    end
  end
end
