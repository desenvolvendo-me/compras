#encoding: utf-8
require 'spec_helper'

describe LicitationProcessesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context "with administrative process that does not allow licitation_process" do
    let :administrative_process do
      AdministrativeProcess.make!(:maior_lance_por_itens)
    end

    it 'should return 401 on access new url' do
      get :new, :administrative_process_id => administrative_process.id

      expect(response.code).to eq "401"
    end

    it 'should return 401 on access create url' do
      post :create, :licitation_process => { :administrative_process_id => administrative_process.id }

      expect(response.code).to eq "401"
    end
  end

  context "with administrative process" do
    let :purchase_solicitation do
      PurchaseSolicitation.make!(:reparo)
    end

    let(:administrative_process) do
      AdministrativeProcess.make!(:compra_com_itens,
        :purchase_solicitation => purchase_solicitation)
    end

    it 'uses current year as default value for year' do
      get :new, :administrative_process_id => administrative_process.id

      expect(assigns(:licitation_process).year).to eq Date.current.year
    end

    it 'uses delivery location from purchase_solicitation year as default value for delivery location' do
      get :new, :administrative_process_id => administrative_process.id

      expect(assigns(:licitation_process).delivery_location).to eq purchase_solicitation.delivery_location
    end

    it 'uses current year as default value for judgment form' do
      get :new, :administrative_process_id => administrative_process.id

      expect(assigns(:licitation_process).judgment_form.description).to eq 'Por Item com Melhor Técnica'
    end

    it 'uses current date as default value for process_date' do
      get :new, :administrative_process_id => administrative_process.id

      expect(assigns(:licitation_process).process_date).to eq Date.current
    end

    it 'uses waiting_for_open default value for status' do
      get :new, :administrative_process_id => administrative_process.id

      expect(assigns(:licitation_process).status).to eq LicitationProcessStatus::WAITING_FOR_OPEN
    end

    it 'should assign waiting_for_open default value for status' do
      post :create, :licitation_process => { :id => 1, :administrative_process_id => administrative_process.id }

      expect(assigns(:licitation_process).status).to eq LicitationProcessStatus::WAITING_FOR_OPEN
    end

    it 'should assign the licitation number' do
      LicitationProcess.any_instance.stub(:administrative_process).and_return(administrative_process)
      LicitationProcess.any_instance.stub(:licitation_number).and_return(2)

      post :create, :licitation_process => { :administrative_process_id => administrative_process.id, :delivery_location_id => delivery_location.id }

      expect(assigns(:licitation_process).licitation_number).to eq 2
    end

    it 'should update delivery_location of purchase_solicitation' do
      delivery_location = DeliveryLocation.make!(:education)

      LicitationProcess.any_instance.should_receive(:transaction).and_yield
      LicitationProcess.any_instance.should_receive(:save).and_return(true)
      LicitationProcess.any_instance.should_receive(:to_param).and_return("1")

      DeliveryLocationChanger.should_receive(:change).
                              with(purchase_solicitation, delivery_location)

      post :create, :licitation_process => { :administrative_process_id => administrative_process.id, :delivery_location_id => delivery_location.id }
    end
  end

  describe 'PUT #update' do
    context "with licitation_process" do
      let :purchase_solicitation do
        PurchaseSolicitation.make!(:reparo)
      end

      let(:administrative_process) do
        AdministrativeProcess.make!(:compra_com_itens,
          :purchase_solicitation => purchase_solicitation)
      end

      let :licitation_process do
        LicitationProcess.make!(:processo_licitatorio,
          :administrative_process => administrative_process,
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
        put :update, :id => licitation_process.id

        expect(response).to redirect_to(edit_licitation_process_path(licitation_process, :administrative_process_id => licitation_process.administrative_process_id))
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
  end

  context 'GET #show' do
    it 'should render report layout' do
      get :show, :id => 1

      expect(response).to render_template("layouts/report")
    end
  end
end
