#encoding: utf-8
require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::LicitationJudgmentGenerator do
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

        reg_10_1 = "10;98;98029;2012;1;1;00315198737;#{item.lot};#{item.id};Arame farpado;4,9900;1,0000;UN"
        reg_10_2 = "10;98;98029;2012;1;1;00315198737;#{item.lot};#{item_2.id};Arame comum;2,9900;1,0000;UN"
        reg_30 = "30;98;98029;2012;1;#{current_date};2;2"

        expect(csv).to eq [reg_10_1,  reg_10_2, reg_30].join("\n")
      end
    end

    context "with price realigment" do
      it "generates a CSV file with realigment_prices data" do
        FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

        creditor = Creditor.make!(:wenderson_sa)

        bidder = Bidder.make!(:licitante, creditor: creditor)

        licitation_process = LicitationProcess.make!(:pregao_presencial,
          bidders: [bidder], judgment_form: JudgmentForm.make!(:global_com_menor_preco))

        JudgmentCommissionAdvice.make!(:parecer, licitation_process: licitation_process)

        PurchaseProcessAccreditation.make!(:general_accreditation,
          licitation_process: licitation_process)

        item = PurchaseProcessItem.make!(:item_arame_farpado)

        proposal = PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
          licitation_process: licitation_process, unit_price: 9.99)

        LicitationProcessRatification.make!(:processo_licitatorio_computador,
          licitation_process: bidder.licitation_process,
          creditor: bidder.creditor,
          ratification_date: Date.new(2013, 5, 23))

        RealigmentPrice.make!(:realinhamento, proposal: proposal, item: item)

        described_class.generate_file(monthly_monitoring)

        current_date = Date.current.strftime('%d%m%Y')

        csv = File.read('tmp/JULGLIC.csv', encoding: 'ISO-8859-1')

        reg_10_1 = "10;98;98029;2012;1;1;00315198737;#{item.lot};#{item.id};Arame farpado;9,9900;1,0000;UN"
        reg_30_1 = "30;98;98029;2012;1;#{current_date};2;2"

        expect(csv).to eq [reg_10_1, reg_30_1].join("\n")
      end
    end
  end
end
