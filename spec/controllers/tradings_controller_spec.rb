require 'spec_helper'

describe TradingsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses current year as default value for year' do
    get :new

    expect(assigns(:trading).year).to eq Date.current.year
  end

  describe 'POST #create' do
    it 'should create items from licitation process' do
      licitation_process = LicitationProcess.make!(:processo_licitatorio)

      Trading.should_receive(:transaction).and_yield
      Trading.any_instance.should_receive(:save).and_return(true)

      TradingItemGenerator.should_receive(:generate!)

      post :create, :trading => { :licitation_process_id => licitation_process.id }
    end
  end

  it 'should render report layout on #show' do
    trading = double(:trading, :id => 1)

    get :show, :id => trading.id

    expect(response).to render_template('layout')
  end
end
