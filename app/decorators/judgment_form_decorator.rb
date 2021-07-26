class JudgmentFormDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description,:kind,:licitation_kind

end
