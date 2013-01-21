class MaterialDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :code, :materials_group, :materials_class
end
