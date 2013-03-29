#encoding: utf-8
require 'spec_helper'

describe DirectPurchasesController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  it 'uses current employee as default value for employee' do
    get :new

    expect(assigns(:direct_purchase).employee).to eq controller.current_user.authenticable
  end

  it 'show today as default value for date' do
    get :new

    expect(assigns(:direct_purchase).date).to eq Date.current
  end

  it 'show current year as default value for year' do
    get :new

    expect(assigns(:direct_purchase).year).to eq Date.current.year
  end

  context 'POST #create' do
    context 'with purchase_solicitation' do
      let(:purchase_solicitation) { PurchaseSolicitation.make!(:reparo) }

      it 'updates the status of a purchase solicitation through PurchaseSolicitationStatusChanger' do
        DirectPurchase.any_instance.stub(:save).and_return(true)
        DirectPurchase.any_instance.stub_chain(:errors, :empty?).and_return(false)
        PurchaseSolicitationStatusChanger.should_receive(:change).with(purchase_solicitation)

        post :create, :direct_purchase => { :purchase_solicitation_id => purchase_solicitation.id }
      end
    end
  end

  context '#update' do
    let :direct_purchase do
      DirectPurchase.make!(:compra)
    end

    it 'should send e-mail to creditor on update' do
      SupplyAuthorizationEmailSender.any_instance.should_receive(:deliver)

      put :update, :id => direct_purchase.id, :commit => 'Enviar autorização de fornecimento por e-mail'
    end

    context "when updating a purchase_solicitation" do
      it "should set the new purchase_solicitation throught a PurchaseSolicitationStatusChanger" do
        purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)

        DirectPurchaseBudgetAllocationCleaner.should_receive(:clear_old_records)

        PurchaseSolicitationStatusChanger.should_receive(:change).
                                    with(purchase_solicitation)
        PurchaseSolicitationStatusChanger.should_receive(:change).
                                    with(direct_purchase.purchase_solicitation)

        put :update, :id => direct_purchase.id,
                     :direct_purchase => { :purchase_solicitation_id => purchase_solicitation.id }
      end

      it 'should update the status of pending items to attended' do
        purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)

        DirectPurchaseBudgetAllocationCleaner.should_receive(:clear_old_records)

        put :update, :id => direct_purchase.id,
            :direct_purchase => { :purchase_solicitation_id => purchase_solicitation.id }
      end
    end

    context 'without purchase_solicitation' do
      it 'should not update status of purchase solicitation' do
        DirectPurchaseBudgetAllocationCleaner.should_receive(:clear_old_records)

        put :update, :id => direct_purchase.id, :direct_purchase => {}
      end
    end
  end

  context 'when has a supply authorization' do
    let :supply_authorization do
      SupplyAuthorization.make!(:nohup)
    end

    it 'should generate a supply authorization' do
      SupplyAuthorizationGenerator.any_instance.should_receive(:generate!).
        and_return(supply_authorization)

      put :update, :id => supply_authorization.direct_purchase_id,
        :commit => 'Gerar autorização de fornecimento',
        :direct_purchase => { }
    end
  end
end
