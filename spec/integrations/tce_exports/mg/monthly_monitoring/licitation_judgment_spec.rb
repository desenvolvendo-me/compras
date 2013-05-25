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
        city_code: "51234")
    end

    it "generates a CSV file with the required data" do
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      item = PurchaseProcessItem.make!(:item_arame_farpado)
      PurchaseProcessCreditorProposal.make!(:proposta_arame_farpado, item: item)

      item_2 = PurchaseProcessItem.make!(:item_arame)
      PurchaseProcessCreditorProposal.make!(:proposta_arame, item: item_2)

      described_class.generate_file(monthly_monitoring)

      current_date = Date.current.strftime('%d%m%Y')

      csv = File.read('tmp/JULGLIC.csv', encoding: 'ISO-8859-1')

      reg_10_1 = "10;98;98029;2012;1;1;00315198737; ;#{item.id};02.02.00001 - Arame farpado;4,9900;1,0000;UN"
      reg_30_1 = "30;98;98029;2012;1;#{current_date};2;2"

      reg_10_2 = "10;98;98029;2012;1;1;00315198737; ;#{item_2.id};02.02.00002 - Arame comum;2,9900;1,0000;UN"
      reg_30_2 = "30;98;98029;2012;1;#{current_date};2;2"

      expect(csv).to eq [reg_10_1, reg_30_1, reg_10_2, reg_30_2].join("\n")
    end
  end
end
