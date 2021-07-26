class SupplyRequestAttendanceDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :sequence, :responsible, :date, :service_status, :link => [:sequence, :responsible]
end
