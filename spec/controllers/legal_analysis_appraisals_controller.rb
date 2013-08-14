require 'spec_helper'

describe LegalAnalysisAppraisalsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET new' do
    it 'assert default values' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

      get :new, :licitation_process_id => licitation_process.id

      expect(assigns(:legal_analysis_appraisal).licitation_process).to eq licitation_process
    end
  end
end
