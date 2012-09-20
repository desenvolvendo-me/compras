require 'spec_helper'

describe AgreementsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'should call the AgreementAdditiveNumberGenerator on action create' do
    AgreementAdditiveNumberGenerator.any_instance.should_receive(:generate!)

    post :create
  end

  it 'should call the AgreementBankAccountStatusChanger on action create' do
    AgreementBankAccountStatusChanger.any_instance.should_receive(:change!)

    post :create
  end

  context 'PUT #update' do
    it 'should call AgreementAdditiveNumberGenerator' do
      Agreement.stub(:find).and_return(double.as_null_object)

      AgreementAdditiveNumberGenerator.any_instance.should_receive(:generate!)

      put :update, :id => '1'
    end

    it 'should call AgreementAdditiveNumberGenerator' do
      Agreement.stub(:find).and_return(double.as_null_object)

      AgreementBankAccountStatusChanger.any_instance.should_receive(:change!)

      put :update, :id => '1'
    end
  end
end
