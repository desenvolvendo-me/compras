class SignatureDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :person, :position

  def summary
    position.to_s
  end
end
