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
      expect(entries).to include("REGLIC.csv", 'RESPLIC.csv', 'REGADESAO.csv',
        'PARELIC.csv', 'JULGLIC.csv', 'HOMOLIC.csv')
    end
  end
end
