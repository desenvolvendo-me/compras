require 'spec_helper'

describe AdministrativeProcessLiberationsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'GET #new with administrative process waiting' do
    let :administrative_process do
      AdministrativeProcess.make!(:compra_aguardando)
    end

    before do
      get :new, :administrative_process_id => administrative_process.id
    end

    it 'uses current employee as default value for employee' do
      expect(assigns(:administrative_process_liberation).employee).to eq controller.current_user.authenticable
    end

    it 'uses current date as default date' do
      expect(assigns(:administrative_process_liberation).date).to eq Date.current
    end

    it 'associate the administrative_process from params' do
      expect(assigns(:administrative_process_liberation).administrative_process_id).to eq administrative_process.id
    end
  end

  context 'GET #new with administrative process released' do
    it 'uses current employee as default value for employee' do
      administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

      get :new, :administrative_process_id => administrative_process.id

      expect(response.code).to eq '401'
    end
  end

  context 'GET #create' do
    it 'should redirect to administrative_process after create' do
      employee = Employee.make!(:sobrinho)
      administrative_process = AdministrativeProcess.make!(:compra_aguardando)

      post :create, :administrative_process_liberation => { :administrative_process_id => administrative_process.id, :employee_id => employee.id, :date => "15/06/2012" }

      expect(assigns(:administrative_process_liberation).administrative_process.status).to eq AdministrativeProcessStatus::RELEASED

      expect(response).to redirect_to(edit_administrative_process_path(administrative_process))
    end

    it 'should redirect to administrative_process after create' do
      employee = Employee.make!(:sobrinho)
      administrative_process = AdministrativeProcess.make!(:compra_de_cadeiras)

      post :create, :administrative_process_liberation => { :administrative_process_id => administrative_process.id, :employee_id => employee.id, :date => "15/06/2012" }

      expect(response.code).to eq '401'
    end
  end
end
