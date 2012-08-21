class Person < Unico::Person
  attr_modal :name, :cpf, :cnpj

  has_many :economic_registrations, :dependent => :restrict
  has_many :licitation_process_impugnments, :dependent => :restrict
  has_many :licitation_process_appeals, :dependent => :restrict
  has_many :partners, :dependent => :destroy
  has_many :creditors, :dependent => :restrict
  has_many :accredited_representatives, :dependent => :restrict
  has_many :licitation_process_bidders, :through => :accredited_representatives

  has_one :employee

  delegate :city, :zip_code, :to => :address
  delegate :benefited, :to => :company_size, :allow_nil => true

  validates :address, :presence => true

  orderize

  scope :except_special_entry, where { personable_type.not_eq 'SpecialEntry' }

  def self.filter(params)
    query = scoped
    query = query.where{ name.matches "#{params[:name]}%" } unless params[:name].blank?
    query = query.joins{ personable Individual }.where{ personable(Individual).cpf == params[:cpf] } unless params[:cpf].blank?
    query = query.joins{ personable Company }.where{ personable(Company).cnpj == params[:cnpj] } unless params[:cnpj].blank?
    query
  end

  def self.search(options = {})
    query = scoped
    query = query.where { id.in_any options[:ids] } if options[:ids].present?
    query
  end

  def personable_attributes=(personable_attributes, options = {})
    self.personable ||= personable_type.constantize.new
    personable.localized.assign_attributes(personable_attributes, options)
  end

  def identity_document
    cpf || cnpj || ''
  end

  def correspondence_address?
    correspondence_address.present?
  end

  def special?
    personable_type == "SpecialEntry"
  end

  def company_size
    personable.company_size if personable.respond_to?(:company_size)
  end

  def choose_simple
    personable.choose_simple if personable.respond_to?(:choose_simple)
  end

  def legal_nature
    personable.legal_nature if personable.respond_to?(:legal_nature)
  end

  def commercial_registration_date
    personable.commercial_registration_date if personable.respond_to?(:commercial_registration_date)
  end

  def commercial_registration_number
    personable.commercial_registration_number if personable.respond_to?(:commercial_registration_number)
  end
end
