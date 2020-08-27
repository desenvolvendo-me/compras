require 'spec_helper'
require 'zip/zip'

describe TceExport::MG::MonthlyMonitoring do
  describe "#generate_zip_file" do
    before do
      FileUtils.rm_f("tmp/AM_51234_66_10_2013.zip")
    end

    after do
      FileUtils.rm_f("tmp/AM_51234_66_10_2013.zip")
    end

    let :prefecture do
      Prefecture.make!(:belo_horizonte,
        address: Address.make!(:general,
          neighborhood: FactoryGirl.create(:neighborhood,
            city: FactoryGirl.create(:city,
              name: "Newtown",
              tce_mg_code: "12345",
              state: states(:mg)
            )
          )
        )
      )
    end

    it "generates a zip file with all the CSVs" do
      FactoryGirl.create(:extended_prefecture,
        prefecture: prefecture,
        organ_code: "66",
        organ_kind: "10")

      monthly_monitoring = FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        city_code: "51234")

      TceExport::MG::MonthlyMonitoring.generate_zip_file(monthly_monitoring)
      entries = Zip::ZipFile.open("tmp/AM_51234_66_10_2013.zip").entries.map(&:to_s)
      expect(entries.sort).to eq [
        'ABERLIC.csv',
        'CONTRATO.csv',
        'DISPENSA.csv',
        'HABLIC.csv',
        'HOMOLIC.csv',
        'JULGLIC.csv',
        'PARELIC.csv',
        'REGADESAO.csv',
        'REGLIC.csv',
        'RESPLIC.csv'
      ]
    end

    it "rejects csv file class injection" do
      monthly_monitoring = FactoryGirl.create(:monthly_monitoring, {
        prefecture: prefecture,
        city_code: "51234",
        only_files: ['insecure_class', 'direct_purchase', 'another_insecure_class']
      })

      expect do
        TceExport::MG::MonthlyMonitoring.generate_zip_file(monthly_monitoring)
      end.to raise_error(RuntimeError, 'Invalid csv files: insecure_class, another_insecure_class')
    end

    it "generates a zip file containing only specified CSVs" do
      FactoryGirl.create(:extended_prefecture,
        prefecture: prefecture,
        organ_code: "66",
        organ_kind: "10")

      monthly_monitoring = FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        city_code: "51234",
        only_files: ['contract', 'direct_purchase', 'regulatory_act'])

      TceExport::MG::MonthlyMonitoring.generate_zip_file(monthly_monitoring)
      entries = Zip::ZipFile.open("tmp/AM_51234_66_10_2013.zip").entries.map(&:to_s)
      expect(entries.sort).to eq [
        'CONTRATO.csv',
        'DISPENSA.csv',
        'REGLIC.csv'
      ]
    end
  end
end
