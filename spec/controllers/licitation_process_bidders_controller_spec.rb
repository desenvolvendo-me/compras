require 'spec_helper'

describe LicitationProcessBiddersController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET new' do
    it 'should build proposals to bidders' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

      LicitationProcessBidderProposalBuilder.any_instance.should_receive(:build!)

      get :new, :licitation_process_id => licitation_process.id
    end
  end

  describe 'GET edit' do
    it 'should build proposals to bidders' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

      LicitationProcessBidderProposalBuilder.any_instance.should_receive(:build!)

      get :edit, :id => licitation_process.licitation_process_bidders.first.id, :licitation_process_id => licitation_process.id
    end
  end
end
