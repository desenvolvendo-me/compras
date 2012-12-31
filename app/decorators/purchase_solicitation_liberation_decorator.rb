# encoding: utf-8
class PurchaseSolicitationLiberationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :sequence, :responsible, :date, :service_status, :to_s => false, :link => [:sequence, :responsible]
end
