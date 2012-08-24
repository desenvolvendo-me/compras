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
    let :administrative_process do
      AdministrativeProcess.make!(:compra_de_cadeiras)
    end

    it 'uses current year as default value for year' do
      get :new, :administrative_process_id => administrative_process.id

      expect(assigns(:licitation_process).year).to eq Date.current.year
    end

    it 'uses current year as default value for judgment form' do
      get :new, :administrative_process_id => administrative_process.id

      expect(assigns(:licitation_process).judgment_form.description).to eq 'Forma Global com Menor Preço'
    end

    it 'uses current date as default value for process_date' do
      get :new, :administrative_process_id => administrative_process.id

      expect(assigns(:licitation_process).process_date).to eq Date.current
    end

    it 'should assign the process' do
      LicitationProcess.any_instance.stub(:administrative_process).and_return(administrative_process)
      LicitationProcess.any_instance.stub(:next_process).and_return(2)

      post :create, :licitation_process => { :administrative_process_id => administrative_process.id }

      expect(assigns(:licitation_process).process).to eq 2
    end

    it 'should assign the licitation number' do
      LicitationProcess.any_instance.stub(:administrative_process).and_return(administrative_process)
      LicitationProcess.any_instance.stub(:licitation_number).and_return(2)

      post :create, :licitation_process => { :administrative_process_id => administrative_process.id }

      expect(assigns(:licitation_process).licitation_number).to eq 2
    end
  end

  describe 'PUT #update' do
    let :licitation_process do
      double(:licitation_process,
             :id => 1
      )
    end

    context "with licitation_process" do
      let :licitation_process do
        LicitationProcess.make!(:processo_licitatorio, :type_of_calculation => LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE)
      end

      let :licitation_process_classifications do
        [double('LicitationProcessClassification', :classifiable_id => 1, :classifiable_type => 'LicitationProcessBidder', :classification => 1),
         double('LicitationProcessClassification', :classifiable_id => 1, :classifiable_type => 'LicitationProcessBidder', :classification => 2)]
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

        put :update, :id => licitation_process.id, :licitation_process => { :observations => "Descrição do objeto" }

        expect(assigns(:licitation_process).observations).to eq 'Descrição do objeto'
      end

      it 'should redirect to administrative process edit page after update' do
        put :update, :id => licitation_process.id

        expect(response).to redirect_to(edit_administrative_process_path(licitation_process.administrative_process))
      end

      it 'delete classifications e call classification generator' do
        LicitationProcess.stub(:find).and_return(licitation_process)
        licitation_process.should_receive(:transaction).and_yield

        LicitationProcessClassificationGenerator.any_instance.should_receive(:generate!)

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
