require 'spec_helper'

describe RevenueNaturesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'POST #create' do
    it 'should generate full code' do
      RevenueNatureCodeGenerator.any_instance.should_receive(:generate!)

      post :create
    end
  end

  context 'PUT #update' do
    it 'should update full code' do
      revenue_nature = RevenueNature.make!(:imposto)
      RevenueNature.stub(:find).and_return(revenue_nature)

      RevenueNatureCodeGenerator.any_instance.should_receive(:generate!)

      put :update, :id => '1'
    end
  end
end
