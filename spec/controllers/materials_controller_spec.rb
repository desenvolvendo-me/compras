require 'spec_helper'

describe MaterialsController do
  before do
    sign_in User.make!(:sobrinho_as_admin)
  end

  describe 'POST create' do
    it 'should generate code to material' do
      MaterialCodeGenerator.any_instance.should_receive(:generate!)

      post :create
    end
  end

  describe 'PUT update' do
    it 'should update code' do
      material = Material.make!(:manga)
      Material.should_receive(:find).and_return(material)

      MaterialCodeGenerator.any_instance.should_receive(:generate!)

      put :update, :id => 1
    end
  end
end
