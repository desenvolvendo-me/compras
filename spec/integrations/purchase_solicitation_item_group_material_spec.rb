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
        :reparo_liberado,
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

  context "validations" do
    it "only allows purchase solicitations with 'PENDING' status" do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo,
                                                         :service_status => PurchaseSolicitationServiceStatus::ATTENDED)
      item_group_material = PurchaseSolicitationItemGroupMaterial.make(:reparo,
                              :purchase_solicitations => [purchase_solicitation])

      item_group_material.valid?

      expect(item_group_material.errors[:purchase_solicitations]).to include "deve estar com situação Liberada para ser agrupada"
    end
  end
end
