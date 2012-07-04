require 'spec_helper'

describe PriceCollectionProposalAnnulsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  let :proposal do
    PriceCollectionProposal.make!(:proposta_de_coleta_de_precos)
  end

  describe "GET 'new'" do
    before do
      controller.stub(:current_user).and_return current_user
      get :new, :price_collection_proposal_id => proposal.id
    end

    let :current_user do
      double('CurrentUser', :authenticable => Employee.new, :creditor? => false)
    end

    it 'uses the authenticated user as default responsible' do
      assigns(:price_collection_proposal_annul).employee.should eq current_user.authenticable
    end

    it 'uses the current date as default date' do
      assigns(:price_collection_proposal_annul).date = Date.current
    end
  end

  describe "POST 'create'" do
    before do
      ResourceAnnul.any_instance.stub(:save).and_return true
      post :create, :resource_annul => { :annullable_id => proposal.id }
    end

    it 'should redirect to price_collection_proposal when was saved' do
      response.should redirect_to(edit_price_collection_proposal_path(proposal))
    end

    it 'should annul the proposal' do
      PriceCollectionProposalAnnulment.any_instance.should_receive(:change!)

      post :create, :resource_annul => { :annullable_id => proposal.id }
    end
  end
end
