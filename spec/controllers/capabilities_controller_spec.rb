require 'spec_helper'

describe CapabilitiesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses manual as default value for source' do
    post :create

    assigns(:capability).source.should eq Source::MANUAL
  end
end
