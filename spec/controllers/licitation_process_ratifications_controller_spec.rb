require 'spec_helper'

describe LicitationProcessRatificationsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  it 'uses current date as default value for date fields' do
    get :new

    expect(assigns(:licitation_process_ratification).ratification_date).to eq Date.current
    expect(assigns(:licitation_process_ratification).adjudication_date).to eq Date.current
  end

  it 'should not allow destroy' do
    expect { delete :destroy, :id => 1 }.to raise_exception(ActionController::RoutingError)
  end

  it 'should render report layout on #show' do
    ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador)

    get :show, :id => ratification.id

    expect(response).to render_template('layout')
  end

  describe 'POST #create' do
    it "should change the status of licitation_process to 'approved'" do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

      LicitationProcessRatification.any_instance.should_receive(:save).and_return(true)
      LicitationProcess.any_instance.should_receive(:update_status).with(LicitationProcessStatus::APPROVED)
      AdministrativeProcess.any_instance.should_receive(:update_status).with(AdministrativeProcessStatus::APPROVED)

      post :create, :licitation_process_ratification => {
        :licitation_process_id => licitation_process.id }
    end
  end
end
