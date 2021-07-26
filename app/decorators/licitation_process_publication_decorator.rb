class LicitationProcessPublicationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :publication_date, :publication_of, :circulation_type

  def publication_date
     super.strftime("%m/%d/%Y") if super
  end
end
