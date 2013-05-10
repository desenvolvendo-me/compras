class TceExport::MonthlyMonitoringDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :control_code, :month
end
