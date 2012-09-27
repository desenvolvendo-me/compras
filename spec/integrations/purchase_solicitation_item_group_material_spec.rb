# encoding: utf-8
require 'spec_helper'

describe PurchaseSolicitationItemGroupMaterial do
  context 'purchase_solicitation_items conditon' do
    subject do
      PurchaseSolicitationItemGroupMaterial.make!(
        :reparo,
        :purchase_solicitations => [purchase_solicitation]
      )
    end

    let :purchase_solicitation do
      PurchaseSolicitation.make(
        :reparo,
        :purchase_solicitation_budget_allocations => [
          allocation_with_same_material,
          allocation_with_diferente_material
        ]
      )
    end

    let :allocation_with_same_material do
      PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria)
    end

    let :allocation_with_diferente_material do
      PurchaseSolicitationBudgetAllocation.make!(:alocacao_primaria_office)
    end

    it 'should filter purchase_solicitation_items by material' do
      item_with_same_material = allocation_with_same_material.items.first
      item_with_diferent_material = allocation_with_diferente_material.items.first

      expect(subject.purchase_solicitation_items).to eq [item_with_same_material]
      expect(subject.purchase_solicitation_items).to_not include item_with_diferent_material
    end
  end
end