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

    let :budget_structure_parent do
      BudgetStructure.new(
        id: 2,
        code: '1',
        tce_code: '051',
        description: 'Secretaria de Educação',
        acronym: 'SEMUEDU',
        performance_field: 'Desenvolvimento Educacional')
    end

    let :budget_structure do
      BudgetStructure.new(
        id: 1,
        parent_id: 2,
        code: '29',
        tce_code: '051',
        description: 'Secretaria de Desenvolvimento',
        acronym: 'SEMUEDU',
        performance_field: 'Desenvolvimento Educacional')
    end

    let(:expense_nature) { double(:expense_nature, id: 1, expense_nature: '3.1.90.01.01') }

    it "generates a CSV file with the required data" do
      BudgetStructure.should_receive(:find).at_least(1).times.with(2).and_return(budget_structure_parent)
      BudgetStructure.should_receive(:find).at_least(1).times.with(1).and_return(budget_structure)

      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      tce_specification_capability = TceSpecificationCapability.make!(:ampliacao)

      capability = Capability.make!(:reforma,
        tce_specification_capability: tce_specification_capability)

      budget_allocation = BudgetAllocation.make!(:alocacao,
        budget_allocation_capabilities: [],
        budget_structure: budget_structure,
        expense_nature_id: 1)

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

      ExpenseNature.stub(:find).and_return(expense_nature)

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/ABERLIC.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq "10;98;98029;2013;2;3;1;1;20032013;20032013; ;20042012;Internet; ; ;20052013;2;2;Licitação para compra de carteiras; ; ; ;2;12;Dinheiro;Por Item com Melhor Técnica;2\n" +
                        "11;98;98029;2013;2;2050;#{item.item_number};20032013;Antivirus;10,0000;2,0000;UN;000\n" +
                        "13;98;98029;2013;2;98;98029;04;01;003;003; ;319001;001;50080"
    end
  end
end

