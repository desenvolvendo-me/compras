require 'spec_helper'

describe PledgesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses current date as default value for emission date' do
    get :new

    assigns(:pledge).emission_date.should eq Date.current
  end
end
