require 'spec_helper'

describe LicitationObjectsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  it 'totals should be created with zero' do
    get :new

    assigns(:licitation_object).purchase_licitation_exemption.should eq 0.00
    assigns(:licitation_object).purchase_invitation_letter.should eq 0.00
    assigns(:licitation_object).purchase_taking_price.should eq 0.00
    assigns(:licitation_object).purchase_public_concurrency.should eq 0.00
    assigns(:licitation_object).build_licitation_exemption.should eq 0.00
    assigns(:licitation_object).build_invitation_letter.should eq 0.00
    assigns(:licitation_object).build_taking_price.should eq 0.00
    assigns(:licitation_object).build_public_concurrency.should eq 0.00
    assigns(:licitation_object).special_auction.should eq 0.00
    assigns(:licitation_object).special_unenforceability.should eq 0.00
    assigns(:licitation_object).special_contest.should eq 0.00
  end

  it 'totals should be updated with zero' do
    post :create

    assigns(:licitation_object).purchase_licitation_exemption.should eq 0.00
    assigns(:licitation_object).purchase_invitation_letter.should eq 0.00
    assigns(:licitation_object).purchase_taking_price.should eq 0.00
    assigns(:licitation_object).purchase_public_concurrency.should eq 0.00
    assigns(:licitation_object).build_licitation_exemption.should eq 0.00
    assigns(:licitation_object).build_invitation_letter.should eq 0.00
    assigns(:licitation_object).build_taking_price.should eq 0.00
    assigns(:licitation_object).build_public_concurrency.should eq 0.00
    assigns(:licitation_object).special_auction.should eq 0.00
    assigns(:licitation_object).special_unenforceability.should eq 0.00
    assigns(:licitation_object).special_contest.should eq 0.00
  end
end
