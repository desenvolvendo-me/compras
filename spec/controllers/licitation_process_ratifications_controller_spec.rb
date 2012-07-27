require 'spec_helper'

describe LicitationProcessRatificationsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  it 'uses current date as default value for date fields' do
    get :new

    assigns(:licitation_process_ratification).ratification_date.should eq Date.current
    assigns(:licitation_process_ratification).adjudication_date.should eq Date.current
  end
end
