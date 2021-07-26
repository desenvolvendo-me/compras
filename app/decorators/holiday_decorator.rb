class HolidayDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :date, :recurrent
end
