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
    it 'should assign the fulfill of purchase_solicitation_budget_allocation_item' do
      DirectPurchase.any_instance.stub(:transaction).and_yield
      DirectPurchase.any_instance.stub(:save).and_return(true)

      PurchaseSolicitationBudgetAllocationItemFulfiller.any_instance.should_receive(:fulfill)

      post :create
    end

    it 'updates the status of a purchase solicitation through PurchaseSoliciationProcess' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo)

      DirectPurchase.any_instance.stub(:save).and_return(true)
      PurchaseSolicitationProcess.should_receive(:update_solicitations_status).with(nil, purchase_solicitation)

      post :create, :direct_purchase => { :purchase_solicitation_id => purchase_solicitation.id }
    end

    it 'updates the status of the item group through PurchaseSoliciationItemGroupProcess' do
      item_group = PurchaseSolicitationItemGroup.make!(:antivirus)

      DirectPurchase.any_instance.stub(:save).and_return(true)
      PurchaseSolicitationItemGroupProcess.should_receive(:update_item_group_status).with(nil, item_group)

      post :create, :direct_purchase => { :purchase_solicitation_item_group_id => item_group.id }
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
      it "should set the new purchase_solicitation throught a PurchaseSolicitationProcess" do
        purchase_solicitation = PurchaseSolicitation.make!(:reparo)
        DirectPurchaseBudgetAllocationCleaner.should_receive(:clear_old_records)

        PurchaseSolicitationProcess.should_receive(:update_solicitations_status).
                                    with(direct_purchase.purchase_solicitation, purchase_solicitation)

        put :update, :id => direct_purchase.id,
                     :direct_purchase => { :purchase_solicitation_id => purchase_solicitation.id }
      end

      it "should set the new item_group throught a PurchaseSolicitationItemGroupProcess" do
        item_group = PurchaseSolicitationItemGroup.make!(:antivirus)

        DirectPurchaseBudgetAllocationCleaner.should_receive(:clear_old_records)

        PurchaseSolicitationItemGroupProcess.
          should_receive(:update_item_group_status).
          with(direct_purchase.purchase_solicitation_item_group, item_group)

        put :update, :id => direct_purchase.id,
                     :direct_purchase => { :purchase_solicitation_item_group_id => item_group.id }
      end
    end
  end
end
