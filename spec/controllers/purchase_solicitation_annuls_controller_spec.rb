require 'spec_helper'

describe PurchaseSolicitationAnnulsController, vcr: { cassette_name: 'controllers/purchase_solicitation_annuls' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
    BudgetStructure.stub(:find)

    UnicoAPI::Consumer.set_customer customer
  end

  describe 'GET #new' do
    it 'should render new when it is not related to purchase process' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)

      get :new, :annullable_id => purchase_solicitation.id

      expect(response.code).to eq '200'
    end
  end

  describe 'POST #create' do
    it 'should render create when it is not related to purchase process' do
      purchase_solicitation = PurchaseSolicitation.make!(:reparo_liberado)

      post :create, :annullable_id => purchase_solicitation.id

      expect(response.code).to eq '200'
    end
  end
end
