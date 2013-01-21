class RegulatoryActTypeDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :regulatory_act_type_classification
end
