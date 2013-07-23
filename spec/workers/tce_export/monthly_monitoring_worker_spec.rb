require 'spec_helper'

describe TceExport::MonthlyMonitoringWorker do
  let(:customer) { customers(:customer) }

  let(:prefecture) do
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

  let(:monthly_monitoring) do
    FactoryGirl.create(:monthly_monitoring,
      customer: customer,
      prefecture: prefecture
    )
  end

  let(:monthly_monitoring_with_errors) do
    FactoryGirl.create(:monthly_monitoring,
      customer: customer,
      prefecture: prefecture,
      error_message: 'erro message'
    )
  end

  before do
    Machinist::Caching::Shop.instance.reset!

    FactoryGirl.create(:extended_prefecture,
      organ_code: "66",
      organ_kind: "02",
      prefecture: prefecture)
  end

  it "sets the monitoring status to 'processed'" do
    subject.perform(customer.id, monthly_monitoring.id)

    expect(monthly_monitoring.reload.status).to eq MonthlyMonitoringStatus::PROCESSED
  end

  it "sets the monitoring zip file" do
    subject.perform(customer.id, monthly_monitoring.id)

    expect(monthly_monitoring.reload.file.to_s).to eq "/compras/test.host/tce_export/monthly_monitoring/file/#{monthly_monitoring.id}/AM__66_10_2013.zip"
  end

  it "sets the monitoring status as 'processed with errors' if an error occur" do
    subject.perform(customer.id, monthly_monitoring_with_errors.id)

    expect(monthly_monitoring_with_errors.reload.status).to eq MonthlyMonitoringStatus::PROCESSED_WITH_ERRORS
  end
end
