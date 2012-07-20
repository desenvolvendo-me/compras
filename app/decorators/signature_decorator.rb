class SignatureDecorator
  include Decore
  include Decore::Proxy

  def summary
    position.to_s
  end
end
