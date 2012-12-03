class CountryDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :to_s => false, :link => :name
end
