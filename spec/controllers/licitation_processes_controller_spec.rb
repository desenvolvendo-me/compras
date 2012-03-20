require 'spec_helper'

describe LicitationProcessesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses current year as default value for year' do
    get :new

    assigns(:licitation_process).year.should eq Date.current.year
  end

  it 'uses current date as default value for process_date' do
    get :new

    assigns(:licitation_process).process_date.should eq Date.current
  end
end
