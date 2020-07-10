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

    it 'should raise exception when is related with a purchase process' do
      purchase_solicitation = ListPurchaseSolicitation.make!(:principal)
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
      purchase_solicitation = ListPurchaseSolicitation.make!(:principal)
      LicitationProcess.make!(:processo_licitatorio,
        purchase_solicitations: [purchase_solicitation])

      post :create, :annullable_id => purchase_solicitation.id

      expect(response.code).to eq '401'
      expect(response.body).to match(/Você não tem acesso a essa página/)
    end
  end
end
