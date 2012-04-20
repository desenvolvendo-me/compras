require 'spec_helper'

describe LicitationProcessesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'should assign the process' do
    LicitationProcess.any_instance.stub(:next_process).and_return(2)

    post :create

    assigns(:licitation_process).process.should eq 2
  end

  it 'should assign the licitation number' do
    LicitationProcess.any_instance.stub(:licitation_number).and_return(2)

    post :create

    assigns(:licitation_process).licitation_number.should eq 2
  end
end
