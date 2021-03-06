class UserDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :authenticable, :login, :link => [:authenticable, :login]
end
