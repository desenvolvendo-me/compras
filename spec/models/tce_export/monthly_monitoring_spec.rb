require 'model_helper'
require 'app/uploaders/monthly_monitoring_file_uploader'
require 'app/models/tce_export'
require 'app/models/tce_export/monthly_monitoring'

describe TceExport::MonthlyMonitoring do
  it { should belong_to :customer }
  it { should belong_to :prefecture }

  it { should validate_presence_of :month }
  it { should validate_presence_of :year }

  it { should delegate(:organ_code).to(:prefecture).allowing_nil(true) }
  it { should delegate(:organ_kind).to(:prefecture).allowing_nil(true) }

  describe "#control_code" do
    it "returns the string representation of the code" do
      subject.stub(year: 2013)
      subject.control_code = 1

      expect(subject.control_code).to eq "20130000000000000001"
    end
  end

  describe "#date" do
    it "returns a date object representing the month from which the data will be extracted" do
      subject.stub(year: 2013)
      subject.month = 3

      expect(subject.date).to eq Date.new(2013, 3)
    end
  end

  describe "#cancel!" do
    it "sets the status to Cancelled" do
      subject.cancel!

      expect(subject.status).to eq MonthlyMonitoringStatus::CANCELLED
    end
  end

  describe "#set_file" do
    it "sets the file attribute" do
      subject.stub(save!: true)
      file = double

      subject.set_file(file)

      expect(subject.file.to_s).to eq ""
    end

    it "changes the status to Processed" do
      subject.stub(save!: true)

      subject.set_file(double)

      expect(subject.status).to eq MonthlyMonitoringStatus::PROCESSED
    end

    it "changes the status to Processed with errors" do
      subject.stub(save!: true)
      subject.error_message = 'foo'

      subject.set_file(double)

      expect(subject.status).to eq MonthlyMonitoringStatus::PROCESSED_WITH_ERRORS
    end
  end

  describe "#set_errors" do
    it "sets the error message attributes" do
      subject.should_receive(:update_column).with(:error_message, "message")

      subject.set_errors("message")
    end
  end

  context 'Callbacks' do
    describe 'before_save' do
      it 'removes empty values from only_files' do
        subject.only_files = ['foo', nil, 'bar', '']

        subject.run_callbacks :save

        expect(subject.only_files).to eq ['foo', 'bar']
      end
    end
  end
end
