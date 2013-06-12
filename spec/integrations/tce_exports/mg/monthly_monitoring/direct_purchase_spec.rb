#encoding: utf-8
require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::DirectPurchaseGenerator do
  describe "#generate_file" do
    before do
      FileUtils.rm_f('tmp/DISPENSA.csv')
    end

    after do
      FileUtils.rm_f('tmp/DISPENSA.csv')
    end

    let(:emissao_edital) { StageProcess.make!(:emissao_edital, description: "Cotação de preços", type_of_purchase: PurchaseProcessTypeOfPurchase::DIRECT_PURCHASE) }
    let(:sobrinho) { Employee.make!(:sobrinho) }

    it "generates a CSV file with the required data" do
      prefecture = Prefecture.make!(:belo_horizonte)
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      monthly_monitoring = FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        month: 5,
        year: 2013)


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

      creditor = Creditor.make!(:wenderson_sa)
      item = PurchaseProcessItem.make!(:item, creditor: creditor)

      licitation = LicitationProcess.make!(:compra_direta,
        purchase_process_budget_allocations: [purchase_process_budget_allocation],
        items: [item],
        authorization_envelope_opening_date: Date.new(2013, 5, 20))

      ProcessResponsible.create!(licitation_process_id: licitation.id,
                                 stage_process_id: emissao_edital.id,
                                 employee_id: sobrinho.id)

      publication = LicitationProcessPublication.make!(:publicacao,
        publication_of: PublicationOf::CONFIRMATION,
        licitation_process: licitation)

      ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador,
        licitation_process: licitation,
        creditor: creditor,
        ratification_date: Date.new(2013, 5, 23))

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/DISPENSA.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq "10;98;98029;2013;2;1;20032013;2;Licitação para compra de carteiras;Justificativa legal;Justificativa;20042012;Publicacao\n" +
                        "11;98;98029;2013;2;1;2;00315198737;Gabriel Sobrinho;Girassol;São Francisco;1;PR;33400500;3333333333;gabriel.sobrinho@gmail.com\n" +
                        "12;98;98029;2013;2;1;2050;#{item.id};Antivirus;10,0000\n" +
                        "13;98;98029;2013;2;1;98;98029;04;01;003;003; ;319001;001;50080\n" +
                        "14;98;98029;2013;2;1;1;00314951334;Wenderson Malheiros; ; ; ; ; ; ; ; ; ; ; ;2050;#{item.id};2,0000;10,0000"
    end

    it 'should not generate data when removal_by_limit' do
      prefecture = Prefecture.make!(:belo_horizonte)
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      monthly_monitoring = FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        month: 5,
        year: 2013)


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

      creditor = Creditor.make!(:wenderson_sa)
      item = PurchaseProcessItem.make!(:item, creditor: creditor)

      licitation = LicitationProcess.make!(:compra_direta,
        purchase_process_budget_allocations: [purchase_process_budget_allocation],
        items: [item],
        type_of_removal: TypeOfRemoval::REMOVAL_BY_LIMIT,
        authorization_envelope_opening_date: Date.new(2013, 5, 20))

      ProcessResponsible.create!(licitation_process_id: licitation.id,
                                 stage_process_id: emissao_edital.id,
                                 employee_id: sobrinho.id)

      publication = LicitationProcessPublication.make!(:publicacao,
        publication_of: PublicationOf::CONFIRMATION,
        licitation_process: licitation)

      ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador,
        licitation_process: licitation,
        creditor: creditor,
        ratification_date: Date.new(2013, 5, 23))

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/DISPENSA.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq ""
    end
  end
end
