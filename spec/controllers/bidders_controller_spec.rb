require 'spec_helper'

describe BiddersController, vcr: { cassette_name: 'controllers/bidders' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)

    UnicoAPI::Consumer.set_customer customer
  end

  describe 'GET new' do
    it 'should build proposals to bidders' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

      BidderProposalBuilder.any_instance.should_receive(:build!)

      get :new, :licitation_process_id => licitation_process.id

      expect(response.code).to eq '200'
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
    it "should update the licitation_process status to 'in_progress'" do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_fornecedores)
      status_changer = double(:status_changer)

      Bidder.any_instance.should_receive(:save).and_return(true)
      status_changer.should_receive(:in_progress!)
      PurchaseProcessStatusChanger.should_receive(:new).
                                     with(licitation_process).
                                     and_return(status_changer)

      post :create, :licitation_process_id => licitation_process.id
    end
  end

  context 'with ratification' do
    let :licitation_process do
      LicitationProcess.make!(:processo_licitatorio_computador)
    end

    let(:bidder) { licitation_process.bidders.first }

    before do
      LicitationProcessRatification.make!(:processo_licitatorio_computador,
                                          licitation_process: licitation_process)
    end

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
