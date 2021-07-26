require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::PriceRegistrationAccessionGenerator do
  describe "#generate_file" do
    before do
      FileUtils.rm_f('tmp/REGADESAO.csv')
    end

    after do
      FileUtils.rm_f('tmp/REGADESAO.csv')
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

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/REGADESAO.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq ""
    end
  end
end
