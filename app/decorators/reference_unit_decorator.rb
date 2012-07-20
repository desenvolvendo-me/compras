class ReferenceUnitDecorator
  include Decore
  include Decore::Proxy

  def summary
    component.name
  end
end
