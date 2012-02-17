require 'spec_helper'

describe CapabilitiesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses manual as default value for source' do
    get :new

    assigns(:capability).source.should eq CapabilitySource::MANUAL
  end
end
