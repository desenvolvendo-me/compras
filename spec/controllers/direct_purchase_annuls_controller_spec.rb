# encoding: utf-8
require 'spec_helper'

describe DirectPurchaseAnnulsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'POST #create' do
    it 'should annul the direct_purchase' do
      direct_purchase = DirectPurchase.make!(:compra)
      DirectPurchaseAnnulment.any_instance.should_receive(:annul)
      ResourceAnnul.any_instance.should_receive(:annullable).at_least(:once).and_return(direct_purchase)

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
