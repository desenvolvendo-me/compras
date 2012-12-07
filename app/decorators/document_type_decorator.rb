class DocumentTypeDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :validity, :to_s => false, :link => :description
end
