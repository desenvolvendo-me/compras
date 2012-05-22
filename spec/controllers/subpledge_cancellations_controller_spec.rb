require 'spec_helper'

describe SubpledgeCancellationsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end


  it 'should call the SubpledgeExpirationMovimentationGenerator on action create' do
    SubpledgeCancellation.any_instance.stub(:valid?).and_return(true)

    SubpledgeExpirationMovimentationGenerator.any_instance.should_receive(:generate!)

    post :create
  end
end
