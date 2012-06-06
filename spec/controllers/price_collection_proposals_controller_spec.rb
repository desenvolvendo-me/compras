#encoding: utf-8
require 'spec_helper'

describe PriceCollectionProposalsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe "PUT 'update'" do
    let :proposal do
      double('Proposal')
    end

    before do
      PriceCollectionProposal.stub(:find).and_return proposal
    end

    it 'should not be acessible when the user has not access to update them' do
      proposal.should_receive(:editable_by?).and_return false

      put :update

      response.code.should eq '401'
      response.body.should =~ /Você não tem acesso a essa página/
    end

    it 'should be acessible when the user has acess' do
      proposal.stub(:localized).and_return proposal
      proposal.stub(:update_attributes)
      proposal.should_receive(:editable_by?).and_return true

      put :update

      #update always redirect :)
      response.code.should eq '302'
    end
  end
end
