# encoding: utf-8
require 'spec_helper'

describe PurchaseSolicitationItemGroup do
  describe '#purchase_solicitation_status' do
    it "should not allow group annulled purchase solicitation" do
      purchase_solicitation_annulled = PurchaseSolicitation.make!(:reparo_2013_anulado)

      subject.purchase_solicitations = [purchase_solicitation_annulled]

      subject.valid?

      expect(subject.errors[:purchase_solicitations]).to include "a solicitação de compras (1/2013 1 - Secretaria de Educação - RESP: Gabriel Sobrinho) não está liberada, pendente ou parcialmente preenchida."
    end

    it "should allow group pending purchase solicitation" do
      purchase_solicitation_pending = PurchaseSolicitation.make!(:reparo)

      subject.purchase_solicitations = [purchase_solicitation_pending]

      subject.valid?

      expect(subject.errors[:purchase_solicitations]).to_not include "a solicitação de compras (1/2013 1 - Secretaria de Educação - RESP: Gabriel Sobrinho) não está liberada, pendente ou parcialmente preenchida."
    end

    it "should allow group liberated purchase solicitation" do
      purchase_solicitation_liberated = PurchaseSolicitation.make!(:reparo, :service_status => PurchaseSolicitationServiceStatus::LIBERATED)

      subject.purchase_solicitations = [purchase_solicitation_liberated]

      subject.valid?

      expect(subject.errors[:purchase_solicitations]).to_not include "a solicitação de compras (1/2013 1 - Secretaria de Educação - RESP: Gabriel Sobrinho) não está liberada, pendente ou parcialmente preenchida."
    end

    it "should allow group partially fulfilled purchase solicitation" do
      purchase_solicitation_partially_fulfilled = PurchaseSolicitation.make!(:reparo, :service_status => PurchaseSolicitationServiceStatus::PARTIALLY_FULFILLED)

      subject.purchase_solicitations = [purchase_solicitation_partially_fulfilled]

      subject.valid?

      expect(subject.errors[:purchase_solicitations]).to_not include "a solicitação de compras (1/2013 1 - Secretaria de Educação - RESP: Gabriel Sobrinho) não está liberada, pendente ou parcialmente preenchida."
    end
  end
end

