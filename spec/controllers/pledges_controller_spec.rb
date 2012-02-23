require 'spec_helper'

describe PledgesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  it 'uses current date as default value for emission date' do
    get :new

    assigns(:pledge).emission_date.should eq Date.current
  end

  it 'show the informed licitation when informed licitation is not nil' do
    pledge = Pledge.make!(:empenho, :licitation => "123/2031")

    get :edit, :id => pledge.id

    assigns(:pledge).licitation.should eq '123/2031'
  end

  it 'show the saved licitation when informed licitation is nil' do
    pledge = Pledge.make!(:empenho)

    get :edit, :id => pledge.id

    assigns(:pledge).licitation.should eq '001/2012'
  end

  it 'show the informed process when informed process is not nil' do
    pledge = Pledge.make!(:empenho, :process => "123/2031")

    get :edit, :id => pledge.id

    assigns(:pledge).process.should eq '123/2031'
  end

  it 'show the saved process when informed process is nil' do
    pledge = Pledge.make!(:empenho)

    get :edit, :id => pledge.id

    assigns(:pledge).process.should eq '002/2013'
  end
end
