require 'spec_helper'

describe PledgeCategoriesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses manual as default value for source' do
    post :create

    assigns(:pledge_category).source.should eq Source::MANUAL
  end
end
