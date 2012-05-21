#encoding: utf-8
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

      response.code.should eq '200'
    end

    it 'should redirect to 401 when can not create a bidder' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      get :new, :licitation_process_id => licitation_process.id

      response.code.should eq '401'
      response.body.should =~ /Você não tem acesso a essa página/
    end
  end

  describe 'GET edit' do
    it 'should build proposals to bidders' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

      LicitationProcessBidderProposalBuilder.any_instance.should_receive(:build!)

      get :edit, :id => licitation_process.licitation_process_bidders.first.id, :licitation_process_id => licitation_process.id
    end
  end

  describe 'POST create' do
    it 'should not save when envelope opening date is not today' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      LicitationProcessBidder.any_instance.should_receive(:save).never

      post :create, :licitation_process_id => licitation_process.id
    end

    it 'should save when envelope opening date is today' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

      LicitationProcessBidder.any_instance.should_receive(:save).once

      post :create, :licitation_process_id => licitation_process.id
    end
  end

  describe 'PUT update ' do
    it 'should not save when envelope opening date is not today' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_fornecedores)
      bidder = licitation_process.licitation_process_bidders.first

      LicitationProcessBidder.any_instance.should_receive(:save).never

      put :update, :id => bidder.id, :licitation_process_id => licitation_process.id
    end

    it 'should save when envelope opening date is today' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)
      bidder = licitation_process.licitation_process_bidders.first

      LicitationProcessBidder.any_instance.should_receive(:save).once

      put :update, :id => bidder.id, :licitation_process_id => licitation_process.id
    end
  end
end
