class MaterialsClassDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :class_number, :mask
end
