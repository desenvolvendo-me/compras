require 'spec_helper'

describe SettingsController do
  before do
    sign_in User.make!(:sobrinho)
  end

  it "should create all settings on index" do
    SettingsUpdater.any_instance.should_receive(:update)

    get :index
  end
end
