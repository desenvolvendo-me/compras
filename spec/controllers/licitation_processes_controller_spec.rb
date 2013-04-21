#encoding: utf-8
require 'spec_helper'

describe LicitationProcessesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe "GET #new" do
    it 'uses current date as default value for process_date' do
      get :new

      expect(assigns(:licitation_process).process_date).to eq Date.current
    end

    it 'uses waiting_for_open default value for status' do
      get :new

      expect(assigns(:licitation_process).status).to eq PurchaseProcessStatus::WAITING_FOR_OPEN
    end
  end

  describe 'POST #create' do
    it 'uses year of process_date as value for year' do
      post :create, :licitation_process => { :id => 1, :process_date => Date.current }

      expect(assigns(:licitation_process).year).to eq Date.current.year
    end

    it 'should assign waiting_for_open default value for status' do
      post :create, :licitation_process => { :id => 1 }

      expect(assigns(:licitation_process).status).to eq PurchaseProcessStatus::WAITING_FOR_OPEN
    end
  end

  describe 'PUT #update' do
    context "with licitation_process" do
      let :purchase_solicitation do
        PurchaseSolicitation.make!(:reparo)
      end

      let :licitation_process do
        LicitationProcess.make!(:processo_licitatorio, :purchase_solicitations => [purchase_solicitation])
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

        put :update, :id => licitation_process.to_param, :licitation_process => { :description => "Descrição do objeto" }

        expect(assigns(:licitation_process).description).to eq 'Licitação para compra de carteiras'
      end

      it 'should redirect to administrative process edit page after update' do
        put :update, :id => licitation_process.id, :licitation_process => {}

        expect(response).to redirect_to(edit_licitation_process_path(licitation_process))
      end

      it 'delete classifications and call classification generator' do
        LicitationProcess.stub(:find).and_return(licitation_process)
        licitation_process.should_receive(:transaction).and_yield

        PurchaseProcessClassificationGenerator.any_instance.should_receive(:generate!)
        PurchaseProcessClassificationSituationGenerator.any_instance.should_receive(:generate!)
        PurchaseProcessClassificationBiddersVerifier.any_instance.should_receive(:verify!)

        put :update, :id => licitation_process.id, :commit => 'Apurar'

        expect(response).to redirect_to(licitation_process_path(licitation_process))
      end
    end
  end

  context 'GET #show' do
    it 'should render report layout' do
      get :show, :id => 1

      expect(response).to render_template("layouts/report")
    end
  end
end
