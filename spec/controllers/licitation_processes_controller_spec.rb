#encoding: utf-8
require 'spec_helper'

describe LicitationProcessesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe "GET #new" do
    it 'uses current year as default value for year' do
      get :new

      expect(assigns(:licitation_process).year).to eq Date.current.year
    end

    it 'uses current date as default value for process_date' do
      get :new

      expect(assigns(:licitation_process).process_date).to eq Date.current
    end

    it 'uses waiting_for_open default value for status' do
      get :new

      expect(assigns(:licitation_process).status).to eq LicitationProcessStatus::WAITING_FOR_OPEN
    end
  end

  describe 'POST #create' do
    it 'should assign waiting_for_open default value for status' do
      post :create, :licitation_process => { :id => 1 }

      expect(assigns(:licitation_process).status).to eq LicitationProcessStatus::WAITING_FOR_OPEN
    end

    it 'should assign the licitation number' do
      LicitationProcess.any_instance.stub(:licitation_number).and_return(2)

      post :create

      expect(assigns(:licitation_process).licitation_number).to eq 2
    end

    it 'should update delivery_location of purchase_solicitation' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo)
      delivery_location = DeliveryLocation.make!(:education)

      LicitationProcess.any_instance.should_receive(:transaction).and_yield
      LicitationProcess.any_instance.should_receive(:save).and_return(true)
      LicitationProcess.any_instance.should_receive(:to_param).and_return("1")

      DeliveryLocationChanger.should_receive(:change).
                              with(purchase_solicitation, delivery_location)

      post :create, :licitation_process => {
        :purchase_solicitation_id => purchase_solicitation.id,
        :delivery_location_id => delivery_location.id }
    end

    it 'should update item_group status and fullfil the item' do
      item_group = PurchaseSolicitationItemGroup.make!(:antivirus)
      item_group_process = double(:item_group_process)

      LicitationProcess.any_instance.should_receive(:transaction).and_yield
      LicitationProcess.any_instance.should_receive(:save).and_return(true)
      LicitationProcess.any_instance.should_receive(:id).any_number_of_times.and_return(1)

      PurchaseSolicitationItemGroupProcess.
        should_receive(:new).
        with(:new_item_group => item_group).
        and_return(item_group_process)

      item_group_process.should_receive(:update_status)

      PurchaseSolicitationBudgetAllocationItemFulfiller.
        any_instance.should_receive(:fulfill)

      AdministrativeProcessBudgetAllocationCloner.should_receive(:clone)
      AdministrativeProcessItemGroupCloner.should_receive(:clone)

      post :create, :licitation_process => {
        :purchase_solicitation_item_group_id => item_group.id }
    end

    it 'should change budget allocation items status with purchase solicitation' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo)

      LicitationProcess.any_instance.should_receive(:transaction).and_yield
      LicitationProcess.any_instance.should_receive(:save).and_return(true)
      LicitationProcess.any_instance.should_receive(:id).any_number_of_times.and_return(1)

      item_status_changer = double(:item_status_changer)
      item_status_changer.should_receive(:change).once

      PurchaseSolicitationBudgetAllocationItemStatusChanger.
        should_receive(:new).
        and_return(item_status_changer)

      post :create, :licitation_process => {
           :purchase_solicitation_id => purchase_solicitation.id }
    end

    it 'should updates the status of purchase_solicitation to in_purchase_process' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo)

      LicitationProcess.any_instance.should_receive(:transaction).and_yield
      LicitationProcess.any_instance.should_receive(:save).and_return(true)
      LicitationProcess.any_instance.should_receive(:id).any_number_of_times.and_return(1)

      PurchaseSolicitationStatusChanger.
        should_receive(:change).
        with(purchase_solicitation)

      post :create, :licitation_process => {
           :purchase_solicitation_id => purchase_solicitation.id }
    end
  end

  describe 'PUT #update' do
    context "with licitation_process" do
      let :purchase_solicitation do
        PurchaseSolicitation.make!(:reparo)
      end

      let :licitation_process do
        LicitationProcess.make!(:processo_licitatorio,
          :purchase_solicitation => purchase_solicitation,
          :delivery_location => purchase_solicitation.delivery_location)
      end

      let :licitation_process_classifications do
        [double('LicitationProcessClassification', :classifiable_id => 1, :classifiable_type => 'Bidder', :classification => 1),
         double('LicitationProcessClassification', :classifiable_id => 1, :classifiable_type => 'Bidder', :classification => 2)]
      end

      before do
        licitation_process.stub(:all_licitation_process_classifications => licitation_process_classifications)
      end

      it 'should not update any field when publication not allow update licitation process' do
        LicitationProcess.any_instance.stub(:updatable?).and_return(false)

        put :update, :id => licitation_process.to_param, :licitation_process => { :observations => "Descrição do objeto" }

        expect(assigns(:licitation_process).observations).to eq 'observacoes'
      end

      it 'should update any field when has not publication or when publication allow update licitation process' do
        LicitationProcess.any_instance.stub(:updatable?).and_return(true)

        DeliveryLocationChanger.should_receive(:change).
                                with(purchase_solicitation, licitation_process.delivery_location)

        put :update, :id => licitation_process.id, :licitation_process => { :observations => "Descrição do objeto" }

        expect(assigns(:licitation_process).observations).to eq 'Descrição do objeto'
      end

      it 'should redirect to administrative process edit page after update' do
        put :update, :id => licitation_process.id, :licitation_process => {}

        expect(response).to redirect_to(edit_licitation_process_path(licitation_process))
      end

      it 'delete classifications and call classification generator' do
        LicitationProcess.stub(:find).and_return(licitation_process)
        licitation_process.should_receive(:transaction).and_yield

        LicitationProcessClassificationGenerator.any_instance.should_receive(:generate!)
        LicitationProcessClassificationSituationGenerator.any_instance.should_receive(:generate!)
        LicitationProcessClassificationBiddersVerifier.any_instance.should_receive(:verify!)

        put :update, :id => licitation_process.id, :commit => 'Apurar'

        expect(response).to redirect_to(licitation_process_path(licitation_process))
      end
    end

    it 'should clear old budget_allocations' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)
      item_group = PurchaseSolicitationItemGroup.make!(:antivirus)

      AdministrativeProcessBudgetAllocationCleaner.any_instance.
                                                   should_receive(:clear_old_records)

      put :update, :id => licitation_process.id,
                   :licitation_process => { :purchase_solicitation_item_group_id => item_group.id }
    end

    it 'should update purchase_solicitation fulfiller if has item group' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)
      item_group = PurchaseSolicitationItemGroup.make!(:antivirus)
      fulfiller_instance = double(:fulfiller_instance)
      item_group_process = double(:item_group_process)

      fulfiller_instance.should_receive(:fulfill).twice

      PurchaseSolicitationBudgetAllocationItemFulfiller.
        should_receive(:new).
        with(:purchase_solicitation_item_group => nil).
        and_return(fulfiller_instance)

      PurchaseSolicitationBudgetAllocationItemFulfiller.
        should_receive(:new).
        with(:purchase_solicitation_item_group => item_group,
             :licitation_process => licitation_process,
             :add_fulfill => true).
        and_return(fulfiller_instance)

      PurchaseSolicitationItemGroupProcess.
        should_receive(:new).
        with(:new_item_group => item_group, :old_item_group => licitation_process.purchase_solicitation_item_group).
        and_return(item_group_process)

      AdministrativeProcessItemGroupCloner.should_receive(:clone)
      AdministrativeProcessBudgetAllocationCloner.should_receive(:clone)

      item_group_process.should_receive(:update_status)

      put :update, :id => licitation_process.id,
                   :licitation_process => { :purchase_solicitation_item_group_id => item_group.id }
    end

    it 'should change budget allocation items status with purchase solicitation' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)
      purchase_solicitation = PurchaseSolicitation.make!(:reparo)

      item_status_changer = double(:item_status_changer)
      item_status_changer.should_receive(:change).once

      PurchaseSolicitationBudgetAllocationItemStatusChanger.
        should_receive(:new).with(
          :new_purchase_solicitation => purchase_solicitation,
          :old_purchase_solicitation => nil,
          :new_purchase_solicitation_item_group => nil,
          :old_purchase_solicitation_item_group => nil,
          :licitation_process => licitation_process).
        and_return(item_status_changer)

      put :update, :id => licitation_process.id, :licitation_process => {
        :purchase_solicitation_id => purchase_solicitation.id }
    end

    it 'should change status purchase solicitation' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)
      purchase_solicitation = PurchaseSolicitation.make!(:reparo)

      PurchaseSolicitationStatusChanger.
        should_receive(:change).with(purchase_solicitation)

      PurchaseSolicitationStatusChanger.
        should_receive(:change).with(nil)

      put :update, :id => licitation_process.id, :licitation_process => {
        :purchase_solicitation_id => purchase_solicitation.id }
    end
  end

  context 'GET #show' do
    it 'should render report layout' do
      get :show, :id => 1

      expect(response).to render_template("layouts/report")
    end
  end
end
