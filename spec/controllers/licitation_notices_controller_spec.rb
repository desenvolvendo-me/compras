require 'spec_helper'

describe LicitationNoticesController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'GET #new' do
    it 'uses current date as default value for date' do
      get :new

      assigns(:licitation_notice).date.should eq Date.current
    end
  end

  context 'POST #create' do
    it 'should assign the licitation notice number' do
      LicitationNotice.any_instance.stub(:next_number).and_return(2)

      post :create

      assigns(:licitation_notice).number.should eq 2
    end
  end
end
