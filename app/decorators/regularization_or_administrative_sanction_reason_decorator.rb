class RegularizationOrAdministrativeSanctionReasonDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :reason_type
end
