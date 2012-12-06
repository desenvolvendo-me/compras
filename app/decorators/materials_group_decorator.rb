class MaterialsGroupDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :group_number, :to_s => false, :link => :description
end
