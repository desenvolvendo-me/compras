class StateDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :acronym, :country
end
