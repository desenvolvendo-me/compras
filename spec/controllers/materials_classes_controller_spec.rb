# encoding: utf-8
require 'spec_helper'

describe MaterialsClassesController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'PUT #update' do
    it 'should raise not authorized when not editable' do
      material_class = MaterialsClass.make!(:software)

      put :update, :id => material_class.id

      expect(response.code).to eq '401'
      expect(response.body).to match(/Você não tem acesso a essa página/)
    end
  end

  describe 'DELETE #destroy' do
    it 'should raise not authorized when not editable' do
      material_class = MaterialsClass.make!(:software)

      delete :destroy, :id => material_class.id

      expect(response.code).to eq '401'
      expect(response.body).to match(/Você não tem acesso a essa página/)
    end
  end
end
