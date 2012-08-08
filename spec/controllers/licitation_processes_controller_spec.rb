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

      assigns(:licitation_process).year.should eq Date.current.year
    end

    it 'uses current year as default value for judgment form' do
      get :new, :administrative_process_id => administrative_process.id

      assigns(:licitation_process).judgment_form.description.should eq 'Forma Global com Menor Preço'
    end

    it 'uses current date as default value for process_date' do
      get :new, :administrative_process_id => administrative_process.id

      assigns(:licitation_process).process_date.should eq Date.current
    end

    it 'should assign the process' do
      LicitationProcess.any_instance.stub(:administrative_process).and_return(administrative_process)
      LicitationProcess.any_instance.stub(:next_process).and_return(2)

      post :create, :licitation_process => { :administrative_process_id => administrative_process.id }

      assigns(:licitation_process).process.should eq 2
    end

    it 'should assign the licitation number' do
      LicitationProcess.any_instance.stub(:administrative_process).and_return(administrative_process)
      LicitationProcess.any_instance.stub(:licitation_number).and_return(2)

      post :create, :licitation_process => { :administrative_process_id => administrative_process.id }

      assigns(:licitation_process).licitation_number.should eq 2
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
        LicitationProcess.make!(:processo_licitatorio)
      end

      it 'should not update any field when publication not allow update licitation process' do
        LicitationProcess.any_instance.stub(:updatable?).and_return(false)

        put :update, :id => licitation_process.to_param, :licitation_process => { :observations => "Descrição do objeto" }

        assigns(:licitation_process).observations.should eq 'observacoes'
      end

      it 'should update any field when has not publication or when publication allow update licitation process' do
        LicitationProcess.any_instance.stub(:updatable?).and_return(true)

        put :update, :id => licitation_process.id, :licitation_process => { :observations => "Descrição do objeto" }

        assigns(:licitation_process).observations.should eq 'Descrição do objeto'
      end

      it 'should redirect to administrative process edit page after update' do
        put :update, :id => licitation_process.id

        expect(response).to redirect_to(edit_administrative_process_path(licitation_process.administrative_process))
      end
    end
  end
end
