class SignatureDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :person, :position, :to_s => false, :link => :person

  def summary
    position.to_s
  end
end
