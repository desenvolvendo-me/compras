class CondominiumDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :condominium_type, :to_s => false, :link => :name
end
