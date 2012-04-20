require 'spec_helper'

describe AccreditationsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET #new' do
    it 'should redirect to edit when accreditation already exists' do
      accreditation = Accreditation.make!(:credenciamento)

      get :new, :licitation_process_id => accreditation.licitation_process.id

      response.should redirect_to(edit_licitation_process_accreditation_path(accreditation.licitation_process.id))
    end
  end

  describe 'GET #edit' do
    it 'should redirect to new when accreditation does not exist' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      get :edit, :licitation_process_id => licitation_process.id

      response.should redirect_to(new_licitation_process_accreditation_path(licitation_process.id))
    end
  end

  describe 'POST #create' do
    it 'should redirect to current accreditation edit link when created successful' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)
      licitation_commission = LicitationCommission.make!(:comissao)

      post :create, 
           :accreditation => {
             :licitation_process_id => licitation_process.id,
             :licitation_commission_id => licitation_commission.id
           },
           :licitation_process_id => licitation_process.id

      response.should redirect_to(edit_licitation_process_accreditation_path(licitation_process.id))
    end
  end

  describe 'PUT #update' do
    it 'should redirect to current accreditation edit link when updated successful' do
      accreditation = Accreditation.make!(:credenciamento)

      put :update, :licitation_process_id => accreditation.licitation_process.id

      response.should redirect_to(edit_licitation_process_accreditation_path(accreditation.licitation_process.id))
    end
  end

  describe 'DELETE #destroy' do
    it 'should redirect to current accreditation edit link' do
      accreditation = Accreditation.make!(:credenciamento)
      licitation_process_id = accreditation.licitation_process_id

      delete :destroy, :licitation_process_id => accreditation.licitation_process.id

      response.should redirect_to(edit_licitation_process_path(licitation_process_id))
    end
  end
end
