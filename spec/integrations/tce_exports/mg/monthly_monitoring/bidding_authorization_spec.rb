#encoding: utf-8
require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::BiddingAuthorizationGenerator do
  describe "#generate_file" do
    before do
      FileUtils.rm_f('tmp/HABLIC.csv')
    end

    after do
      FileUtils.rm_f('tmp/HABLIC.csv')
    end

    let :creditor do
      Creditor.make!(:nohup)
    end

    let :bidder do
      Bidder.make!(:licitante, creditor: creditor)
    end

    let :licitation_process do
      licitation_process = LicitationProcess.make!(:processo_licitatorio_computador,
        bidders: [bidder])
    end

    it "generates a CSV file with the required data" do
      prefecture = Prefecture.make!(:belo_horizonte)
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      Customization.make!(:campo_string,
        state: ::FactoryGirl::Preload.factories['State'][:pr],
        data: [
          CustomizationData.make(:string, data: 'Objeto social do credor'),
          CustomizationData.make(:string, data: 'Numero do registro CVM'),
          CustomizationData.make(:string, data: 'Data do registro CVM')
      ])

      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado,
        licitation_process: licitation_process, ranking: 1, creditor: creditor)

      ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador,
        ratification_date: Date.new(2013, 5, 20),
        licitation_process: licitation_process,
        bidder: bidder)

      bidder.activate!
      bidder.update_column :habilitation_date, Date.new(2013, 5, 20)

      Partner.destroy_all

      partner = Partner.make!(:wenderson,
        person: Person.make!(:pedro_dos_santos),
        company: creditor.person.personable)

      ExtendedPartner.create!(partner_id: partner.id,
        society_kind: SocietyKind::LEGAL_REPRESENTATIVE)

      monthly_monitoring = FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        month: 5,
        year: 2013)

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/HABLIC.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq "10;98;98029;2013;2;2;00000000999962;Nohup; ; ;29062011;099901; ; ;;PR; ; ; ; ; ; ; ; ; ;20052013;2;2\n" +
                        "11;98;98029;2013;2;6;00000000999962;1;27056534147;Pedro dos Santos;1"
    end
  end
end

