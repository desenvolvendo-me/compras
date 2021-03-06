require 'spec_helper'

describe PriceCollectionAnnulsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe "GET 'new'" do
    let :price_collection do
      PriceCollection.new
    end

    let :authenticable do
      Employee.new
    end

    let :user do
      User.make!(:sobrinho)
    end

    before do
      PriceCollection.stub(:find).with("1").and_return price_collection
      controller.stub(:current_user).and_return(user)

      get :new, :price_collection_id => 1
    end

    it 'should have the current date as default date' do
      expect(assigns(:price_collection_annul).date).to eq Date.current
    end

    it 'should have the current user authenticable as default responsible' do
      expect(assigns(:price_collection_annul).employee).to eq user.authenticable
    end

    it 'should have the param price_collection as default price_collection' do
      expect(assigns(:price_collection_annul).price_collection).to eq price_collection
    end
  end

  describe "POST 'create'" do
    let :price_collection do
      PriceCollection.make!(:coleta_de_precos)
    end

    before do
      PriceCollectionAnnul.any_instance.stub(:save).and_return true
      PriceCollectionAnnul.any_instance.stub(:price_collection).and_return price_collection
    end

    it 'should redirect to edit price collection after creates the annul' do
      post :create

      expect(response).to redirect_to(edit_price_collection_path(price_collection))
    end

    it 'should annul the proposal' do
      PriceCollectionAnnulment.any_instance.should_receive(:change!)

      post :create
    end
  end
end
