#encoding: utf-8
require 'spec_helper'

describe LicitationProcessLotsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET new' do
    it 'should return 401 when licitation process is not updatable' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_nao_atualizavel)

      get :new, :licitation_process_id => licitation_process.id

      expect(response.code).to eq '401'
      expect(response.body).to have_content 'Você não tem acesso a essa página'
    end

    it 'should show new when licitation process is updatable' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      get :new, :licitation_process_id => licitation_process.id

      expect(response.code).to eq '200'
    end
  end

  describe 'POST create' do
    it 'should return 401 when licitation process is not updatable' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_nao_atualizavel)

      post :create, :licitation_process_id => licitation_process.id

      expect(response.code).to eq '401'
      expect(response.body).to have_content 'Você não tem acesso a essa página'
    end

    it 'should create when licitation process is updatable' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      post :create, :licitation_process_id => licitation_process.id

      expect(response.code).to eq '200'
    end
  end

  describe 'PUT update' do
    it 'should return 401 when licitation process is not updatable' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_nao_atualizavel)
      licitation_process_lot = licitation_process.licitation_process_lots.first

      put :update, :licitation_process_id => licitation_process.id, :id => licitation_process_lot.id

      expect(response.code).to eq '401'
      expect(response.body).to have_content 'Você não tem acesso a essa página'
    end

    it 'should update when licitation process is updatable' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)
      licitation_process_lot = licitation_process.licitation_process_lots.first

      put :update, :licitation_process_id => licitation_process.id, :id => licitation_process_lot.id

      expect(response).to redirect_to(licitation_process_lots_path(:licitation_process_id => licitation_process.id))
    end
  end

  describe 'DELETE destroy' do
    it 'should return 401 when licitation process is not updatable' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_nao_atualizavel)
      licitation_process_lot = licitation_process.licitation_process_lots.first

      delete :destroy, :licitation_process_id => licitation_process.id, :id => licitation_process_lot.id

      expect(response.code).to eq '401'
      expect(response.body).to have_content 'Você não tem acesso a essa página'
    end

    it 'should destroy when licitation process is updatable' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)
      licitation_process_lot = licitation_process.licitation_process_lots.first

      delete :destroy, :licitation_process_id => licitation_process.id, :id => licitation_process_lot.id

      expect(response).to redirect_to(licitation_process_lots_path(:licitation_process_id => licitation_process.id))
    end
  end
end
