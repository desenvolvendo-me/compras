#encoding: utf-8
require 'spec_helper'

describe LicitationProcessesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses current year as default value for year' do
    administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

    get :new, :administrative_process_id => administrative_process.id

    assigns(:licitation_process).year.should eq Date.current.year
  end

  it 'uses current date as default value for process_date' do
    administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

    get :new, :administrative_process_id => administrative_process.id

    assigns(:licitation_process).process_date.should eq Date.current
  end

  it 'should assign the process' do
    administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

    LicitationProcess.any_instance.stub(:administrative_process).and_return(administrative_process)
    LicitationProcess.any_instance.stub(:next_process).and_return(2)

    post :create

    assigns(:licitation_process).process.should eq 2
  end

  it 'should assign the licitation number' do
    administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

    LicitationProcess.any_instance.stub(:administrative_process).and_return(administrative_process)
    LicitationProcess.any_instance.stub(:licitation_number).and_return(2)

    post :create

    assigns(:licitation_process).licitation_number.should eq 2
  end

  describe 'PUT #update' do
    let :licitation_process do
      double(:licitation_process,
             :id => 1,
             :object_description => 'Descricao',
      )
    end

    it 'should not update any field when publication not allow update licitation process' do
      LicitationProcess.any_instance.stub(:can_update?).and_return(false)

      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      put :update, :id => licitation_process.to_param, :licitation_process => { :object_description => "Descrição do objeto" }

      assigns(:licitation_process).object_description.should eq 'Descricao'
    end

    it 'should update any field when has not publication or when publication allow update licitation process' do
      LicitationProcess.any_instance.stub(:can_update?).and_return(true)

      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      put :update, :id => licitation_process.id, :licitation_process => { :object_description => "Descrição do objeto" }

      assigns(:licitation_process).object_description.should eq 'Descrição do objeto'
    end

    it 'should redirect to administrative process edit page after update' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      put :update, :id => licitation_process.id

      response.should redirect_to(edit_administrative_process_path(licitation_process.administrative_process))
    end
  end
end
