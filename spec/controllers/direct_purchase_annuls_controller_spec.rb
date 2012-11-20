# encoding: utf-8
require 'spec_helper'

describe DirectPurchaseAnnulsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'POST #create' do
    it 'should annul the direct_purchase and liberate a purchase solicitation' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo_2013)
      purchase_solicitation_liberate_instance = double(:purchase_solicitation_liberate_instance)

      direct_purchase = DirectPurchase.make!(:compra, :purchase_solicitation => purchase_solicitation)
      DirectPurchaseAnnulment.any_instance.should_receive(:annul)
      ResourceAnnul.any_instance.should_receive(:annullable).at_least(:once).and_return(direct_purchase)
      PurchaseSolicitationLiberate.should_receive(:new).with(direct_purchase.purchase_solicitation).and_return(purchase_solicitation_liberate_instance)
      purchase_solicitation_liberate_instance.should_receive(:liberate!)

      post :create, :annullable => direct_purchase
    end

    it 'should send the annulment email' do
      Prefecture.make!(:belo_horizonte)
      employee = Employee.make!(:sobrinho)
      supply_authorization = SupplyAuthorization.make!(:compra_2012)
      direct_purchase = supply_authorization.direct_purchase

      post :create, :direct_purchase_annul => {
        :annullable_id => direct_purchase.id,
        :annullable_type => 'DirectPurchase',
        :date => '09/10/2012',
        :employee_id => employee.id
      }

      expect(ActionMailer::Base.deliveries.first.subject).to eq 'Anulação da autorização de fornecimento'
    end
  end
end
