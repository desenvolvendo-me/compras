require 'spec_helper'

describe AdministrativeProcessesController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'GET #new' do
    it 'uses waiting as default value for status' do
      get :new

      assigns(:administrative_process).status.should eq AdministrativeProcessStatus::WAITING
    end

    it 'uses current date as default value for date' do
      get :new

      assigns(:administrative_process).date.should eq Date.current
    end

    it 'uses current year as default value for year' do
      get :new

      assigns(:administrative_process).year.should eq Date.current.year
    end

    it 'uses current employee as default value for employee' do
      get :new

      assigns(:administrative_process).responsible.should eq controller.current_user.employee
    end
  end

  context 'POST #create' do
    it 'uses waiting as default value for status' do
      post :create

      assigns(:administrative_process).status.should eq AdministrativeProcessStatus::WAITING
    end
  end

  describe "PUT #update" do
    it 'should redirect to edit when administrative process status is not waiting' do
      administrative_process = AdministrativeProcess.make!(:compra_liberada)

      put :update, :id => administrative_process.id

      response.should redirect_to(edit_administrative_process_path(administrative_process.id))
    end

    it 'should update when administrative process status is waiting' do
      administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

      put :update, :id => administrative_process.id

      response.should redirect_to(administrative_processes_path)
    end

    it "should release an administrative process with status waiting" do
      administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

      put :update, :id => administrative_process.id, :commit => 'Liberar'

      assigns(:administrative_process).status.should eq AdministrativeProcessStatus::RELEASED
    end

    it "should not release an administrative process without status waiting" do
      administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

      put :update, :id => administrative_process.id

      assigns(:administrative_process).status.should eq AdministrativeProcessStatus::WAITING
    end

    it "should calcel an administrative process with status waiting" do
      administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

      put :update, :id => administrative_process.id, :commit => 'Anular'

      assigns(:administrative_process).status.should eq AdministrativeProcessStatus::CANCELED
    end

    it "should not cancel an administrative process without status waiting" do
      administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

      put :update, :id => administrative_process.id

      assigns(:administrative_process).status.should eq AdministrativeProcessStatus::WAITING
    end
  end
end
