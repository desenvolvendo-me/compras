# encoding: utf-8
require 'spec_helper'

describe PurchaseSolicitationAnnulsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
    BudgetStructure.stub(:find).with(1)
  end

  describe 'GET #new' do
    it 'should render new when it is not related to purchase process' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)

      get :new, :annullable_id => purchase_solicitation.id

      expect(response.code).to eq '200'
    end

    it 'should raise exception when is related with a purchase process' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)
      LicitationProcess.make!(:processo_licitatorio,
        purchase_solicitations: [purchase_solicitation])

      get :new, :annullable_id => purchase_solicitation.id

      expect(response.code).to eq '401'
      expect(response.body).to match(/Você não tem acesso a essa página/)
    end
  end

  describe 'POST #create' do
    it 'should render create when it is not related to purchase process' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)

      post :create, :annullable_id => purchase_solicitation.id

      expect(response.code).to eq '200'
    end

    it 'should raise exception when is related with a purchase process' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)
      LicitationProcess.make!(:processo_licitatorio,
        purchase_solicitations: [purchase_solicitation])

      post :create, :annullable_id => purchase_solicitation.id

      expect(response.code).to eq '401'
      expect(response.body).to match(/Você não tem acesso a essa página/)
    end
  end
end
