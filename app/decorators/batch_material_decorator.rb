class BatchMaterialDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :demand_batch, :material
end
