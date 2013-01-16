# encoding: utf-8
require 'spec_helper'

describe AdministrativeProcess do
  describe 'purchase_solicitation_items' do
    it 'should return blank to purchase solicitation items when has not item on administrative process' do
      administrative_process = AdministrativeProcess.make!(:compra_aguardando)

      expect(administrative_process.purchase_solicitation_items).to eq []
    end

    it 'should return items with same material to purchase solicitation items when has item on administrative process' do
      purchase_solicitation  = PurchaseSolicitation.make!(:reparo_liberado)
      administrative_process = AdministrativeProcess.make!(:compra_sem_convite)
      administrative_process.purchase_solicitation = purchase_solicitation
      administrative_process.save!

      expect(administrative_process.purchase_solicitation_items).to eq purchase_solicitation.items
    end
  end
end
