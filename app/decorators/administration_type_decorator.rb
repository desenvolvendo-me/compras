class AdministrationTypeDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :administration, :organ_type
end
