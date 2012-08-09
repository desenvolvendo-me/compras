class RegistrationCadastralCertificate < Compras::Model
  include Signable

  attr_accessible :building_area, :capital_stock, :capital_whole, :total_area
  attr_accessible :commercial_registry_registration_date, :fiscal_year, :number
  attr_accessible :registration_date, :revocation_date, :specification
  attr_accessible :total_employees, :total_sales, :validity_date
  attr_accessible :commercial_registry_number, :creditor_id

  belongs_to :creditor

  delegate :id, :name, :address, :neighborhood, :email, :city, :state, :country,
           :zip_code, :phone, :fax, :cnpj, :state_registration, :responsible,
           :responsible_identity_document, :main_cnae_code, :main_cnae, :cnaes,
           :documents, :to => :creditor, :prefix => true, :allow_nil => true

  validates :fiscal_year, :specification, :creditor, :presence => true
  validates :registration_date, :validity_date, :presence => true
  validates :commercial_registry_registration_date, :timeliness => { :type => :date, :on => :create }, :allow_blank => true
  validates :registration_date,
    :timeliness => {
      :on_or_before => :today,
      :on_or_before_message => :should_be_on_or_before_today,
      :type => :date,
      :on => :create
    }, :allow_blank => true
  validates :revocation_date,
    :timeliness => {
      :on_or_after => :registration_date,
      :on_or_after_message => :should_be_on_or_after_registration_date,
      :type => :date
    }, :allow_blank => true
  validates :fiscal_year, :mask => '9999', :allow_blank => true
  validate :creditor_must_be_company

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

  protected

  def creditor_must_be_company
    return unless creditor

    errors.add(:creditor, :invalid) unless creditor.company?
  end
end
