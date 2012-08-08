require 'spec_helper'

describe ContractsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe "GET 'new'" do
    before do
      get :new
    end

    it 'should have the current year as default year' do
      assigns(:contract).year.should eq Date.current.year
    end
  end

  describe "GET 'next_sequential'" do
    it 'render nothing when no param was given' do
      get :next_sequential

      response.body.should be_blank
    end

    it 'returns a json with the given sequential' do
      Contract.stub(:next_sequential).and_return 1

      get :next_sequential, :format => :json, :entity_id => 1, :year => 2012

      expect(JSON(response.body)).to eq({"sequential" => 1})
    end
  end
end
