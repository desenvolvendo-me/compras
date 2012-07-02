class RegistrationCadastralCertificate < Compras::Model
  attr_accessible :building_area, :capital_stock, :capital_whole, :total_area
  attr_accessible :commercial_registry_registration_date, :fiscal_year, :number
  attr_accessible :registration_date, :revocation_date, :specification
  attr_accessible :total_employees, :total_sales, :validity_date
  attr_accessible :commercial_registry_number, :creditor_id

  belongs_to :creditor

  validates :fiscal_year, :specification, :creditor, :presence => true
  validates :registration_date, :validity_date, :revocation_date, :presence => true
  validates :commercial_registry_registration_date, :revocation_date, :timeliness => { :type => :date, :on => :create }, :allow_blank => true
  validates :registration_date, :timeliness => { :on_or_before => :today, :type => :date, :on => :create }, :allow_blank => true
  validates :fiscal_year, :mask => '9999', :allow_blank => true

  orderize :fiscal_year, :id
  filterize

  scope :same_fiscal_year_and_creditor_and_less_than_or_equal_me, lambda { |fiscal_year, creditor_id, id|
    where { |crc| crc.fiscal_year.eq(fiscal_year) & crc.creditor_id.eq(creditor_id) & crc.id.lteq(id) }
  }

  def to_s
    "#{count_crc}/#{fiscal_year}"
  end

  def count_crc
    RegistrationCadastralCertificate.same_fiscal_year_and_creditor_and_less_than_or_equal_me(fiscal_year, creditor_id, id).count
  end
end
