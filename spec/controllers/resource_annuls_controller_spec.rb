# encoding: utf-8
require 'spec_helper'

class TestAnnulsController < ResourceAnnulsController
end

describe TestAnnulsController do
  let(:resource_annul) do
    double(:resource_annul, :date= => true, :employee= => true)
  end

  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)

    Rails.application.routes.draw do
      resources :test_annuls
    end
  end

  after do
    Rails.application.reload_routes!
  end

  context "with annullable" do
    let :annullable do
      ContractTermination.make!(:contrato_rescindido)
    end

    let :resource do
      double(:resource)
    end

    it "should show have the edit parent url" do
      subject.stub(:annullable_id => annullable.id)
      subject.stub(:resource => resource)

      resource.stub(:annullable => annullable)

      expect(subject.edit_parent_path).to eq [:edit, annullable]
    end
  end

  describe 'GET #new' do
    it "should return 401 if parent is already annulled" do
      subject.stub(:build_resource).and_return(resource_annul)

      resource_annul.should_receive(:annulled?).and_return(true)

      get :new, :annullable_id => 1

      expect(response.code).to eq '401'
    end

    it "should not return 401 if parent is not annulled" do
      subject.stub(:build_resource).and_return(resource_annul)

      resource_annul.should_receive(:annulled?).and_return(false)

      get :new, :annullable_id => 1

      expect(response.code).to eq '200'
    end
  end

  describe 'POST #create' do
    it "should return 401 if parent is already annulled" do
      subject.stub(:build_resource).and_return(resource_annul)

      resource_annul.should_receive(:annulled?).and_return(true)

      post :create

      expect(response.code).to eq '401'
    end

    it "should not return 401 if parent is not annulled" do
      subject.stub(:build_resource).and_return(resource_annul)
      subject.stub(:edit_parent_path).and_return('/test/edit/1')
      resource_annul.stub(:annullable).and_return('Test')

      resource_annul.should_receive(:annulled?).and_return(false)
      resource_annul.should_receive(:save).and_return(true)
      resource_annul.should_receive(:transaction).and_yield
      ObjectAnnulment.should_receive(:annul!).with('Test')

      post :create

      expect(response).to redirect_to('/test/edit/1')
    end
  end

  describe 'PUT #update' do
    it 'should not have update action' do
      expect { put :update }.to raise_exception ActionController::RoutingError
    end
  end

  describe 'DELETE #destroy' do
    it 'should not have index action' do
      expect { delete :destroy }.to raise_exception ActionController::RoutingError
    end
  end
end
