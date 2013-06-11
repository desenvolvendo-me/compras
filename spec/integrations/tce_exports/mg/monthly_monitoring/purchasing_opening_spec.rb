#encoding: utf-8
require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::PurchaseOpeningGenerator do
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

      tce_specification_capability = TceSpecificationCapability.make!(:ampliacao)

      capability = Capability.make!(:reforma,
        tce_specification_capability: tce_specification_capability)

      budget_structure = BudgetStructure.make!(:secretaria_de_desenvolvimento)

      budget_allocation = BudgetAllocation.make!(:alocacao,
        budget_allocation_capabilities: [],
        budget_structure: budget_structure)

      budget_allocation_capability = BudgetAllocationCapability.make!(:generic,
        amount: 500.8,
        budget_allocation: budget_allocation,
        capability: capability)

      purchase_process_budget_allocation = PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens,
        budget_allocation: budget_allocation)

      licitation = LicitationProcess.make!(:processo_licitatorio_computador,
        purchase_process_budget_allocations: [purchase_process_budget_allocation],
        authorization_envelope_opening_date: Date.new(2013, 5, 20))

      item = licitation.items.first

      ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador,
        licitation_process: licitation,
        ratification_date: Date.new(2013, 5, 23))

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/ABERLIC.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq "10;98;98029;2013;2;3;1;1;20032013;20032013; ;20042012;Internet; ; ;20052013;2;2;Licitação para compra de carteiras; ; ; ;2;12;Dinheiro;Por Item com Melhor Técnica;2\n" +
                        "11;98;98029;2013;2;2050;#{item.id};20032013;Antivirus;10,0000;2,0000;UN;000\n" +
                        "13;98;98029;2013;2;98;98029;04;01;003;003; ;319001;001;50080"
    end
  end
end

