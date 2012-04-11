require 'spec_helper'

describe LicitationProcessAppealsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'GET #new' do
    it 'uses pending as default value for situation' do
      get :new

      assigns(:licitation_process_appeal).situation.should eq Situation::PENDING
    end
  end
end
