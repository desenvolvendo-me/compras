require 'spec_helper'

describe JudgmentCommissionAdvicesController, vcr: { cassette_name: 'controllers/judgment_commission_advices' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)

    UnicoAPI::Consumer.set_customer customer
  end

  it 'uses current year as default value for year' do
    licitation_process = LicitationProcess.make!(:processo_licitatorio_computador)

    get :new, :licitation_process_id => licitation_process.id

    expect(assigns(:judgment_commission_advice).year).to eq Date.current.year
  end
end
