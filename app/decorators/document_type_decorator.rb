class DocumentTypeDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :validity
end
