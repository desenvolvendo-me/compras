require 'spec_helper'

describe RealignmentPricesController, vcr: { cassette_name: 'controllers/realignment_prices' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)

    UnicoAPI::Consumer.set_customer customer
  end

  describe 'GET #new' do
    it 'should set some defaut values' do
      purchase_process = LicitationProcess.make!(:processo_licitatorio)
      creditor = Creditor.make!(:sobrinho)

      get :new, purchase_process_id: purchase_process.id, creditor_id: creditor.id, lot: 5

      expect(assigns(:realignment_price).purchase_process).to eq purchase_process
      expect(assigns(:realignment_price).creditor).to eq creditor
      expect(assigns(:realignment_price).lot).to eq 5
    end
  end

  describe 'POST #create' do
    it 'should redirect to index on success' do
      RealignmentPrice.any_instance.should_receive(:save).and_return(true)

      post :create

      expect(response).to redirect_to(realignment_prices_path)
    end
  end

  describe 'PUT #update' do
    it 'should redirect to index on success' do
      realignment_price = double(:realignment_price, purchase_process_id: 5, errors: [])

      RealignmentPrice.should_receive(:find).with('10').and_return(realignment_price)
      realignment_price.should_receive(:localized).and_return(realignment_price)
      realignment_price.should_receive(:update_attributes).and_return(true)

      put :update, id: 10

      expect(response).to redirect_to(realignment_prices_path(purchase_process_id: 5))
    end
  end
end
