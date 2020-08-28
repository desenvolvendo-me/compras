class AuctionAppealDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :auction, :person, :appeal_date

end
