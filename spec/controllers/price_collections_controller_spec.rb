require 'spec_helper'

describe PriceCollectionsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'GET #new' do
    it 'uses current date as default value for date' do
      get :new

      assigns(:price_collection).date.should eq Date.current
    end

    it 'uses current year as default value for year' do
      get :new

      assigns(:price_collection).year.should eq Date.current.year
    end

    it 'uses active as default value for status' do
      get :new

      assigns(:price_collection).status.should eq Status::ACTIVE
    end
  end

  context 'POST #create' do
    it 'should assign the collection number' do
      PriceCollection.any_instance.stub(:next_collection_number).and_return(2)

      post :create

      assigns(:price_collection).collection_number.should eq 2
    end

    it 'uses active as default value for status' do
      post :create

      assigns(:price_collection).status.should eq Status::ACTIVE
    end
  end
end
