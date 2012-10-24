require 'spec_helper'

describe TradingsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses current year as default value for year' do
    get :new

    expect(assigns(:trading).year).to eq Date.current.year
  end
end
