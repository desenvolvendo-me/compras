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

    it 'should assign the fulfill of purchase_solicitation_budget_allocation_item' do
      AdministrativeProcess.any_instance.stub(:transaction).and_yield
      PurchaseSolicitationBudgetAllocationItemFulfiller.any_instance.should_receive(:fulfill)

      post :create
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

      put :update, :id => administrative_process.id

      expect(response).to redirect_to(administrative_processes_path)
    end

    it "should calcel an administrative process with status waiting" do
      administrative_process = AdministrativeProcess.make!(:compra_aguardando)

      put :update, :id => administrative_process.id, :commit => 'Anular'

      expect(assigns(:administrative_process).status).to eq AdministrativeProcessStatus::ANNULLED
    end

    it "should not cancel an administrative process without status waiting" do
      administrative_process = AdministrativeProcess.make!(:compra_aguardando)

      put :update, :id => administrative_process.id

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
  end
end
