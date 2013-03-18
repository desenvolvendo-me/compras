#encoding: utf-8
class LicitationProcessPublicationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :publication_date, :publication_of, :circulation_type
end