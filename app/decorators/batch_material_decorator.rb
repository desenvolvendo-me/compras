class BatchMaterialDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name , :demand_batch
end
