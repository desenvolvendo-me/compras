# encoding: utf-8
require 'spec_helper'

describe LicitationProcessesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'should assign the process' do
    LicitationProcess.any_instance.stub(:next_process).and_return(2)

    post :create

    assigns(:licitation_process).process.should eq 2
  end

  it 'should assign the licitation number' do
    LicitationProcess.any_instance.stub(:licitation_number).and_return(2)

    post :create

    assigns(:licitation_process).licitation_number.should eq 2
  end

  describe 'PUT #update' do
    it 'should not update any field when publication is not [extension, edital, edital_rectification]' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_publicacao_cancelada)

      put :update, :id => licitation_process.id, :licitation_process => { :object_description => "Descrição do objeto" }

      licitation_process = LicitationProcess.find(licitation_process.id)

      licitation_process.object_description.should eq 'Descricao'
    end

    it 'should update any field when has not publication or when publication is [extension, edital, edital_rectification' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      put :update, :id => licitation_process.id, :licitation_process => { :object_description => "Descrição do objeto" }

      licitation_process = LicitationProcess.find(licitation_process.id)

      licitation_process.object_description.should eq 'Descrição do objeto'
    end
  end
end
