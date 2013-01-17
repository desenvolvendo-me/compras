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
      status_changer = double(:status_changer)

      Bidder.any_instance.should_receive(:save).and_return(true)
      status_changer.should_receive(:in_progress!)
      LicitationProcessStatusChanger.should_receive(:new).
                                     with(licitation_process).
                                     and_return(status_changer)

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

  context 'with ratification' do
    let :ratification do
      LicitationProcessRatification.make!(:processo_licitatorio_computador)
    end

    let(:licitation_process) { ratification.licitation_process }
    let(:bidder) { licitation_process.bidders.first }

    describe 'POST #create' do
      it 'should raise exception' do
        expect {
          post :create, :licitation_process_id => licitation_process.id
        }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    describe 'PUT #update' do
      it 'should raise exception' do
        expect {
          put :update, :id => bidder.id
        }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    describe 'DELETE #destroy' do
      it 'should raise exception' do
        expect {
          delete :destroy, :id => bidder.id
        }.to raise_exception ActiveRecord::RecordNotFound
      end
    end
  end
end
