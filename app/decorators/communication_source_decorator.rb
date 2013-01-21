class CommunicationSourceDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description
end
