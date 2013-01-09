# encoding: utf-8
require 'spec_helper'

describe PurchaseSolicitationItemGroup do
  describe '#purchase_solicitation_status' do
    subject do
      PurchaseSolicitationItemGroup.make!(:reparo_2013)
    end

    let(:purchase_solicitation) { PurchaseSolicitation.make!(:reparo_2013) }

    before do
      item_group_material = PurchaseSolicitationItemGroupMaterial.make!(:reparo_2013, :purchase_solicitations => [purchase_solicitation])

      subject.purchase_solicitation_item_group_materials << item_group_material
    end

    it "should not allow group annulled purchase solicitation" do
      purchase_solicitation.annul!

      subject.valid?

      expect(subject.errors[:purchase_solicitations]).to include "a solicitação de compras (1/2013 1 - Secretaria de Educação - RESP: Gabriel Sobrinho) não está liberada, pendente ou parcialmente preenchida."
    end

    it "should allow group pending purchase solicitation" do
      purchase_solicitation.pending!

      subject.valid?

      expect(subject.errors[:purchase_solicitations]).to include "a solicitação de compras (1/2013 1 - Secretaria de Educação - RESP: Gabriel Sobrinho) não está liberada, pendente ou parcialmente preenchida."
    end

    it "should allow group liberated purchase solicitation" do
      purchase_solicitation.liberate!

      subject.valid?

      expect(subject.errors[:purchase_solicitations]).to_not include "a solicitação de compras (1/2013 1 - Secretaria de Educação - RESP: Gabriel Sobrinho) não está liberada, pendente ou parcialmente preenchida."
    end

    it "should allow group partially fulfilled purchase solicitation" do
      purchase_solicitation.partially_fulfilled!

      subject.valid?

      expect(subject.errors[:purchase_solicitations]).to_not include "a solicitação de compras (1/2013 1 - Secretaria de Educação - RESP: Gabriel Sobrinho) não está liberada, pendente ou parcialmente preenchida."
    end
  end
end
