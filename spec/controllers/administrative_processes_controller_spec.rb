require 'spec_helper'

describe AdministrativeProcessesController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'GET #new' do
    it 'uses waiting as default value for status' do
      get :new

      expect(assigns(:administrative_process).status).to eq AdministrativeProcessStatus::WAITING
    end

    it 'uses current date as default value for date' do
      get :new

      expect(assigns(:administrative_process).date).to eq Date.current
    end

    it 'uses current year as default value for year' do
      get :new

      expect(assigns(:administrative_process).year).to eq Date.current.year
    end

    it 'uses current employee as default value for employee' do
      get :new

      expect(assigns(:administrative_process).responsible).to eq controller.current_user.authenticable
    end
  end

  context 'POST #create' do
    it 'uses waiting as default value for status' do
      post :create

      expect(assigns(:administrative_process).status).to eq AdministrativeProcessStatus::WAITING
    end

    it 'should update item_group status and fullfil the item' do
      item_group = PurchaseSolicitationItemGroup.make!(:antivirus)
      item_group_process = double(:item_group_process)

      AdministrativeProcess.any_instance.should_receive(:transaction).and_yield
      AdministrativeProcess.any_instance.should_receive(:save).and_return(true)

      PurchaseSolicitationItemGroupProcess.
        should_receive(:new).
        with(:new_item_group => item_group).
        and_return(item_group_process)

      item_group_process.should_receive(:update_status)

      PurchaseSolicitationBudgetAllocationItemFulfiller.
        any_instance.should_receive(:fulfill)

      AdministrativeProcessBudgetAllocationCloner.should_receive(:clone)

      post :create, :administrative_process => {
        :purchase_solicitation_item_group_id => item_group.id }
    end

    it 'should updates the status of purchase_solicitation to in_purchase_process' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo)

      AdministrativeProcess.any_instance.should_receive(:transaction).and_yield
      AdministrativeProcess.any_instance.should_receive(:save).and_return(true)

      PurchaseSolicitationProcess.
        should_receive(:update_solicitations_status).
        with(purchase_solicitation)

      post :create, :administrative_process => {
        :purchase_solicitation_id => purchase_solicitation.id }
    end
  end

  describe "PUT #update" do
    it 'should redirect to edit when administrative process status is not waiting' do
      administrative_process = AdministrativeProcess.make!(:compra_liberada)

      put :update, :id => administrative_process.id

      expect(response).to redirect_to(edit_administrative_process_path(administrative_process.id))
    end

    it 'should update when administrative process status is waiting' do
      administrative_process = AdministrativeProcess.make!(:compra_aguardando)

      put :update, :id => administrative_process.id, :administrative_process => {}

      expect(response).to redirect_to(administrative_processes_path)
    end

    it "should calcel an administrative process with status waiting" do
      administrative_process = AdministrativeProcess.make!(:compra_aguardando)

      AdministrativeProcessAnnulment.any_instance.should_receive(:annul)

      put :update, :id => administrative_process.id, :commit => 'Anular'
    end

    it "should not cancel an administrative process without status waiting" do
      administrative_process = AdministrativeProcess.make!(:compra_aguardando)

      put :update, :id => administrative_process.id, :administrative_process => {}

      expect(assigns(:administrative_process).status).to eq AdministrativeProcessStatus::WAITING
    end

    it 'should clear old budget_allocations' do
      administrative_process = AdministrativeProcess.make!(:compra_aguardando)
      item_group = PurchaseSolicitationItemGroup.make!(:antivirus)

      AdministrativeProcessBudgetAllocationCleaner.any_instance.
                                                   should_receive(:clear_old_records)

      put :update, :id => administrative_process.id,
                   :administrative_process => { :purchase_solicitation_item_group_id => item_group.id }
    end

    it 'should update purchase_solicitation fulfiller if has item group' do
      administrative_process = AdministrativeProcess.make!(:compra_aguardando)
      item_group = PurchaseSolicitationItemGroup.make!(:antivirus)
      fulfiller_instance = double(:fulfiller_instance)
      item_group_process = double(:item_group_process)

      fulfiller_instance.should_receive(:fulfill).twice

      PurchaseSolicitationBudgetAllocationItemFulfiller.
        should_receive(:new).
        with(nil).
        and_return(fulfiller_instance)

      PurchaseSolicitationBudgetAllocationItemFulfiller.
        should_receive(:new).
        with(item_group, administrative_process).
        and_return(fulfiller_instance)

      AdministrativeProcessBudgetAllocationCleaner.any_instance.
                                                   should_receive(:clear_old_records)

      PurchaseSolicitationItemGroupProcess.
        should_receive(:new).
        with(:new_item_group => item_group, :old_item_group => administrative_process.purchase_solicitation_item_group).
        and_return(item_group_process)

      AdministrativeProcessBudgetAllocationCloner.should_receive(:clone)

      item_group_process.should_receive(:update_status)

      put :update, :id => administrative_process.id,
                   :administrative_process => { :purchase_solicitation_item_group_id => item_group.id }
    end

    it 'should updates the status of purchase_solicitation to in_purchase_process' do
      administrative_process = AdministrativeProcess.make!(:compra_aguardando)
      purchase_solicitation = PurchaseSolicitation.make!(:reparo)

      PurchaseSolicitationProcess.
        should_receive(:update_solicitations_status).
        with(purchase_solicitation, administrative_process.purchase_solicitation)

      put :update, :id => administrative_process.id, :administrative_process => {
        :purchase_solicitation_id => purchase_solicitation.id }
    end
  end
end
