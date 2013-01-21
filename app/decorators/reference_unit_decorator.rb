class ReferenceUnitDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :acronym

  def summary
    component.name
  end
end
