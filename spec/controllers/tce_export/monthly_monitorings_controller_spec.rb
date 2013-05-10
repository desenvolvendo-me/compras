require 'spec_helper'
require 'sidekiq/testing'

describe TceExport::MonthlyMonitoringsController do
  let :prefecture do
      Prefecture.make!(:belo_horizonte,
        address: Address.make!(:general,
          neighborhood: FactoryGirl.create(:neighborhood,
            city: FactoryGirl.create(:city,
              name: "Newtown",
              tce_mg_code: "51234",
              state: states(:mg)
            )
          )
        )
      )
  end

  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
    controller.stub(current_prefecture: prefecture)

    FactoryGirl.create(:extended_prefecture, prefecture: prefecture)
  end

  describe "GET #new" do
    it 'should set current year as default' do
      get :new

      expect(assigns(:monthly_monitoring).year).to eq Date.current.year
    end
  end

  describe "POST create" do
    it "schedules the zip generation job in the sidekiq queue" do
      expect {
        post :create, monthly_monitoring: { month: 1, year: 2013 }
      }.to change(TceExport::MonthlyMonitoringWorker.jobs, :size).by(1)
    end

    it "assigns the worker job id to the model" do
      TceExport::MonthlyMonitoringWorker.should_receive(:perform_async).and_return("asdf1234")

      post :create, monthly_monitoring: { month: 1, year: 2013 }

      expect(assigns(:monthly_monitoring).job_id).to eq "asdf1234"
    end

    it "assigns the current TCE/MG City code to the object" do
      TceExport::MonthlyMonitoringWorker.stub(perform_async: "asdf1234")

      post :create, monthly_monitoring: { month: 1, year: 2013 }

      expect(assigns(:monthly_monitoring).city_code).to eq 51234
    end
  end
end
