require 'spec_helper'

describe PledgeCancellationsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'should be empty if dont have any other pledge_cancellation' do
    PledgeCancellation.stub(:any?).and_return(false)

    get :new

    expect(assigns(:pledge_cancellation).date).to eq nil
  end

  it 'should set date as last pledge_cancellation' do
    PledgeCancellation.stub(:any?).and_return(true)
    PledgeCancellation.stub(:last).and_return(double(:date => Date.new(2012, 1, 1)))

    get :new

    expect(assigns(:pledge_cancellation).date).to eq Date.new(2012, 1, 1)
  end
end
