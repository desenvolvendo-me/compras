class LegalNatureDecorator
  include Decore
  include Decore::Proxy

  def summary
    component.code
  end
end
