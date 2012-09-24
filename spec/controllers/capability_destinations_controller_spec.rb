#encoding: utf-8
require 'spec_helper'

describe CapabilityDestinationsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  context 'POST #create' do
    let :detail do
      double(:status => nil)
    end

    it 'should active capability destination details' do
      CapabilityDestination.any_instance.should_receive(:capability_destination_details).and_return([detail])
      detail.should_receive(:active!).and_return(true)

      post :create
    end
  end
end
