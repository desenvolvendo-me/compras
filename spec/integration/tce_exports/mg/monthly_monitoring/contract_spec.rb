require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::ContractGenerator, vcr: { cassette_name: 'integration/contract' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    UnicoAPI::Consumer.set_customer customer
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

    let(:direct_purchase) do
      LicitationProcess.make!(:compra_direta,
        type_of_removal: TypeOfRemoval::REMOVAL_BY_LIMIT,
        bidders: [])
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
      it "generates a CSV file with the required data", :reset_ids do
        FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

        JudgmentCommissionAdvice.make!(:parecer, licitation_process: licitation_process)

        ratification_item = LicitationProcessRatificationItem.make!(:item,
          purchase_process_creditor_proposal: creditor_proposal,
          licitation_process_ratification: ratification)

        ratification.licitation_process_ratification_items << ratification_item
        ratification.save!

        contract = Contract.make!(:primeiro_contrato, signature_date: signature_date,
          end_date: end_date, licitation_process: licitation_process,
          creditors: [creditor_sobrinho, creditor_wenderson], consortium_agreement: true)

        contract_two = Contract.make!(:primeiro_contrato, signature_date: signature_date,
          end_date: end_date, licitation_process: direct_purchase,
          creditors: [creditor_sobrinho, creditor_wenderson], consortium_agreement: true)

        ContractTermination.make!(:contrato_rescindido, contract: contract)

        described_class.generate_file(monthly_monitoring)

        csv = File.read('tmp/CONTRATO.csv', encoding: 'ISO-8859-1')

        reg_10   =  "10;#{contract.id};98;;001;#{signature_date_format}; ; ; ; ; ;1;2012;2;Objeto;1;09012012;30052013;100000;Empreitada integral; ; ;"
        reg_10   << "Multa rescisória;Multa inadimplemento;4;Wenderson Malheiros;00314951334;10012012;Jornal Oficial do Município"
        reg_11   =  "11;#{contract.id};Arame comum;1,0000;UN;2,9900"
        reg_12   =  "12;#{contract.id};98;;04;001;0001;0001; ;319000;001"
        reg_13_1 =  "13;#{contract.id};1;00314951334;Wenderson Malheiros"
        reg_13_2 =  "13;#{contract.id};1;00315198737;Gabriel Sobrinho"
        reg_40   =  "40;98;;001;15052013;#{current_date};150000"

        expect(csv).to eq [reg_10, reg_11, reg_12, reg_13_1, reg_13_2, reg_40].join("\n")
      end
    end

    context "with only one creditor" do
      it "generates a CSV file with the required data", :reset_ids do
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

        described_class.generate_file(monthly_monitoring)

        csv = File.read('tmp/CONTRATO.csv', encoding: 'ISO-8859-1')

        reg_10   =  "10;#{contract.id};98;;001;#{signature_date_format};Gabriel Sobrinho;1;00315198737;Gabriel Sobrinho; ;1;2012;2;Objeto;1;09012012;30052013;100000;Empreitada integral; ; ;"
        reg_10   << "Multa rescisória;Multa inadimplemento;4;Wenderson Malheiros;00314951334;10012012;Jornal Oficial do Município"
        reg_11   =  "11;#{contract.id};Arame comum;1,0000;UN;2,9900"
        reg_12   =  "12;#{contract.id};98;;04;001;0001;0001; ;319000;001"
        reg_40   =  "40;98;001;15052013;#{current_date};150000"

        expect(csv).to eq [reg_10, reg_11, reg_12, reg_40].join("\n")
      end
    end
  end
end
