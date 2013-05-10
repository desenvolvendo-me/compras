#encoding: utf-8
require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::MonthlyRegulatoryAct do
  describe "#generate_file" do
    before do
      FileUtils.rm_f('tmp/REGLIC.csv')
    end

    after do
      FileUtils.rm_f('tmp/REGLIC.csv')
    end

    let :prefecture do
      Prefecture.make!(:belo_horizonte,
        address: Address.make!(:general))
    end

    it "generates a CSV file with the required data" do
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)
      RegulatoryAct.make!(:sopa,
        regulatory_act_type: RegulatoryActType.make!(:lei,
          kind: RegulatoryActTypeKind::PRICE_REGISTRATION))
      RegulatoryAct.make!(:medida_provisoria,
        regulatory_act_type: RegulatoryActType.make!(:emenda,
          kind: RegulatoryActTypeKind::TRADING))

      monthly_monitoring = FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        year: 2013,
        city_code: "51234")

      subject.generate_file(monthly_monitoring)

      csv = File.read('tmp/REGLIC.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq "98;1;1234;01012012;02012012\n" +
                        "98;2;8901;01012013;02012013"
    end
  end
end
