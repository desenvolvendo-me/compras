require 'spec_helper'

describe PledgeHistoricsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses manual as default value for source' do
    post :create

    expect(assigns(:pledge_historic).source).to eq Source::MANUAL
  end
end
