class ReferenceUnitDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :acronym, :to_s => false, :link => :name

  def summary
    component.name
  end
end
