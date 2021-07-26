require 'spec_helper'

describe LicitationProcessesController, vcr: { cassette_name: 'controllers/licitation_processes' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
    BudgetStructure.stub(:find)
    Prefecture.make!(:belo_horizonte)

    UnicoAPI::Consumer.set_customer customer
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

    it 'uses average_price default value for purchase solicitation import option' do
      get :new

      expect(assigns(:licitation_process).purchase_solicitation_import_option).to eq PurchaseSolicitationImportOption::AVERAGE_PRICE
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

    it 'should create the fractionation' do
      LicitationProcess.any_instance.should_receive(:transaction).and_yield
      LicitationProcess.any_instance.should_receive(:save).and_return true
      LicitationProcess.any_instance.stub(:id).and_return 1
      PurchaseProcessFractionationCreator.should_receive(:create!)

      post :create, licitation_process: { id: 1 }
    end
  end

  describe 'PUT #update' do
    context "with licitation_process" do
      let :purchase_solicitation do
        ListPurchaseSolicitation.make!(:principal)
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

      it 'should redirect to administrative process edit page after update' do
        put :update, :id => licitation_process.id, :licitation_process => {}

        expect(response).to redirect_to(edit_licitation_process_path(licitation_process))
      end

      it 'should create the fractionation' do
        PurchaseProcessFractionationCreator.should_receive(:create!).with(licitation_process)

        put :update, :id => licitation_process.id, :licitation_process => {}
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
