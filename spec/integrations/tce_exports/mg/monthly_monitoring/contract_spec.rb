#encoding: utf-8
require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::ContractGenerator do
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

  describe "#generate_file" do
    before do
      FileUtils.rm_f('tmp/CONTRATO.csv')
    end

    after do
      FileUtils.rm_f('tmp/CONTRATO.csv')
    end

    let(:signature_date) { Date.new 2013, 5, 15 }
    let(:end_date)       { Date.new 2013, 5, 30 }

    let(:signature_date_format) { signature_date.strftime('%d%m%Y') }
    let(:current_date) { Date.current.strftime('%d%m%Y') }

    let(:creditor_sobrinho)  { Creditor.make!(:sobrinho) }
    let(:creditor_wenderson) { Creditor.make!(:wenderson_sa) }

    let :prefecture do
      Prefecture.make!(:belo_horizonte, address: Address.make!(:general))
    end

    let(:monthly_monitoring) do
      FactoryGirl.create(:monthly_monitoring, prefecture: prefecture, year: 2013,
        month: 5, city_code: "51234")
    end

    let(:licitation_process) do
      LicitationProcess.make!(:processo_licitatorio,
        items: [PurchaseProcessItem.make!(:item_arame)],
        bidders: [Bidder.make!(:licitante)])
    end

    let(:capability) do
      Capability.make!(:reforma, capability_source: CapabilitySource.make!(:imposto))
    end

    let(:creditor_proposal) do
      PurchaseProcessCreditorProposal.make!(:proposta_arame, licitation_process: licitation_process)
    end

    let(:ratification) do
      LicitationProcessRatification.make(:processo_licitatorio_computador,
        licitation_process: licitation_process, ratification_date: signature_date,
        adjudication_date: signature_date,
        licitation_process_ratification_items: [])
    end


    context "with two or more creditors" do
      let(:expense_nature) { double(:expense_nature, id: 1, expense_nature: '3.1.90.01.01') }

      it "generates a CSV file with the required data" do
        FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

        JudgmentCommissionAdvice.make!(:parecer, licitation_process: licitation_process)

        ratification_item = LicitationProcessRatificationItem.make!(:item,
          purchase_process_creditor_proposal: creditor_proposal,
          licitation_process_ratification: ratification)

        ratification.licitation_process_ratification_items << ratification_item
        ratification.save!

        contract = Contract.make!(:primeiro_contrato, signature_date: signature_date,
          end_date: end_date, licitation_process: licitation_process,
          creditors: [creditor_sobrinho, creditor_wenderson])

        budget_allocation = BudgetAllocation.make!(:alocacao)
        budget_allocation.stub(:expense_nature).and_return(expense_nature)

        pledge = Pledge.new(
          id: 1, value: 9.99, description: 'Empenho 1', year: 2013, to_s: 1,
          emission_date: signature_date,
          capability_id: capability.id,
          licitation_process: licitation_process,
          contract: contract,
          expense_nature: expense_nature,
          expense_nature_expense_nature: budget_allocation.expense_nature.expense_nature,
          function_code: budget_allocation.function_code,
          subfunction_code: budget_allocation.subfunction_code,
          government_program_code: budget_allocation.government_program_code,
          government_action_code: budget_allocation.government_action_code,
          capability_source_code: capability.capability_source_code)

        UnicoAPI::Resources::Contabilidade::Pledge.stub(:all)
          .with(params: {by_contract_id: contract.id, includes: [:capability, budget_allocation: { include: :expense_nature }]})
          .and_return([pledge])

        ContractTermination.make!(:contrato_rescindido, contract: contract)

        BudgetStructure.should_receive(:find).at_least(1).times.with(2).and_return(budget_structure_parent)
        BudgetStructure.should_receive(:find).at_least(1).times.with(1).and_return(budget_structure)

        described_class.generate_file(monthly_monitoring)

        csv = File.read('tmp/CONTRATO.csv', encoding: 'ISO-8859-1')

        reg_10   =  "10;#{contract.id};98;98029;001;#{signature_date_format}; ; ; ; ; ;1;2012;2;Objeto;1;09012012;30052013;100000;Empreitada integral; ; ;"
        reg_10   << "Multa rescisória;Multa inadimplemento;4;Wenderson Malheiros;00314951334;10012012;Jornal Oficial do Município"
        reg_11   =  "11;#{contract.id};Arame comum;1,0000;UN;2,9900"
        reg_12   =  "12;#{contract.id};98;98029;04;001;0003;0003; ;319001;001"
        reg_13_1 =  "13;#{contract.id};1;00314951334;Wenderson Malheiros"
        reg_13_2 =  "13;#{contract.id};1;00315198737;Gabriel Sobrinho"
        reg_40   =  "40;98;98029;001;15052013;#{current_date};150000"

        expect(csv).to eq [reg_10, reg_11, reg_12, reg_13_1, reg_13_2, reg_40].join("\n")
      end
    end

    context "with only one creditor" do
      let(:expense_nature) { double(:expense_nature, id: 1, expense_nature: '3.1.90.01.01') }

      it "generates a CSV file with the required data" do
        FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

        JudgmentCommissionAdvice.make!(:parecer, licitation_process: licitation_process)

        ratification_item = LicitationProcessRatificationItem.make!(:item,
          purchase_process_creditor_proposal: creditor_proposal,
          licitation_process_ratification: ratification)

        ratification.licitation_process_ratification_items << ratification_item
        ratification.save!

        contract = Contract.make!(:primeiro_contrato, signature_date: signature_date,
          end_date: end_date, licitation_process: licitation_process,
          creditors: [creditor_sobrinho])

        ContractTermination.make!(:contrato_rescindido, contract: contract)

        budget_allocation = BudgetAllocation.make!(:alocacao)
        budget_allocation.stub(:expense_nature).and_return(expense_nature)

        pledge = Pledge.new(
          id: 1, value: 9.99, description: 'Empenho 1', year: 2013, to_s: 1,
          emission_date: signature_date,
          capability_id: capability.id,
          licitation_process: licitation_process,
          contract: contract,
          expense_nature: expense_nature,
          expense_nature_expense_nature: budget_allocation.expense_nature.expense_nature,
          function_code: budget_allocation.function_code,
          subfunction_code: budget_allocation.subfunction_code,
          government_program_code: budget_allocation.government_program_code,
          government_action_code: budget_allocation.government_action_code,
          capability_source_code: capability.capability_source_code)

        UnicoAPI::Resources::Contabilidade::Pledge.stub(:all)
          .with(params: {by_contract_id: contract.id,
            includes: [:capability, budget_allocation: { include: :expense_nature }]})
          .and_return([pledge])

        BudgetStructure.should_receive(:find).at_least(1).times.with(2).and_return(budget_structure_parent)
        BudgetStructure.should_receive(:find).at_least(1).times.with(1).and_return(budget_structure)

        described_class.generate_file(monthly_monitoring)

        csv = File.read('tmp/CONTRATO.csv', encoding: 'ISO-8859-1')

        reg_10   =  "10;#{contract.id};98;98029;001;#{signature_date_format};Gabriel Sobrinho;1;00315198737;Gabriel Sobrinho; ;1;2012;2;Objeto;1;09012012;30052013;100000;Empreitada integral; ; ;"
        reg_10   << "Multa rescisória;Multa inadimplemento;4;Wenderson Malheiros;00314951334;10012012;Jornal Oficial do Município"
        reg_11   =  "11;#{contract.id};Arame comum;1,0000;UN;2,9900"
        reg_12   =  "12;#{contract.id};98;98029;04;001;0003;0003; ;319001;001"
        reg_40   =  "40;98;98029;001;15052013;#{current_date};150000"

        expect(csv).to eq [reg_10, reg_11, reg_12, reg_40].join("\n")
      end
    end
  end
end
