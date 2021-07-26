require 'spec_helper'

describe LicitationProcessRatificationsController, vcr: { cassette_name: 'controllers/licitation_process_ratifications' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)

    UnicoAPI::Consumer.set_customer customer
  end

  it 'uses current date as default value for date fields' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    get :new, :licitation_process_id => licitation_process.id

    expect(assigns(:licitation_process_ratification).ratification_date).to eq Date.current
    expect(assigns(:licitation_process_ratification).adjudication_date).to eq Date.current
    expect(assigns(:licitation_process_ratification).licitation_process).to eq licitation_process
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
      LicitationProcess.any_instance.should_receive(:update_status).with(PurchaseProcessStatus::APPROVED)
      PurchaseProcessFractionationCreator.should_receive(:create!).with(licitation_process)

      post :create, :licitation_process_ratification => {
        :licitation_process_id => licitation_process.id }
    end
  end

  describe 'PUT #update' do
    it "should create the fractionation" do
      ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador)

      PurchaseProcessFractionationCreator.should_receive(:create!).with(ratification.licitation_process)

      put :update, id: ratification.id, licitation_process_ratification: {}
    end
  end

  describe 'DELETE #destroy' do
    it "should create the fractionation" do
      ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador)

      PurchaseProcessFractionationCreator.should_receive(:create!).with(ratification.licitation_process)

      delete :destroy, id: ratification.id
    end
  end
end
