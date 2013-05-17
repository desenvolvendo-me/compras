class MaterialDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :code, :material_class
end
