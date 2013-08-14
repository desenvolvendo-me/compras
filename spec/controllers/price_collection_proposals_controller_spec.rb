require 'spec_helper'

describe PriceCollectionProposalsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe "PUT 'update'" do
    let(:proposal)      { double('Proposal') }
    let(:authenticable) { Employee.new }

    before do
      PriceCollectionProposal.stub(:find).and_return proposal
    end

    it 'should not be acessible when the user has not access to update them' do
      proposal.should_receive(:editable_by?).and_return false

      put :update, :id => 1

      expect(response.code).to eq '401'
      expect(response.body).to match /Você não tem acesso a essa página/
    end

    it 'should be accessible when the user has access' do
      proposal.stub(:localized).and_return proposal
      controller.stub(employee?: true)
      controller.stub(authenticable: authenticable)

      proposal.should_receive(:editable_by?).and_return true
      proposal.should_receive(:employee=).with authenticable
      proposal.should_receive(:update_attributes)

      put :update, :id => 1

      #update always redirect :)
      expect(response.code).to eq '302'
    end
  end
end
