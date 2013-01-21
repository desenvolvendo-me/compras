class MaterialsGroupDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :group_number
end
