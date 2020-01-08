class AdditiveSolicitationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :creditor, :licitation_process

end
