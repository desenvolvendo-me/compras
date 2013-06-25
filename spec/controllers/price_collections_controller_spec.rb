#encoding: utf-8
require 'spec_helper'

describe PriceCollectionsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'GET #new' do
    it 'uses current date as default value for date' do
      get :new

      expect(assigns(:price_collection).date).to eq Date.current
    end

    it 'uses current year as default value for year' do
      get :new

      expect(assigns(:price_collection).year).to eq Date.current.year
    end

    it 'uses active as default value for status' do
      get :new

      expect(assigns(:price_collection).status).to eq Status::ACTIVE
    end
  end

  context 'POST #create' do
    it 'uses active as default value for status' do
      post :create

      expect(assigns(:price_collection).status).to eq Status::ACTIVE
    end

    describe 'successfull' do
      before do
        PriceCollection.any_instance.should_receive(:save).and_return true
      end

      it 'should generate the users for the creditors' do
        CreditorUserCreator.any_instance.should_receive(:generate)

        post :create
      end
    end

    describe 'unsuccessful' do
      before do
        PriceCollection.any_instance.should_receive(:save).and_return false
      end

      it 'should generate the users for the creditors' do
        CreditorUserCreator.any_instance.should_not_receive(:generate)

        post :create
      end
    end
  end

  context 'PUT #update' do
    let :price_collection do
      double('PriceCollection',
             :id => 1,
             :code => 3,
             :year => 2013,
             :all_price_collection_classifications => price_collection_classifications,
             :type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_GLOBAL_PRICE,
             :annulled? => false)
    end

    let :price_collection_classifications do
      [double('PriceCollectionClassification', :classifiable_id => 1, :classifiable_type => 'PriceCollection', :classification => 1),
       double('PriceCollectionClassification', :classifiable_id => 1, :classifiable_type => 'PriceCollection', :classification => 2)]
    end

    before do
      PriceCollection.stub(:find).and_return price_collection
      price_collection.stub(:localized).and_return price_collection
    end

    describe 'successful update' do
      before do
        price_collection.stub(:update_attributes).and_return true
      end

      it 'should generate users for any creditor' do
        CreditorUserCreator.any_instance.should_receive(:generate)

        put :update, :id => 1
      end
    end

    describe 'unsuccessful update' do
      before do
        price_collection.stub(:update_attributes).and_return false
      end

      it 'should not generate users for any creditor' do
        CreditorUserCreator.any_instance.should_not_receive(:generate)

        put :update, :id => 1
      end
    end

    describe 'a annulled collection' do
      it 'should raises a unauthorized error' do
        price_collection.stub(:annulled?).and_return true

        put :update, :id => 1

        expect(response.code).to eq '401'
        expect(response.body).to match /Você não tem acesso a essa página/
      end
    end
  end

  describe 'POST #classification' do
    let :price_collection do
      double('PriceCollection',
             :id => 1,
             :code => 3,
             :year => 2013,
             :all_price_collection_classifications => price_collection_classifications,
             :type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_GLOBAL_PRICE,
             :annulled? => false)
    end

    let :price_collection_classifications do
      [double('PriceCollectionClassification', :classifiable_id => 1, :classifiable_type => 'PriceCollection', :classification => 1),
       double('PriceCollectionClassification', :classifiable_id => 1, :classifiable_type => 'PriceCollection', :classification => 2)]
    end

    before do
      PriceCollection.stub(:find).and_return price_collection
      price_collection.stub(:localized).and_return price_collection
    end

    it 'delete classifications e call classification generator' do
      PriceCollection.stub(:find).and_return(price_collection)

      price_collection.should_receive(:transaction).and_yield

      PriceCollectionClassificationGenerator.any_instance.should_receive(:generate!)

      post :classification, :id => price_collection.id

      expect(response).to redirect_to(price_collection_path(price_collection))
    end
  end

  context 'GET #show' do
    it 'should render report layout' do
      get :show, :id => 1

      expect(response).to render_template("layouts/report")
    end
  end
end
