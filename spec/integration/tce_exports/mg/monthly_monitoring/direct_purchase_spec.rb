require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::DirectPurchaseGenerator, vcr: { cassette_name: 'integration/direct_purchase' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    UnicoAPI::Consumer.set_customer customer
  end

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

      purchase_process_budget_allocation = PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens,
        budget_allocation_id: 1)

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

      expect(csv).to eq "10;98;98009001;2013;2;1;20032013;2;Licitação para compra de carteiras;Justificativa legal;Justificativa;20042012;Publicacao\n" +
                        "11;98;98009001;2013;2;1;2;00315198737;Gabriel Sobrinho;Girassol;São Francisco;1;PR;33400500;3333333333;gabriel.sobrinho@gmail.com\n" +
                        "12;98;98009001;2013;2;1;2050;#{item.item_number};Antivirus;10,0000\n" +
                        "13;98;98009001;2013;2;1;98;98009;04;01;0001;0001; ;319000;001;10000\n" +
                        "14;98;98009001;2013;2;1;1;00314951334;Wenderson Malheiros; ; ; ; ; ; ; ; ; ; ; ;2050;#{item.item_number};2,0000;10,0000"
    end

    it 'should not generate data when removal_by_limit' do
      prefecture = Prefecture.make!(:belo_horizonte)
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      monthly_monitoring = FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        month: 5,
        year: 2013)

      purchase_process_budget_allocation = PurchaseProcessBudgetAllocation.make(:alocacao_com_itens,
        budget_allocation_id: 1)

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
