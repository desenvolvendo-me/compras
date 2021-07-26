require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::PurchaseOpeningGenerator, vcr: { cassette_name: 'integration/purchasing_opening' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    UnicoAPI::Consumer.set_customer customer
  end

  describe "#generate_file" do
    before do
      FileUtils.rm_f('tmp/ABERLIC.csv')
    end

    after do
      FileUtils.rm_f('tmp/ABERLIC.csv')
    end

    let :prefecture do
      Prefecture.make!(:belo_horizonte,
        address: Address.make!(:general))
    end

    let(:monthly_monitoring) do
      FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        year: 2013,
        month: 5,
        city_code: "51234")
    end

    it "generates a CSV file with the required data" do
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      purchase_process_budget_allocation = PurchaseProcessBudgetAllocation.make(:alocacao_com_itens,
        budget_allocation_id: 1)

      licitation = LicitationProcess.make!(:processo_licitatorio_computador,
        purchase_process_budget_allocations: [purchase_process_budget_allocation],
        authorization_envelope_opening_date: Date.new(2013, 5, 20))

      direct_purchase = LicitationProcess.make!(:compra_direta, process: 1,
        authorization_envelope_opening_date: Date.new(2013, 5, 20))

      item = licitation.items.first

      LicitationProcessRatification.make!(:processo_licitatorio_computador,
        licitation_process: licitation,
        ratification_date: Date.new(2013, 5, 23))

      LicitationProcessRatification.make!(:processo_licitatorio_computador,
        licitation_process: direct_purchase,
        ratification_date: Date.new(2013, 5, 23))

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/ABERLIC.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq "10;98;98009001;2013;2;3;1;1;20032013;20032013; ;20042012;Internet; ; ;20052013;2;2;Licitação para compra de carteiras; ; ; ;2;12;Dinheiro;Por Item com Melhor Técnica;2\n" +
                        "11;98;98009001;2013;2;2050;#{item.item_number};20032013;Antivirus;10,0000;2,0000;UN;000\n" +
                        "13;98;98009001;2013;2;98;98009;04;01;0001;0001; ;319000;001;10000"
    end
  end
end

