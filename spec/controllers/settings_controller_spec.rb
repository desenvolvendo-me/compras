require 'spec_helper'

describe SettingsController do
  before do
    controller.stub(:authenticate_user!)
  end

  it "should create all settings on index" do
    SettingsUpdater.any_instance.should_receive(:update)

    get :index
  end
end
