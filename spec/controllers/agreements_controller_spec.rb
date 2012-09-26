require 'spec_helper'

describe AgreementsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'POST #create' do
    it 'should call the AgreementAdditiveNumberGenerator on action create' do
      AgreementAdditiveNumberGenerator.any_instance.should_receive(:generate!)

      post :create
    end

    it 'should call the AgreementBankAccountStatusChanger on action create' do
      AgreementBankAccountStatusChanger.any_instance.should_receive(:change!)

      post :create
    end
  end

  context 'PUT #update' do
    it 'should call AgreementAdditiveNumberGenerator' do
      agreement = Agreement.make!(:apoio_ao_turismo)

      AgreementAdditiveNumberGenerator.any_instance.should_receive(:generate!)

      put :update, :id => agreement.id
    end

    it 'should call AgreementBankAccountStatusChanger' do
      agreement = Agreement.make!(:apoio_ao_turismo)

      AgreementBankAccountStatusChanger.any_instance.should_receive(:change!)

      put :update, :id => agreement.id
    end
  end
end
