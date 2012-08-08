require 'spec_helper'

describe LicitationNoticesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'GET #new' do
    it 'uses current date as default value for date' do
      get :new

      expect(assigns(:licitation_notice).date).to eq Date.current
    end
  end

  context 'POST #create' do
    it 'should assign the licitation notice number' do
      LicitationNotice.any_instance.stub(:next_number).and_return(2)

      post :create

      expect(assigns(:licitation_notice).number).to eq 2
    end
  end
end
