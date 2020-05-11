class Person < Persona::Person
  attr_modal :name, :cpf, :cnpj

  attr_accessor :responsible_id

  has_many :licitation_process_impugnments, dependent: :restrict
  has_many :licitation_process_appeals, dependent: :restrict
  has_many :partners, dependent: :destroy
  has_many :accredited_representatives, dependent: :restrict
  has_many :bidders, through: :accredited_representatives

  has_one :creditor, dependent: :restrict
  has_one :street, through: :address
  has_one :neighborhood, through: :address

  delegate :city, :zip_code, :state, to: :address, allow_nil: true
  delegate :benefited, to: :company_size, allow_nil: true

  validates :address, presence: true

  orderize

  def self.filter(params)
    query = scoped
    query = query.where{ name.matches "#{params[:name]}%" } unless params[:name].blank?
    query = query.joins{ personable Individual }.where{ personable(Individual).cpf == params[:cpf] } unless params[:cpf].blank?
    query = query.joins{ personable Company }.where{ personable(Company).cnpj == params[:cnpj] } unless params[:cnpj].blank?
    query
  end

  scope :term, lambda {|q|
    where {name.like("%#{q}%")}
  }

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

  def company_partners
    personable.partners if personable.respond_to?(:partners)
  end

  def uf_state_registration
    personable.uf_state_registration if personable.respond_to?(:uf_state_registration)
  end

  def state_registration
    personable.state_registration if personable.respond_to?(:state_registration)
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

  def identity_number
    personable.number if personable.respond_to?(:number)
  end
end
