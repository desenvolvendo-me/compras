require 'decorator_helper'
require 'app/models/tce_export'
require 'app/decorators/tce_export/monthly_monitoring_decorator'

describe TceExport::MonthlyMonitoringDecorator do
  describe "headers" do
    it 'has control_code and month as headers' do
      expect(described_class.header_attributes).to include :control_code
      expect(described_class.header_attributes).to include :month
    end
  end
end
