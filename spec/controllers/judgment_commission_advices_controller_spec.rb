require 'spec_helper'

describe JudgmentCommissionAdvicesController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  it 'uses current year as default value for year' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    get :new, :licitation_process_id => licitation_process.id

    assigns(:judgment_commission_advice).year.should eq Date.current.year
  end
end
