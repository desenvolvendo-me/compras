#encoding: utf-8
require 'spec_helper'

describe BiddersController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET new' do
    it 'should build proposals to bidders' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

      BidderProposalBuilder.any_instance.should_receive(:build!)

      get :new, :licitation_process_id => licitation_process.id

      expect(response.code).to eq '200'
    end

    it 'should redirect to 401 when can not create a bidder' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      get :new, :licitation_process_id => licitation_process.id

      expect(response.code).to eq '401'
      expect(response.body).to match /Você não tem acesso a essa página/
    end
  end

  describe 'GET edit' do
    it 'should build proposals to bidders' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

      BidderProposalBuilder.any_instance.should_receive(:build!)

      get :edit, :id => licitation_process.bidders.first.id, :licitation_process_id => licitation_process.id
    end
  end

  describe 'POST create' do
    it 'should not save when envelope opening date is not today' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      Bidder.any_instance.should_receive(:save).never

      post :create, :licitation_process_id => licitation_process.id
    end

    it "should update the licitation_process status to 'in_progress'" do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_fornecedores)

      Bidder.any_instance.should_receive(:save).and_return(true)
      LicitationProcess.any_instance.should_receive(:update_status).with(LicitationProcessStatus::IN_PROGRESS)

      post :create, :licitation_process_id => licitation_process.id
    end

    it 'should redirect to 401 when can not create a bidder' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      post :create, :licitation_process_id => licitation_process.id

      expect(response.code).to eq '401'
      expect(response.body).to match /Você não tem acesso a essa página/
    end
  end

  describe 'PUT update ' do
    it 'should not save when envelope opening date is not today' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_fornecedores)
      licitation_process.update_attributes(:envelope_opening_date => Date.tomorrow)
      bidder = licitation_process.bidders.first

      Bidder.any_instance.should_receive(:save).never

      put :update, :id => bidder.id, :licitation_process_id => licitation_process.id
    end

    it 'should save when envelope opening date is today' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
      bidder = licitation_process.bidders.first

      Bidder.any_instance.should_receive(:save).once

      put :update, :id => bidder.id, :licitation_process_id => licitation_process.id
    end

    it 'should redirect to 401 when can not update a bidder' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_fornecedores)
      licitation_process.update_attributes(:envelope_opening_date => Date.tomorrow)

      bidder = licitation_process.bidders.first

      put :update, :id => bidder.id

      expect(response.code).to eq '401'
      expect(response.body).to match /Você não tem acesso a essa página/
    end
  end

  describe 'DELETE #destroy' do
    it 'should redirect to 401 when can not destroy a bidder' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_fornecedores)
      licitation_process.update_attributes(:envelope_opening_date => Date.tomorrow)

      bidder = licitation_process.bidders.first

      delete :destroy, :id => bidder.id

      expect(response.code).to eq '401'
      expect(response.body).to match /Você não tem acesso a essa página/
    end
  end
end
