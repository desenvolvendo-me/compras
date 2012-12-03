class UserDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :authenticable, :login, :to_s => false, :link => :authenticable
end
