#encoding: utf-8
require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::LicitationJudgmentGenerator do
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
      FileUtils.rm_f('tmp/JULGLIC.csv')
    end

    after do
      FileUtils.rm_f('tmp/JULGLIC.csv')
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

    context 'with creditor proposals' do
      it "generates a CSV file with the required data" do
        BudgetStructure.should_receive(:find).at_least(1).times.with(2).and_return(budget_structure_parent)
        BudgetStructure.should_receive(:find).at_least(1).times.with(1).and_return(budget_structure)

        FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

        creditor = Creditor.make!(:wenderson_sa)

        bidder = Bidder.make(:licitante, creditor: creditor)

        licitation_process = LicitationProcess.make(:pregao_presencial,
          bidders: [bidder])

        JudgmentCommissionAdvice.make!(:parecer, licitation_process: licitation_process)

        PurchaseProcessAccreditation.make!(:general_accreditation,
          licitation_process: licitation_process)

        item = PurchaseProcessItem.make(:item_arame_farpado)

        proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
          licitation_process: licitation_process,
          item: item)

        item_2 = PurchaseProcessItem.make!(:item_arame)

        PurchaseProcessCreditorProposal.make!(:proposta_arame,
          licitation_process: licitation_process,
          item: item_2)

        LicitationProcessRatification.make!(:processo_licitatorio_computador,
          licitation_process: bidder.licitation_process,
          creditor: bidder.creditor,
          ratification_date: Date.new(2013, 5, 23))

        described_class.generate_file(monthly_monitoring)

        current_date = Date.current.strftime('%d%m%Y')

        csv = File.read('tmp/JULGLIC.csv', encoding: 'ISO-8859-1')

        reg_10_1 = "10;98;98029;2012;1;1;00315198737;#{item.lot};#{item.item_number};Arame farpado;4,9900;1,0000;UN"
        reg_10_2 = "10;98;98029;2012;1;1;00315198737;#{item.lot};#{item_2.item_number};Arame comum;2,9900;1,0000;UN"
        reg_30 = "30;98;98029;2012;1;#{current_date};2;2"

        expect(csv).to eq [reg_10_1,  reg_10_2, reg_30].join("\n")
      end
    end

    context "with price realignment" do
      it "generates a CSV file with realignment_prices data" do
        BudgetStructure.should_receive(:find).at_least(1).times.with(2).and_return(budget_structure_parent)
        BudgetStructure.should_receive(:find).at_least(1).times.with(1).and_return(budget_structure)

        FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

        creditor = Creditor.make!(:wenderson_sa)

        bidder = Bidder.make!(:licitante, creditor: creditor)

        licitation_process = LicitationProcess.make!(:pregao_presencial,
          bidders: [bidder], judgment_form: JudgmentForm.make!(:global_com_menor_preco))

        JudgmentCommissionAdvice.make!(:parecer, licitation_process: licitation_process)

        PurchaseProcessAccreditation.make!(:general_accreditation,
          licitation_process: licitation_process)

        item = PurchaseProcessItem.make!(:item_arame_farpado, quantity: 1)

        proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
          licitation_process: licitation_process,
          creditor: creditor,
          unit_price: 9.99)

        LicitationProcessRatification.make!(:processo_licitatorio_computador,
          licitation_process: bidder.licitation_process,
          creditor: creditor,
          ratification_date: Date.new(2013, 5, 23))

        realignment = RealignmentPrice.make(:realinhamento,
                              purchase_process: licitation_process,
                              creditor: creditor,
                              lot: nil)

        realignment.items.build(
          purchase_process_item_id: item.id,
          price: 9.99)

        realignment.save!

        described_class.generate_file(monthly_monitoring)

        current_date = Date.current.strftime('%d%m%Y')

        csv = File.read('tmp/JULGLIC.csv', encoding: 'ISO-8859-1')

        reg_10_1 = "10;98;98029;2012;1;1;00314951334;#{item.lot};#{item.item_number};Arame farpado;9,9900;1,0000;UN"
        reg_30_1 = "30;98;98029;2012;1;#{current_date};2;2"

        expect(csv).to eq [reg_10_1, reg_30_1].join("\n")
      end
    end
  end
end
