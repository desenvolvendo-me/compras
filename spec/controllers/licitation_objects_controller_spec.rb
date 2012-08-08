require 'spec_helper'

describe LicitationObjectsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  it 'totals should be created with zero' do
    get :new

    expect(assigns(:licitation_object).purchase_licitation_exemption).to eq 0.00
    expect(assigns(:licitation_object).purchase_invitation_letter).to eq 0.00
    expect(assigns(:licitation_object).purchase_taking_price).to eq 0.00
    expect(assigns(:licitation_object).purchase_public_concurrency).to eq 0.00
    expect(assigns(:licitation_object).build_licitation_exemption).to eq 0.00
    expect(assigns(:licitation_object).build_invitation_letter).to eq 0.00
    expect(assigns(:licitation_object).build_taking_price).to eq 0.00
    expect(assigns(:licitation_object).build_public_concurrency).to eq 0.00
    expect(assigns(:licitation_object).special_auction).to eq 0.00
    expect(assigns(:licitation_object).special_unenforceability).to eq 0.00
    expect(assigns(:licitation_object).special_contest).to eq 0.00
  end

  it 'totals should be updated with zero' do
    post :create

    expect(assigns(:licitation_object).purchase_licitation_exemption).to eq 0.00
    expect(assigns(:licitation_object).purchase_invitation_letter).to eq 0.00
    expect(assigns(:licitation_object).purchase_taking_price).to eq 0.00
    expect(assigns(:licitation_object).purchase_public_concurrency).to eq 0.00
    expect(assigns(:licitation_object).build_licitation_exemption).to eq 0.00
    expect(assigns(:licitation_object).build_invitation_letter).to eq 0.00
    expect(assigns(:licitation_object).build_taking_price).to eq 0.00
    expect(assigns(:licitation_object).build_public_concurrency).to eq 0.00
    expect(assigns(:licitation_object).special_auction).to eq 0.00
    expect(assigns(:licitation_object).special_unenforceability).to eq 0.00
    expect(assigns(:licitation_object).special_contest).to eq 0.00
  end
end
